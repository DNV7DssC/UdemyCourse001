import 'dart:async';
import 'package:fluttercourse/src/models/item_model.dart';
import 'package:fluttercourse/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  CommentsBloc() {
    _commentsFetcher.stream.transform(_commentsTransformer()).pipe(_commentsOutput);
  }

  Stream<Map<int, Future<ItemModel>>> get itemWithComments => _commentsOutput.stream;

  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  void dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }

  StreamTransformer<int, dynamic> _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        cache[id]?.then((ItemModel item) => item.kids.forEach((kidId) => fetchItemWithComments(kidId)));
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }
}
