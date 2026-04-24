import 'package:flutter/foundation.dart';
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
}
