import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_todo_redux/models/todo.dart';
import 'package:flutter_todo_redux/widgets/helpers/message_dialog.dart';
import 'package:flutter_todo_redux/widgets/todo/todo_card.dart';
import 'package:flutter_todo_redux/typedefs.dart';

class TodoListView extends StatefulWidget {
  final List<Todo> todos;
  final OnCreateTodo onCreate;
  final OnDeleteTodo onDelete;
  final OnToggleTodoDone onToggle;

  TodoListView(
    this.todos,
    this.onCreate,
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
              todo,
              _onSuccess,
              _onError,
            );
          },
          child: TodoCard(todo, widget.onToggle, _onError),
          background: Container(color: Colors.red),
        );
      },
    );
  }

  void _onSuccess(Todo todo) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Todo deleted"),
      action: new SnackBarAction(
        label: "UNDO",
        onPressed: () {
          widget.onCreate(
            todo.title,
            todo.content,
            todo.priority,
            todo.isDone,
            () {},
            _onError,
          );
        },
      ),
    ));
  }

  void _onError(String message) {
    MessageDialog.show(context, message: message);
  }
}
