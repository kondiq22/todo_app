import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../blocs.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoListSubscription;
  late StreamSubscription todoSearchSubscription;

  final List<Todo> initialTodos;

  final TodoFilterBloc todoFilterBloc;
  final TodoListBloc todoListBloc;
  final TodoSearchBloc todoSearchBloc;
  FilteredTodosBloc({
    required this.initialTodos,
    required this.todoFilterBloc,
    required this.todoListBloc,
    required this.todoSearchBloc,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    todoFilterSubscription =
        todoFilterBloc.stream.listen((TodoFilterState todoFilterState) {
      setFilteredTodos();
    });
    todoFilterSubscription =
        todoSearchBloc.stream.listen((TodoSearchState todoSearchState) {
      setFilteredTodos();
    });
    todoFilterSubscription =
        todoListBloc.stream.listen((TodoListState todoListState) {
      setFilteredTodos();
    });
    on<CalculateFilteredTodosEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
  }
  void setFilteredTodos() {
    List<Todo> _filteredTodos;

    switch (todoFilterBloc.state.filter) {
      case Filter.active:
        _filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        _filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todoListBloc.state.todos;

        break;
    }

    if (todoSearchBloc.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) =>
              todo.desc.toLowerCase().contains(todoSearchBloc.state.searchTerm))
          .toList();
    }
    add(CalculateFilteredTodosEvent(filteredTodos: _filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoListSubscription.cancel();
    todoSearchSubscription.cancel();

    return super.close();
  }
}
