import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/transaction_model.dart';
import 'transaction_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> _transactions = [];
  int _totalBalance = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getTransactions();
    int balance = 0;
    for (var item in data) {
      if (item.type == 'Pemasukan') {
        balance += item.amount;
      } else {
        balance -= item.amount;
      }
    }

    if (mounted) {
      setState(() {
        _transactions = data;
        _totalBalance = balance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = DatabaseHelper.currentUser;
    final userName = user?.name ?? 'Zahran';
    final userEmail = user?.email ?? 'zahran@student.ac.id';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Keuangan'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      // Tombol mengambang (FAB) untuk tambah transaksi
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () async {
          // Memanggil Rute yang sudah didaftarkan di main.dart
          await Navigator.pushNamed(context, '/add');
          _loadData();
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $userName',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Email: $userEmail',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            _buildBalanceCard(),
            const SizedBox(height: 20),
            const Text(
              'Transaksi Terakhir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTransactionList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      elevation: 4,
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo Utama',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DatabaseHelper.formatRupiah(_totalBalance),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    if (_transactions.isEmpty) {
      return const Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('Belum ada transaksi')),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Column(
        children: List.generate(_transactions.length, (index) {
          final item = _transactions[index];
          final isIncome = item.type == 'Pemasukan';
          final formattedAmount =
              '${isIncome ? '+' : '-'} ${DatabaseHelper.formatRupiah(item.amount)}';

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: isIncome ? Colors.green : Colors.orange,
                  child: Icon(
                    isIncome ? Icons.attach_money : Icons.fastfood,
                    color: Colors.white,
                  ),
                ),
                title: Text(item.title),
                subtitle: Text(item.date),
                trailing: Text(
                  formattedAmount,
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailScreen(
                        title: item.title,
                        amount: formattedAmount,
                        category: item.category,
                        date: item.date,
                      ),
                    ),
                  );
                },
              ),
              if (index < _transactions.length - 1) const Divider(height: 1),
            ],
          );
        }),
      ),
    );
  }
}