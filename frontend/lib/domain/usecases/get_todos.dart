import 'package:arifpay/data/models/todo_model.dart';

import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<List<Todo>> call() {
    return repository.getTodos();
  }
}
