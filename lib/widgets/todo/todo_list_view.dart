import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo/todo_card.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> todos;

  TodoListView(this.todos);

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
      itemCount: this.todos.length,
      itemBuilder: (BuildContext context, int index) {
        Todo todo = this.todos[index];

        return Dismissible(
          key: Key(todo.id),
          onDismissed: (DismissDirection direction) {},
          child: TodoCard(todo),
          background: Container(color: Colors.red),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget todoCards =
        this.todos.length > 0 ? _buildListView() : _buildEmptyText();

    return todoCards;
  }
}
