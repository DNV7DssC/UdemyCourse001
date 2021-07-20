import 'package:flutter/material.dart';
import 'package:fluttercourse/src/bloc/comments_provider.dart';
import 'package:fluttercourse/src/models/item_model.dart';
import 'package:fluttercourse/src/widgets/commets_widget.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  const NewsDetail({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final itemFuture = snapshot.data?[itemId];

        return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return buildList(itemSnapshot.data!, snapshot.data!);
            });
      },
    );
  }

  Widget buildList(ItemModel itemModel, Map<int, Future<ItemModel>> itemMap) {
    final commentList = itemModel.kids
        .map((kidId) => Comment(
              itemId: kidId,
              itemMap: itemMap,
              deph: 1,
            ))
        .toList();
    return ListView(
      children: [
        buildTitle(itemModel),
        buildDescription(itemModel),
        ...commentList,
      ],
    );
  }

  Widget buildTitle(ItemModel itemModel) {
    return Container(
      alignment: Alignment.topCenter,
      // width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Text(
        itemModel.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDescription(ItemModel itemModel) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Text(
        itemModel.text,
        style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
      ),
    );
  }
}
