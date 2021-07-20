import 'package:flutter/material.dart';
import 'package:fluttercourse/src/bloc/comments_provider.dart';
import 'package:fluttercourse/src/bloc/stories_bloc.dart';
import 'package:fluttercourse/src/bloc/stories_provider.dart';
import 'package:fluttercourse/src/screens/newsDetail_screen.dart';
import 'package:fluttercourse/src/screens/newsList_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      key: Key('CP'),
      child: StoriesProvider(
        key: Key('SP'),
        child: MaterialApp(
          title: 'News!',
          theme: ThemeData(primarySwatch: Colors.blue),
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name!.replaceFirst('/', ''));

          commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(
            itemId: itemId,
          );
        },
      );
    }
  }
}
