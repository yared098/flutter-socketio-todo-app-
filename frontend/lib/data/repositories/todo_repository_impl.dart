
// import 'package:arifpay/data/datasources/local_todo_datasource.dart';
// import 'package:arifpay/data/models/todo_model.dart';
// import 'package:arifpay/domain/repositories/todo_repository.dart';

// class TodoRepositoryImpl implements TodoRepository {
//   final LocalTodoDataSource localDataSource;

//   TodoRepositoryImpl(this.localDataSource);

//   @override
//   Future<void> addTodo(Todo todo) => localDataSource.addTodo(todo);

//   @override
//   Future<void> deleteTodo(String id) => localDataSource.deleteTodo(id);

//   @override
//   Future<List<Todo>> getTodos() => localDataSource.getTodos();

//   @override
//   Future<void> updateTodo(Todo todo) => localDataSource.updateTodo(todo);
// }
import 'package:arifpay/data/datasources/local_todo_datasource.dart';
import 'package:arifpay/data/datasources/todo_socket_datasource.dart';
import 'package:arifpay/data/models/todo_model.dart';
import 'package:arifpay/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final LocalTodoDataSource localDataSource;
  final TodoSocketDataSource socketDataSource;

  TodoRepositoryImpl({
    required this.localDataSource,
    required this.socketDataSource,
  }) {
    socketDataSource.connect();
  }

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

  
}
