import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:todo_app/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:todo_app/cubits/todo_list/todo_list_cubit.dart';
import 'package:todo_app/cubits/todo_search/todo_search_cubit.dart';
import 'package:todo_app/models/todo_model.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoListSubscription;
  late StreamSubscription todoSearchSubscription;

  final List<Todo> initialTodos;
  final TodoFilterCubit todoFilterCubit;
  final TodoListCubit todoListCubit;
  final TodoSearchCubit todoSearchCubit;
  FilteredTodosCubit({
    required this.initialTodos,
    required this.todoFilterCubit,
    required this.todoListCubit,
    required this.todoSearchCubit,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    todoFilterSubscription =
        todoFilterCubit.stream.listen((TodoFilterState todoFilterState) {
      setFilteredTodos();
    });
    todoFilterSubscription =
        todoSearchCubit.stream.listen((TodoSearchState todoSearchState) {
      setFilteredTodos();
    });
    todoFilterSubscription =
        todoListCubit.stream.listen((TodoListState todoListState) {
      setFilteredTodos();
    });
  }

  void setFilteredTodos() {
    List<Todo> _filteredTodos;

    switch (todoFilterCubit.state.filter) {
      case Filter.active:
        _filteredTodos = todoListCubit.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        _filteredTodos = todoListCubit.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todoListCubit.state.todos;

        break;
    }

    if (todoSearchCubit.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) => todo.desc
              .toLowerCase()
              .contains(todoSearchCubit.state.searchTerm))
          .toList();
    }
    emit(state.copyWith(filteredTodos: _filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoListSubscription.cancel();
    todoSearchSubscription.cancel();

    return super.close();
  }
}
