import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/models/filter.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';
import 'package:flutter_todo/redux/actions/user_actions.dart';
import 'package:flutter_todo/redux/actions/filter_actions.dart';
import 'package:flutter_todo/widgets/helpers/confirm_dialog.dart';
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

  Widget _buildAppBar(BuildContext context, _ViewModel vm) {
    return AppBar(
      title: Text(Configure.AppName),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        PopupMenuButton<Filter>(
          icon: Icon(Icons.filter_list),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<Filter>(
                value: Filter.All,
                child: Text('All'),
              ),
              PopupMenuItem<Filter>(
                value: Filter.Done,
                child: Text('Done'),
              ),
              PopupMenuItem<Filter>(
                value: Filter.NotDone,
                child: Text('Not Done'),
              ),
            ];
          },
          onSelected: (Filter filter) {
            vm.onFilter(filter);
          },
        ),
        PopupMenuButton<String>(
          onSelected: (String choice) async {
            switch (choice) {
              case 'Settings':
                Navigator.pushNamed(context, '/settings');
                break;

              case 'LogOut':
                bool confirm = await ConfirmDialog.show(context);

                if (confirm) {
                  vm.onLogOut();
                }
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              PopupMenuItem<String>(
                value: 'LogOut',
                child: Text('Log out'),
              ),
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
      appBar: _buildAppBar(context, vm),
      floatingActionButton:
          _buildFloatingActionButton(context, vm.isShortcutsEnabled),
      body: TodoListView(
        vm.filter == Filter.All
            ? vm.todos
            : vm.todos
                .where((todo) => todo.isDone == (vm.filter == Filter.Done))
                .toList(),
        vm.onCreate,
        vm.onDelete,
        vm.onToggle,
      ),
    );
  }
}

class _ViewModel {
  final List<Todo> todos;
  final bool isLoading;
  final Filter filter;
  final bool isShortcutsEnabled;
  final OnCreateTodo onCreate;
  final OnDeleteTodo onDelete;
  final OnToggleTodoDone onToggle;
  final OnLogOut onLogOut;
  final OnFilter onFilter;

  _ViewModel({
    @required this.todos,
    @required this.isLoading,
    @required this.filter,
    @required this.isShortcutsEnabled,
    @required this.onCreate,
    @required this.onDelete,
    @required this.onToggle,
    @required this.onLogOut,
    @required this.onFilter,
  });

  factory _ViewModel.from(Store<AppState> store) {
    final AppState state = store.state;

    return _ViewModel(
        todos: state.todos,
        isLoading: state.isLoading,
        filter: state.filter,
        isShortcutsEnabled: state.settings.isShortcutsEnabled,
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
            store.state.user.id,
            onSuccess,
            onError,
          ));
        },
        onDelete: (Todo todo, OnDeleteSuccess onSuccess, OnError onError) {
          store.dispatch(DeleteTodoAction(todo, onSuccess, onError));
        },
        onToggle: (Todo todo, OnError onError) {
          store.dispatch(ToggleTodoDoneAction(todo, onError));
        },
        onLogOut: () {
          store.dispatch(UserLogOutAction());
        },
        onFilter: (Filter filter) {
          store.dispatch(ApplyFilterAction(filter));
        });
  }
}
