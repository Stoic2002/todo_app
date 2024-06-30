import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/screens/home_screen.dart';

import 'data/repositories/todo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final todoRepository = TodoRepository();
  await todoRepository.initDatabase();
  runApp(MyApp(todoRepository: todoRepository));
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository;

  const MyApp({Key? key, required this.todoRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(todoRepository)..add(LoadTodos()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
