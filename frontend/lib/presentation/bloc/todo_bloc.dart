import 'package:evergreen/domain/usecases/add_todo.dart' show AddTodo;
import 'package:evergreen/domain/usecases/delete_todo.dart';
import 'package:evergreen/domain/usecases/get_todos.dart';
import 'package:evergreen/domain/usecases/update_todo.dart';
import 'package:evergreen/presentation/bloc/todo_event.dart';
import 'package:evergreen/presentation/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await getTodos();
        emit(TodoLoaded(todos));
      } catch (_) {
        emit(TodoError("Failed to load todos"));
      }
    });

    on<AddTodoEvent>((event, emit) async {
      await addTodo(event.todo);
      add(LoadTodos());
    });

    on<UpdateTodoEvent>((event, emit) async {
      await updateTodo(event.todo);
      add(LoadTodos());
    });

    on<DeleteTodoEvent>((event, emit) async {
      await deleteTodo(event.id);
      add(LoadTodos());
    });
  }
}
