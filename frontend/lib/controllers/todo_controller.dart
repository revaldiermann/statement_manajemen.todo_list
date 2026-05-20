import 'dart:convert'; // Keterangan: Diperlukan untuk mengubah data objek/map menjadi string JSON
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http; // Keterangan: Library untuk mengirim request internet ke API CI4
import '../models/todo.dart';

enum FilterOption { all, active, completed }

class TodoController extends ChangeNotifier {
  final List<Todo> _todos = [];
  FilterOption _filter = FilterOption.all;

  List<Todo> get todos {
    switch (_filter) {
      case FilterOption.active:
        return _todos.where((todo) => !todo.completed).toList();
      case FilterOption.completed:
        return _todos.where((todo) => todo.completed).toList();
      default:
        return _todos;
    }
  }

  int get totalCount => _todos.length;
  int get activeCount => _todos.where((todo) => !todo.completed).length;
  int get completedCount => _todos.where((todo) => todo.completed).length;

  void addTodo(String title, {bool isImportant = false}) {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      isImportant: isImportant,
    );
    _todos.add(todo);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        completed: !_todos[index].completed,
      );
      notifyListeners();
    }
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void setFilter(FilterOption filter) {
    _filter = filter;
    notifyListeners();
  }

  // ================= 🟢 FUNGSI BARU: REGISTRASI USER VIA API CI4 =================
  
  /// Fungsi untuk mendaftarkan user baru ke database MySQL melalui backend CodeIgniter 4.
  /// Mengembalikan nilai [true] jika berhasil (status 201) dan [false] jika gagal/error.
  Future<bool> registerUser(String username, String password) async {
    // Keterangan URL:
    // Gunakan 'http://10.0.2' jika Anda menguji menggunakan Emulator Android bawaan.
    // Jika Anda menggunakan HP fisik, ganti '10.0.2.2' dengan alamat IP lokal laptop Anda.
    // final url = Uri.parse('http://10.0.2');
    final url = Uri.parse('http://localhost:8080/register');

    try {
      // Mengirimkan request POST ke server CodeIgniter 4
      final response = await http.post(
        url,
        // Memberitahu server backend bahwa data yang dikirimkan berbentuk JSON format
        headers: {'Content-Type': 'application/json'},
        // Mengubah Map berisi username & password menjadi teks string JSON mentah
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      // Mengecek respons status kode dari backend CodeIgniter 4.
      // Kode 201 artinya 'Created' atau data user baru berhasil masuk ke database MySQL.
      if (response.statusCode == 201) {
        return true; 
      } else {
        // Jika server merespons selain 201 (misalnya 400 karena username sudah ada atau field kosong)
        return false; 
      }
    } catch (e) {
      // Menangkap error jika laptop belum menyalakan 'php spark serve' atau HP tidak terkoneksi internet
      if (kDebugMode) {
        print("Error Jaringan / Server Mati: $e");
      }
      return false; 
    }
  }
}
