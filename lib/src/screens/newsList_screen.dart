import 'package:flutter/material.dart';
import 'package:fluttercourse/src/bloc/stories_bloc.dart';
import 'package:fluttercourse/src/bloc/stories_provider.dart';
import 'package:fluttercourse/src/widgets/newsListTile_widget.dart';
import 'package:fluttercourse/src/widgets/refresh_widget.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return NewsListTile(itemId: snapshot.data![index]);
            },
          ),
        );
      },
    );
  }
}
