import 'package:flutter/material.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/widgets/form_fields/priority_form_field.dart';
import 'package:flutter_todo/widgets/form_fields/toggle_form_field.dart';
import 'package:flutter_todo/widgets/helpers/confirm_dialog.dart';
import 'package:flutter_todo/widgets/helpers/message_dialog.dart';
import 'package:flutter_todo/widgets/helpers/priority_helper.dart';

class TodoEditor extends StatefulWidget {
  final Todo todo;
  final String priority;
  final OnCreateTodo onCreateTodo;
  final OnUpdateTodo onUpdateTodo;

  TodoEditor(
    this.todo,
    this.priority,
    this.onCreateTodo,
    this.onUpdateTodo,
  );

  @override
  State<StatefulWidget> createState() {
    return _TodoEditorState();
  }
}

class _TodoEditorState extends State<TodoEditor> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'content': null,
    'priority': Priority.Low,
    'isDone': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildAppBar() {
    return AppBar(
      title: Text(Configure.AppName),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.lock),
          onPressed: () async {
            bool confirm = await ConfirmDialog.show(context);

            if (confirm) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.save),
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        }

        _formKey.currentState.save();

        if (widget.todo != null) {
          widget.onUpdateTodo(
            Todo(
              id: widget.todo.id,
              title: _formData['title'],
              content: _formData['content'],
              priority: _formData['priority'],
              isDone: _formData['isDone'],
              userId: 'userId',
            ),
            this._onSuccess,
            this._onError,
          );
        } else {
          widget.onCreateTodo(
            _formData['title'],
            _formData['content'],
            _formData['priority'],
            _formData['isDone'],
            this._onSuccess,
            this._onError,
          );
        }
      },
    );
  }

  Widget _buildTitleField(Todo todo) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      initialValue: todo != null ? todo.title : '',
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter todo\'s title';
        }
      },
      onSaved: (value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildContentField(Todo todo) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Content'),
      initialValue: todo != null ? todo.content : '',
      maxLines: 5,
      onSaved: (value) {
        _formData['content'] = value;
      },
    );
  }

  Widget _buildOthers(Todo todo) {
    final bool isDone = todo != null && todo.isDone;
    final priority = todo != null
        ? todo.priority
        : PriorityHelper.toPriority(
            "Priority.${widget.priority != null ? widget.priority : 'Low'}");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ToggleFormField(
          initialValue: isDone,
          onSaved: (value) {
            _formData['isDone'] = value;
          },
        ),
        PriorityFormField(
          initialValue: priority,
          onSaved: (value) {
            _formData['priority'] = value;
          },
        )
      ],
    );
  }

  void _onSuccess() {
    Navigator.pop(context);
  }

  void _onError(String message) {
    MessageDialog.show(context, message: message);
  }

  Widget _buildForm() {
    Todo todo = widget.todo;

    _formData['title'] = todo != null ? todo.title : null;
    _formData['content'] = todo != null ? todo.content : null;
    _formData['priority'] = todo != null
        ? todo.priority
        : PriorityHelper.toPriority(
            "Priority.${widget.priority != null ? widget.priority : 'Low'}");
    _formData['isDone'] = todo != null ? todo.isDone : false;

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTitleField(todo),
          _buildContentField(todo),
          SizedBox(
            height: 12.0,
          ),
          _buildOthers(todo),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: _buildForm(),
        ),
      ),
    );
  }
}
