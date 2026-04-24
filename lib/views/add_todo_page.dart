import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/todo_controller.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  bool _isImportant = false; // Tidak boleh final karena nilainya akan berubah

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan variabel 'ctrl'
    final ctrl = context.read<TodoController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text('Tambah Tugas Baru', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Menggunakan variabel '_formKey'
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text("Tandai sebagai Penting"),
                subtitle: const Text("Tugas akan berwarna merah di daftar"),
                value: _isImportant, // Menggunakan variabel '_isImportant'
                onChanged: (bool value) {
                  setState(() {
                    _isImportant = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Validasi form sebelum simpan
                    if (_formKey.currentState!.validate()) {
                      ctrl.addTodo(
                        _titleCtrl.text,
                        isImportant: _isImportant,
                      );
                      Navigator.pop(context); // Kembali ke HomePage
                    }
                  },
                  child: const Text("Simpan Tugas"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
