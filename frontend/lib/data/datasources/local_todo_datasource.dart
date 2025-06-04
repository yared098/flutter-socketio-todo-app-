
import 'package:evergreen/data/models/todo_model.dart';

class LocalTodoDataSource {
  final List<Todo> _todos = [];

  Future<List<Todo>> getTodos() async => _todos;

  Future<void> addTodo(Todo todo) async => _todos.add(todo);

  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
  }

  Future<void> deleteTodo(String id) async => _todos.removeWhere((t) => t.id == id);
}
