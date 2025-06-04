import 'package:arifpay/data/models/todo_model.dart';
import '../repositories/todo_repository.dart';

class AddTodo {
  final TodoRepository repository;

  AddTodo(this.repository);

  Future<void> call(Todo todo) {
    return repository.addTodo(todo);
  }
}