import 'dart:async';
import 'package:evergreen/data/models/todo_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


abstract class TodoSocketDataSource {
  void connect();
  void disconnect();
  void addTodo(Todo todo);
  void updateTodo(Todo todo);
  void deleteTodo(String id);
  

  Future<List<Todo>> getTodos(); 
   bool get isConnected; 

  Stream<Todo> get onTodoAdded;
  Stream<Todo> get onTodoUpdated;
  Stream<String> get onTodoDeleted;
  
}

class TodoSocketDataSourceImpl implements TodoSocketDataSource {
  late IO.Socket _socket;

  final _todoAddedController = StreamController<Todo>.broadcast();
  final _todoUpdatedController = StreamController<Todo>.broadcast();
  final _todoDeletedController = StreamController<String>.broadcast();

  bool _connected = false;
  bool get isConnected => _connected;

  // Completer to handle getTodos async response
  Completer<List<Todo>>? _getTodosCompleter;

  @override
  void connect() {
    _socket = IO.io('http://127.0.0.0:3002', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.on('connect', (_) {
      _connected = true;
      print('Socket connected');
    });

    _socket.on('disconnect', (_) {
      _connected = false;
      print('Socket disconnected');
    });

    _socket.on('todoAdded', (data) {
      final todo = Todo.fromJson(data);
      _todoAddedController.add(todo);
    });

    _socket.on('todoUpdated', (data) {
      final todo = Todo.fromJson(data);
      _todoUpdatedController.add(todo);
    });

    _socket.on('todoDeleted', (id) {
      _todoDeletedController.add(id);
    });

    // Listen for the todos list response
    _socket.on('todosList', (data) {
      final todos = (data as List).map((json) => Todo.fromJson(json)).toList();
      if (_getTodosCompleter != null && !_getTodosCompleter!.isCompleted) {
        _getTodosCompleter!.complete(todos);
      }
    });
  }

  @override
  void disconnect() {
    _socket.dispose();
    _connected = false;
  }

  @override
  void addTodo(Todo todo) {
    if (isConnected) _socket.emit('addTodo', todo.toJson());
  }

  @override
  void updateTodo(Todo todo) {
    if (isConnected) _socket.emit('updateTodo', todo.toJson());
  }

  @override
  void deleteTodo(String id) {
    if (isConnected) _socket.emit('deleteTodo', id);
  }

  @override
  Future<List<Todo>> getTodos() {
    if (!isConnected) {
      // Return empty list or throw an error as socket is disconnected
      return Future.value([]);
    }

    // If previous request exists and is not completed, return that future
    if (_getTodosCompleter != null && !_getTodosCompleter!.isCompleted) {
      return _getTodosCompleter!.future;
    }

    _getTodosCompleter = Completer<List<Todo>>();
    _socket.emit('getTodos'); // Request todos from server

    return _getTodosCompleter!.future;
  }

  @override
  Stream<Todo> get onTodoAdded => _todoAddedController.stream;

  @override
  Stream<Todo> get onTodoUpdated => _todoUpdatedController.stream;

  @override
  Stream<String> get onTodoDeleted => _todoDeletedController.stream;
}
