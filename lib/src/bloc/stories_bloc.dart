import 'package:fluttercourse/src/models/item_model.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
export 'stories_provider.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  // Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to Sink
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  clearCache() {
    return _repository.clearCache();
  }

  void dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
