import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/todo_controller.dart';
import '../models/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TodoController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,

        title: const Text(
          "To-Do Manager",
          style: TextStyle(color: Colors.white),
        ),

        actions: [
          // ================= LOGOUT BUTTON =================
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),

            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false, // Menghapus semua riwayat halaman sebelumnya
              );
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),

            decoration: const BoxDecoration(
              color: Colors.deepPurple,

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'To-Do Manager',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                // ================= STATISTIK =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    _buildStatCard(
                      'Total',
                      ctrl.totalCount.toString(),
                      Icons.list_alt,
                      Colors.white24,
                    ),

                    _buildStatCard(
                      'Aktif',
                      ctrl.activeCount.toString(),
                      Icons.assignment_late_outlined,
                      Colors.orange,
                    ),

                    _buildStatCard(
                      'Selesai',
                      ctrl.completedCount.toString(),
                      Icons.check_circle_outline,
                      Colors.greenAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ================= JUDUL =================
          const Padding(
            padding: EdgeInsets.all(20),

            child: Row(
              children: [
                Icon(Icons.assignment_turned_in, color: Colors.deepPurple),

                SizedBox(width: 10),

                Text(
                  'Daftar Tugas',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),

          // ================= LIST TODO =================
          Expanded(
            child: ctrl.todos.isEmpty
                ? const Center(child: Text("Belum ada tugas"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    itemCount: ctrl.todos.length,

                    itemBuilder: (context, index) {
                      final Todo todo = ctrl.todos[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(12),

                              blurRadius: 10,

                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),

                          // ================= CHECK TODO =================
                          leading: IconButton(
                            icon: Icon(
                              todo.completed
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,

                              color: todo.completed
                                  ? Colors.green
                                  : Colors.grey,
                            ),

                            // onPressed: () {
                            //   ctrl.toggleTodo(todo.id);
                            // },
                            onPressed: () {
                              // 🟢 Lebih aman dan efisien untuk fungsi aksi / klik
                              context.read<TodoController>().toggleTodo(
                                todo.id,
                              );
                            },
                          ),

                          // ================= TITLE =================
                          title: Row(
                            children: [
                              if (todo.isImportant)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8),

                                  child: Icon(
                                    Icons.priority_high,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                ),

                              Expanded(
                                child: Text(
                                  todo.title,

                                  style: TextStyle(
                                    fontSize: 16,

                                    fontWeight: FontWeight.w600,

                                    decoration: todo.completed
                                        ? TextDecoration.lineThrough
                                        : null,

                                    color: todo.completed
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // ================= DELETE =================
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),

                            onPressed: () {
                              ctrl.removeTodo(todo.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },

        backgroundColor: Colors.deepPurple,

        label: const Text(
          'Tambah Tugas',

          style: TextStyle(color: Colors.white),
        ),

        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ================= WIDGET CARD =================
  Widget _buildStatCard(
    String label,
    String count,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      width: 100,

      padding: const EdgeInsets.symmetric(vertical: 15),

      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),

          const SizedBox(height: 8),

          Text(
            count,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            label,

            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
