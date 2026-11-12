import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/transaction_model.dart';
import 'transaction_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await DatabaseHelper.instance.getTransactions();
    if (mounted) {
      setState(() {
        _transactions = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _transactions.isEmpty
          ? const Center(child: Text('Belum ada riwayat transaksi'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final item = _transactions[index];
                final isIncome = item.type == 'Pemasukan';
                final formattedAmount =
                    '${isIncome ? '+' : '-'} ${DatabaseHelper.formatRupiah(item.amount)}';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isIncome ? Colors.green : Colors.orange,
                      child: Icon(
                        isIncome ? Icons.attach_money : Icons.fastfood,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${item.category} • ${item.date}'),
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
                );
              },
            ),
    );
  }
}