import 'dart:async';

import 'package:arifpay/data/models/todo_model.dart';
import 'package:arifpay/data/repositories/todo_repository_impl.dart';
import 'package:arifpay/presentation/bloc/todo_bloc.dart';
import 'package:arifpay/presentation/bloc/todo_event.dart';
import 'package:arifpay/presentation/bloc/todo_state.dart';
import 'package:arifpay/presentation/widgets/search_form.dart';
import 'package:arifpay/presentation/widgets/todo_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  bool showForm = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _searchController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? editingId;
  String _searchQuery = '';
  int _counttodos = 0;
  String _datasource = "";

  late final StreamSubscription<Todo> _addedSub;
  late final StreamSubscription<Todo> _updatedSub;
  late final StreamSubscription<String> _deletedSub;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    // for socket initi
    final repo = context.read<TodoRepositoryImpl>();
    final isSocket = repo.socketDataSource.isConnected;

    if (isSocket) {
      _datasource = "Socket";
    } else {
      _datasource = "Local";
    }

    loadCount(repo);

    _addedSub = repo.onTodoAdded.listen((todo) {
      _showInfo("${todo.title} was added by someone else");
      context.read<TodoBloc>().add(LoadTodos());
      loadCount(repo);
    });

    _updatedSub = repo.onTodoUpdated.listen((todo) {
      _showInfo("${todo.title} was updated by someone else");
      context.read<TodoBloc>().add(LoadTodos());
      loadCount(repo);
    });

    _deletedSub = repo.onTodoDeleted.listen((id) {
      _showInfo("A todo was deleted by someone else");
      context.read<TodoBloc>().add(LoadTodos());
      loadCount(repo);
    });

    context.read<TodoBloc>().add(LoadTodos());
  }

  Future<void> loadCount(repo) async {
    int count = await repo.getCount();
    setState(() {
      _counttodos = count;
    });
  }

  void _showInfo(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    ),
  );
}


  void _toggleForm([Todo? todo]) {
    if (todo != null) {
      editingId = todo.id;
      _titleController.text = todo.title;
      _descriptionController.text = todo.description ?? '';
    } else {
      editingId = null;
      _titleController.clear();
      _descriptionController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return TodoFormWidget(
          formKey: _formKey,
          titleController: _titleController,
          descriptionController: _descriptionController,
          isEditing: editingId != null,
          onSubmit: () {
            _submitForm();
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if (editingId != null) {
        context.read<TodoBloc>().add(
          UpdateTodoEvent(
            Todo(
              id: editingId!,
              title: title,
              description: description,
              isCompleted: false,
            ),
          ),
        );
      } else {
        context.read<TodoBloc>().add(
          AddTodoEvent(
            Todo(
              id: DateTime.now().toString(),
              title: title,
              description: description,
              isCompleted: false,
            ),
          ),
        );
      }
      _toggleForm();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _addedSub.cancel();
    _updatedSub.cancel();
    _deletedSub.cancel();
    _searchController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _datasource,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),

                if (_datasource == "Socket") ...[
                  // User count inside a CircleAvatar
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      '$_counttodos',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Online status icon inside CircleAvatar
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.online_prediction,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),

      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Search Bar
                SearchForm(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                // Todo List
                Expanded(
                  child: BlocBuilder<TodoBloc, TodoState>(
                    builder: (context, state) {
                      if (state is TodoLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TodoLoaded) {
                        final filteredTodos =
                            state.todos.where((todo) {
                              return todo.title.toLowerCase().contains(
                                _searchQuery,
                              );
                            }).toList();

                        if (filteredTodos.isEmpty) {
                          return const Center(
                            child: Text('No matching todos.'),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            final todo = filteredTodos[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  todo.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(todo.description ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Edit
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _toggleForm(todo),
                                        tooltip: 'Edit',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Delete
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.red),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          context.read<TodoBloc>().add(
                                            DeleteTodoEvent(todo.id),
                                          );
                                        },
                                        tooltip: 'Delete',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: Text('No data'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _toggleForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
