import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Fallback penyimpanan memori saat dijalankan di Chrome (Web)
  static final List<UserModel> _webUsers = [];
  static final List<TransactionModel> _webTransactions = [
    TransactionModel(
      id: 1,
      title: 'Makan Siang',
      amount: 50000,
      type: 'Pengeluaran',
      category: 'Makanan',
      date: '13 September 2026',
    ),
    TransactionModel(
      id: 2,
      title: 'Gaji Bulanan',
      amount: 9000000,
      type: 'Pemasukan',
      category: 'Pemasukan',
      date: '1 September 2026',
    ),
  ];

  // Menyimpan data user yang sedang login
  static UserModel? currentUser;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount INTEGER NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // Data awal sesuai modul
    await db.insert('transactions', {
      'title': 'Makan Siang',
      'amount': 50000,
      'type': 'Pengeluaran',
      'category': 'Makanan',
      'date': '13 September 2026',
    });

    await db.insert('transactions', {
      'title': 'Gaji Bulanan',
      'amount': 9000000,
      'type': 'Pemasukan',
      'category': 'Pemasukan',
      'date': '1 September 2026',
    });
  }

  // ================= FUNGSI REGISTER & LOGIN =================

  Future<bool> registerUser(UserModel user) async {
    if (kIsWeb) {
      final exists = _webUsers.any((u) => u.email == user.email);
      if (exists) return false;
      _webUsers.add(
        UserModel(
          id: _webUsers.length + 1,
          name: user.name,
          email: user.email,
          password: user.password,
        ),
      );
      return true;
    }

    final db = await instance.database;
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user.email],
    );
    if (existing.isNotEmpty) {
      return false;
    }

    await db.insert('users', user.toMap());
    return true;
  }

  Future<UserModel?> loginUser(String email, String password) async {
    if (kIsWeb) {
      try {
        final user = _webUsers.firstWhere(
          (u) => u.email == email && u.password == password,
        );
        currentUser = user;
        return user;
      } catch (_) {
        return null;
      }
    }

    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      final user = UserModel.fromMap(result.first);
      currentUser = user;
      return user;
    }
    return null;
  }

  // ================= FUNGSI TRANSAKSI =================

  Future<void> insertTransaction(TransactionModel transaction) async {
    if (kIsWeb) {
      _webTransactions.insert(
        0,
        TransactionModel(
          id: _webTransactions.length + 1,
          title: transaction.title,
          amount: transaction.amount,
          type: transaction.type,
          category: transaction.category,
          date: transaction.date,
        ),
      );
      return;
    }

    final db = await instance.database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions() async {
    if (kIsWeb) {
      return List<TransactionModel>.from(_webTransactions);
    }

    final db = await instance.database;
    final result = await db.query('transactions', orderBy: 'id DESC');
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  static String formatRupiah(int number) {
    String str = number.abs().toString();
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return 'Rp $result';
  }
}