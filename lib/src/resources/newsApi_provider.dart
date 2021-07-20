import 'dart:convert';

import 'package:fluttercourse/src/models/item_model.dart';
import 'package:fluttercourse/src/resources/repository.dart';
import 'package:http/http.dart' show Client;

final _authority = 'hacker-news.firebaseio.com';

class NewsApiProvider implements Source {
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    final response = await client.get(Uri.https(_authority, '/v0/topstories.json'));
    final ids = jsonDecode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(Uri.https(_authority, '/v0/item/$id.json'));
    final parsedJson = jsonDecode(response.body);

    return ItemModel.fromJason(parsedJson);
  }
}
