
import 'package:evergreen/data/datasources/local_todo_datasource.dart';
import 'package:evergreen/data/datasources/todo_socket_datasource.dart';
import 'package:evergreen/data/models/todo_model.dart';
import 'package:evergreen/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final LocalTodoDataSource localDataSource;
  final TodoSocketDataSource socketDataSource;

  TodoRepositoryImpl({
    required this.localDataSource,
    required this.socketDataSource,
  }) {
    socketDataSource.connect();
  }

  Stream<Todo> get onTodoAdded => socketDataSource.onTodoAdded;
  Stream<Todo> get onTodoUpdated => socketDataSource.onTodoUpdated;
  Stream<String> get onTodoDeleted => socketDataSource.onTodoDeleted;

  bool get _socketActive => socketDataSource.isConnected;

  @override
  Future<void> addTodo(Todo todo) async {
    if (_socketActive) {
      socketDataSource.addTodo(todo);
    } else {
      await localDataSource.addTodo(todo);
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (_socketActive) {
       socketDataSource.deleteTodo(id);
    } else {
      await localDataSource.deleteTodo(id);
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    if (_socketActive) {
       socketDataSource.updateTodo(todo);
    } else {
      await localDataSource.updateTodo(todo);
    }
  }

  @override
  Future<List<Todo>> getTodos() async {
    if (_socketActive) {
      return await socketDataSource.getTodos();
    } else {
      return await localDataSource.getTodos();
    }
  }
  @override
  Future<int> getCount() async {
    if (_socketActive) {
      return await socketDataSource.getTodos().then((todos) => todos.length);
    } else {
      return await localDataSource.getTodos().then((todos) => todos.length);
    }
  }

  
}
