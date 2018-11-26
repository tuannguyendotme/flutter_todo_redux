import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/helpers/message_dialog.dart';
import 'package:flutter_todo/widgets/todo/todo_card.dart';
import 'package:flutter_todo/typedefs.dart';

class TodoListView extends StatefulWidget {
  final List<Todo> todos;
  final OnDeleteTodo onDelete;
  final OnToggleTodoDone onToggle;

  TodoListView(
    this.todos,
    this.onDelete,
    this.onToggle,
  );

  @override
  State<StatefulWidget> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  @override
  Widget build(BuildContext context) {
    Widget todoCards =
        widget.todos.length > 0 ? _buildListView() : _buildEmptyText();

    return todoCards;
  }

  Widget _buildEmptyText() {
    String emptyText =
        'This is boring here. \r\nCreate a Not Done todo to make it crowd.';

    Widget svg = new SvgPicture.asset(
      'assets/todo_list.svg',
      width: 200,
    );

    return Container(
      color: Color.fromARGB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          svg,
          SizedBox(
            height: 40.0,
          ),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: widget.todos.length,
      itemBuilder: (BuildContext context, int index) {
        Todo todo = widget.todos[index];

        return Dismissible(
          key: Key(todo.id),
          onDismissed: (DismissDirection direction) {
            widget.onDelete(
              todo.id,
              _onError,
            );
          },
          child: TodoCard(todo, widget.onToggle, _onError),
          background: Container(color: Colors.red),
        );
      },
    );
  }

  void _onError(String message) {
    MessageDialog.show(context, message: message);
  }
}
