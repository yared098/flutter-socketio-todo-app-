import 'package:evergreen/data/models/todo_model.dart';


import '../repositories/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<void> call(Todo todo) {
    return repository.updateTodo(todo);
  }
}