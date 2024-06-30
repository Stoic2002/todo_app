import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/data/models/todo_model.dart';

import '../screens/edit_todo_screen.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${todo.description}\nDue: ${DateFormat('yyyy-MM-dd').format(todo.dueDate)}',
        ),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (bool? value) {
            BlocProvider.of<TodoBloc>(context).add(
              UpdateTodo(
                Todo(
                  id: todo.id,
                  title: todo.title,
                  description: todo.description,
                  dueDate: todo.dueDate,
                  isCompleted: value!,
                ),
              ),
            );
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTodoScreen(todo: todo),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Todo"),
                      content: const Text(
                          "Are you sure you want to delete this todo?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text("Delete"),
                          onPressed: () {
                            BlocProvider.of<TodoBloc>(context)
                                .add(DeleteTodo(todo.id!));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
