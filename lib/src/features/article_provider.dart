import 'package:ddzz/src/infrastructure/firebase_reference.dart';
import 'package:ddzz/src/infrastructure/firestore.dart';
import 'package:ddzz/utils/datetime-utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const firestore_load_limit = 15;

class Article {
  String id;
  String name;
  String url;
  DateTime createdAt;

  Article(
      {required this.id,
      required this.name,
      required this.url,
      required this.createdAt});

  factory Article.fromJson(String id, Map<String, dynamic> data) {
    return Article(
        id: id,
        name: data['name'].toString(),
        url: data['url'].toString(),
        createdAt: dateFromTimestampValue(data['createdAt']));
  }

  static Map<String, dynamic> toJson(Article model) => {
        'id': model.id,
        'name': model.name,
        'url': model.url,
        'createdAt': timestampFromDateValue(model.createdAt)
      };
}

final articleProvider = ChangeNotifierProvider((ref) => ArticleModel());

class ArticleModel extends ChangeNotifier {
  ArticleModel() : super();

  dynamic? _lastData;
  final List<Article> _providers = [];
  dynamic get lastData => _lastData;
  List<Article> get providers => _providers;

  Future<List<Article>> loadAll() async {
    final data = await Firestore.getByQuery<Article>(
        FirestoreReference.providers()
            .orderBy('createdAt', descending: true)
            .limit(firestore_load_limit));

    if (data.toList().isNotEmpty) {
      _lastData = data.toList()[data.toList().length - 1];
      _providers.clear();
      _providers.addAll(data.toList());

      print(
          'length - ${providers.length.toString()} lastdata - ${_lastData['name'].toString()}');
    }
    notifyListeners();

    return _providers;
  }
}
