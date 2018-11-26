import 'package:flutter/material.dart';

import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/helpers/priority_helper.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final OnToggleTodoDone onToggle;
  final OnError onError;

  TodoCard(this.todo, this.onToggle, this.onError);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: PriorityHelper.getPriorityColor(todo.priority),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(4.0),
                bottomLeft: const Radius.circular(4.0),
              ),
            ),
            width: 40.0,
            height: 80.0,
            child: todo.isDone
                ? IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      onToggle(todo, onError);
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      onToggle(todo, onError);
                    },
                  ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                todo.title,
                style: TextStyle(
                    fontSize: 24.0,
                    decoration: todo.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editor/${todo.id}');
            },
          )
        ],
      ),
    );
  }
}
