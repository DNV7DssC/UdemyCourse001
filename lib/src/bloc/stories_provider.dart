import 'package:flutter/material.dart';
import 'package:fluttercourse/src/bloc/stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({required Key key, required Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static StoriesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>()!).bloc;
  }
}
