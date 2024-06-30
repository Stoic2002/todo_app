import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/data/models/todo_model.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  const EditTodoScreen({Key? key, required this.todo}) : super(key: key);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _title = widget.todo.title;
    _description = widget.todo.description;
    _dueDate = widget.todo.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                      'Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dueDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final updatedTodo = Todo(
                      id: widget.todo.id,
                      title: _title,
                      description: _description,
                      dueDate: _dueDate,
                      isCompleted: widget.todo.isCompleted,
                    );
                    BlocProvider.of<TodoBloc>(context)
                        .add(UpdateTodo(updatedTodo));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
