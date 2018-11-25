import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';
import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/widgets/todo/todo_editor.dart';

class TodoEditorPage extends StatelessWidget {
  final String id;

  TodoEditorPage(this.id);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.from(store, this.id),
      builder: (context, vm) {
        Stack stack = Stack(
          children: <Widget>[
            TodoEditor(vm.todo, vm.onCreate, vm.onUpdate),
          ],
        );

        if (vm.isLoading) {
          stack.children.add(LoadingModal());
        }

        return stack;
      },
    );
  }
}

class _ViewModel {
  final Todo todo;
  final bool isLoading;
  final OnCreateTodo onCreate;
  final OnUpdateTodo onUpdate;

  _ViewModel({
    @required this.todo,
    @required this.isLoading,
    @required this.onCreate,
    @required this.onUpdate,
  });

  factory _ViewModel.from(Store<AppState> store, String id) {
    final Todo todo = id != null
        ? store.state.todos.where((todo) => todo.id == id).first
        : null;

    return _ViewModel(
      todo: todo,
      isLoading: store.state.isLoading,
      onCreate: (
        String title,
        String content,
        Priority priority,
        bool isDone,
        OnSuccess onSuccess,
        OnError onError,
      ) {
        store.dispatch(CreateTodoAction(
          title,
          content,
          priority,
          isDone,
          'userId',
          onSuccess,
          onError,
        ));
      },
      onUpdate: (
        todo,
        OnSuccess onSuccess,
        OnError onError,
      ) {
        store.dispatch(UpdateTodoAction(
          todo,
          onSuccess,
          onError,
        ));
      },
    );
  }
}
