import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/todo_filter/todo_filter_cubit.dart';

import '../cubits/cubits.dart';
import '../pages/todos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoFilterCubit>(
          create: ((context) => TodoFilterCubit()),
        ),
        BlocProvider<TodoSearchCubit>(
          create: ((context) => TodoSearchCubit()),
        ),
        BlocProvider<TodoListCubit>(
          create: ((context) => TodoListCubit()),
        ),
        BlocProvider<TodoFilterCubit>(
          create: ((context) => TodoFilterCubit()),
        ),
        BlocProvider<ActiveTodoCountCubit>(
          create: ((context) => ActiveTodoCountCubit(
                todoListCubit: BlocProvider.of<TodoListCubit>(context),
              )),
        ),
        BlocProvider<FilteredTodosCubit>(
            create: ((context) => FilteredTodosCubit(
                todoFilterCubit: BlocProvider.of<TodoFilterCubit>(context),
                todoListCubit: BlocProvider.of<TodoListCubit>(context),
                todoSearchCubit: BlocProvider.of<TodoSearchCubit>(context))))
      ],
      child: MaterialApp(
        title: 'TODO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodosPage(),
      ),
    );
  }
}
