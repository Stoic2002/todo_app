import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/data/repositories/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await repository.getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      try {
        await repository.insertTodo(event.todo);
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      try {
        await repository.updateTodo(event.todo);
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      try {
        await repository.deleteTodo(event.id);
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    }
  }
}
