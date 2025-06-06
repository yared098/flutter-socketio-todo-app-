import 'package:evergreen/data/datasources/local_todo_datasource.dart';
import 'package:evergreen/data/datasources/todo_socket_datasource.dart';
import 'package:evergreen/data/repositories/todo_repository_impl.dart';
import 'package:evergreen/domain/usecases/add_todo.dart';
import 'package:evergreen/domain/usecases/delete_todo.dart';
import 'package:evergreen/domain/usecases/get_todos.dart';
import 'package:evergreen/domain/usecases/update_todo.dart';
import 'package:evergreen/presentation/bloc/todo_bloc.dart';
import 'package:evergreen/presentation/bloc/todo_event.dart';
import 'package:evergreen/presentation/pages/splash_screen.dart';
import 'package:evergreen/presentation/pages/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final localDataSource = LocalTodoDataSource();
  final socketDataSource = TodoSocketDataSourceImpl();
  final repository = TodoRepositoryImpl(
    localDataSource: localDataSource,
    socketDataSource: socketDataSource,
  );

  runApp(
    RepositoryProvider<TodoRepositoryImpl>(
      create: (_) => repository,
      child: MyApp(
        todoBloc: TodoBloc(
          getTodos: GetTodos(repository),
          addTodo: AddTodo(repository),
          updateTodo: UpdateTodo(repository),
          deleteTodo: DeleteTodo(repository),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final TodoBloc todoBloc;
  const MyApp({super.key, required this.todoBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => todoBloc..add(LoadTodos()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/todo': (context) => const TodoPage(),
        },
      ),
    );
  }
}



