import 'package:fluttercourse/src/models/item_model.dart';
import 'package:fluttercourse/src/resources/newsApi_provider.dart';
import 'package:fluttercourse/src/resources/newsDb_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    late ItemModel? item;
    // late Source source;

    for (var source in sources) {
      item = await source.fetchItem(id);
    }
    for (var cache in caches) {
      if ((cache as Source) != sources[0]) {
        caches.add(cache);
      }
    }

    return item!;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
