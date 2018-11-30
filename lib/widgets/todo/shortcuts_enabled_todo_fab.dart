import 'dart:math' as math;

import 'package:flutter/material.dart';

class ShortcutsEnabledTodoFab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShortcutsEnabledTodoFabState();
  }
}

class _ShortcutsEnabledTodoFabState extends State<ShortcutsEnabledTodoFab>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 50.0,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: 'low',
              backgroundColor: Colors.lightGreen,
              child: Icon(Icons.add),
              mini: true,
              onPressed: () {
                _controller.reverse();

                Navigator.pushNamed(context, '/editor/0/Low');
              },
            ),
          ),
        ),
        Container(
          height: 50.0,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 0.6, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: 'medium',
              backgroundColor: Colors.amber,
              child: Icon(Icons.add),
              mini: true,
              onPressed: () {
                _controller.reverse();

                Navigator.pushNamed(context, '/editor/0/Medium');
              },
            ),
          ),
        ),
        Container(
          height: 50.0,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 0.2, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: 'high',
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.add),
              mini: true,
              onPressed: () {
                _controller.reverse();

                Navigator.pushNamed(context, '/editor/0/High');
              },
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: 'main',
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Transform(
                alignment: FractionalOffset.center,
                transform:
                    Matrix4.rotationZ(_controller.value * 0.75 * math.pi),
                child: Icon(Icons.add),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        ),
      ],
    );
  }
}
