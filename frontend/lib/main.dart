import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🟢 Tambahkan import ini kembali

import 'controllers/todo_controller.dart'; // 🟢 Tambahkan import ini kembali

import 'views/login_view.dart';
import 'views/home_page.dart';
import 'views/add_todo_page.dart';
import 'views/register_view.dart'; // 👈 Tambahkan baris ini


void main() {
  runApp(
    // 🟢 Bungkus kembali MyApp dengan ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (_) => TodoController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginView(),
        '/register': (_) => const RegisterView(),
        '/home': (_) => const HomePage(),
        '/add': (_) => const AddTodoPage(),
      },
    );
  }
}
