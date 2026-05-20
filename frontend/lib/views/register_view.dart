import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/todo_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // GlobalKey digunakan untuk memvalidasi status form input
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk menangkap teks yang diketik user
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // State untuk mengatur loading indicator saat tombol ditekan
  bool _isLoading = false;

  @override
  void dispose() {
    // Menghapus controller dari memori jika halaman ditutup agar tidak membebani HP
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _prosesDaftar() async {
    // 1. Cek apakah inputan sudah memenuhi syarat validasi
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Nyalakan animasi loading
    });

    // 2. Ambil data dari textfield
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // 3. Panggil fungsi di TodoController via Provider
    final todoController = context.read<TodoController>();
    final isSuccess = await todoController.registerUser(username, password);

    setState(() {
      _isLoading = false; // Matikan animasi loading
    });

    // 4. Cek Hasil Respons dari Server CI4
    if (mounted) {
      if (isSuccess) {
        // Tampilkan pesan sukses jika server merespons kode 201
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi Berhasil! Silakan Login.'),
            backgroundColor: Colors.green,
          ),
        );
        // Kembali otomatis ke halaman login view
        Navigator.pop(context);
      } else {
        // Tampilkan pesan gagal jika username duplikat / server error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi Gagal! Username sudah digunakan / server bermasalah.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Buat Akun Baru'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey, // Pasang kunci form di sini
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Daftar Akun',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ================= TEXTFIELD USERNAME =================
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        if (value.trim().length < 4) {
                          return 'Username minimal 4 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ================= TEXTFIELD PASSWORD =================
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true, // Menyembunyikan ketikan password
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.trim().length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // ================= TOMBOL REGISTER / LOADING =================
                    ElevatedButton(
                      onPressed: _isLoading ? null : _prosesDaftar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'DAFTAR SEKARANG',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
