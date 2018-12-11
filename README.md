# Flutter Todo Redux

Yet another Todo app, now using Flutter with Redux.

## Getting Started

This is re-implementation of [Flutter Todo app](https://github.com/tuannguyendotme/flutter_todo) but using Redux instead of ScopedModel.

Features:

- Create/edit todo
- Delete todo by swipping
- Undo delete
- Mark done/not done in list
- Filter todo list by status (all/done/not done)
- Change theme (light to dark and vice versa) at runtime
- Enable shortcuts to create todo
- Login/logout
- Register new account

![Dark List](dark_list.png?raw=true)
![Dark Editor](dark_editor.png?raw=true)

To get start, run below command in Terminal

```
cp .env.example.dart .env.dart
```

then add Firebase database's URL and API key to .env.dart.

---

For more information about Flutter, visit [Flutter web site](https://flutter.io/).  
For more information about Firebase, visit [Firebase web site](https://firebase.google.com/).
