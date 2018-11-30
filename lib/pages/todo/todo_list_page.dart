import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';
import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/widgets/todo/shortcuts_enabled_todo_fab.dart';
import 'package:flutter_todo/widgets/todo/todo_list_view.dart';

class TodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (Store store) => _ViewModel.from(store),
      builder: (BuildContext context, _ViewModel vm) {
        Stack stack = Stack(
          children: <Widget>[
            _buildPageContent(context, vm),
          ],
        );

        if (vm.isLoading) {
          stack.children.add(LoadingModal());
        }

        return stack;
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(Configure.AppName),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.lock),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          onSelected: (String choice) {
            switch (choice) {
              case 'Settings':
                Navigator.pushNamed(context, '/settings');
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              )
            ];
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    bool isShortcutsEnabled,
  ) {
    if (isShortcutsEnabled) {
      return ShortcutsEnabledTodoFab();
    }

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, '/editor');
      },
    );
  }

  Widget _buildPageContent(BuildContext context, _ViewModel vm) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton:
          _buildFloatingActionButton(context, vm.isShortcutsEnabled),
      body: TodoListView(
        vm.todos,
        vm.onDelete,
        vm.onToggle,
      ),
    );
  }
}

class _ViewModel {
  final List<Todo> todos;
  final bool isLoading;
  final bool isShortcutsEnabled;
  final OnDeleteTodo onDelete;
  final OnToggleTodoDone onToggle;

  _ViewModel({
    @required this.todos,
    @required this.isLoading,
    @required this.isShortcutsEnabled,
    @required this.onDelete,
    @required this.onToggle,
  });

  factory _ViewModel.from(Store<AppState> store) {
    final AppState state = store.state;

    return _ViewModel(
      todos: state.todos,
      isLoading: state.isLoading,
      isShortcutsEnabled: state.settings.isShortcutsEnabled,
      onDelete: (String id, OnError onError) {
        store.dispatch(DeleteTodoAction(id, onError));
      },
      onToggle: (Todo todo, OnError onError) {
        store.dispatch(ToggleTodoDoneAction(todo, onError));
      },
    );
  }
}
