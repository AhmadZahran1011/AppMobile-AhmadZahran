import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Kabataku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const KalkulatorPage(),
    );
  }
}

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _angka1Controller = TextEditingController();
  final TextEditingController _angka2Controller = TextEditingController();

  String _hasil = 'Hasil akan muncul di sini';

  void _hitung(String operator) {
    // Validasi input terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    double angka1 = double.parse(_angka1Controller.text);
    double angka2 = double.parse(_angka2Controller.text);
    double hasil = 0;

    setState(() {
      switch (operator) {
        case '+':
          hasil = angka1 + angka2;
          _hasil = 'Hasil: ${angka1.toStringAsFixed(2)} + '
              '${angka2.toStringAsFixed(2)} = ${hasil.toStringAsFixed(2)}';
          break;
        case '-':
          hasil = angka1 - angka2;
          _hasil = 'Hasil: ${angka1.toStringAsFixed(2)} - '
              '${angka2.toStringAsFixed(2)} = ${hasil.toStringAsFixed(2)}';
          break;
        case '×':
          hasil = angka1 * angka2;
          _hasil = 'Hasil: ${angka1.toStringAsFixed(2)} × '
              '${angka2.toStringAsFixed(2)} = ${hasil.toStringAsFixed(2)}';
          break;
        case '÷':
          if (angka2 == 0) {
            _hasil = 'Error: Tidak bisa membagi dengan nol';
          } else {
            hasil = angka1 / angka2;
            _hasil = 'Hasil: ${angka1.toStringAsFixed(2)} ÷ '
                '${angka2.toStringAsFixed(2)} = ${hasil.toStringAsFixed(2)}';
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    _angka1Controller.dispose();
    _angka2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Kabataku'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              // Input pertama
              TextFormField(
                controller: _angka1Controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Angka Pertama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Angka pertama tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input kedua
              TextFormField(
                controller: _angka2Controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Angka Kedua',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Angka kedua tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tombol operasi kabataku (kali, bagi, tambah, kurang)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _hitung('+'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('+', style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () => _hitung('-'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('-', style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () => _hitung('×'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('×', style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () => _hitung('÷'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('÷', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Widget Text untuk menampilkan hasil
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  _hasil,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}