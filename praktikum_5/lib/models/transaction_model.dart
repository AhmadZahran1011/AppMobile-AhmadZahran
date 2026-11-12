class TransactionModel {
  final int? id;
  final String title;
  final int amount;
  final String type; // 'Pemasukan' atau 'Pengeluaran'
  final String category;
  final String date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: map['amount'] as int,
      type: map['type'] as String,
      category: map['category'] as String,
      date: map['date'] as String,
    );
  }
}