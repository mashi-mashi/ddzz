import 'package:ddzz/src/infrastructure/firebase_reference.dart';
import 'package:ddzz/src/infrastructure/firestore.dart';
import 'package:ddzz/utils/datetime-utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const firestore_load_limit = 15;

class Article {
  String id;
  String title;
  String url;
  DateTime createdAt;

  Article(
      {required this.id,
      required this.title,
      required this.url,
      required this.createdAt});

  factory Article.fromJson(String id, Map<String, dynamic> data) {
    return Article(
        id: id,
        title: data['title'].toString(),
        url: data['url'].toString(),
        createdAt: dateFromTimestampValue(data['createdAt']));
  }

  static Map<String, dynamic> toJson(Article model) => {
        'id': model.id,
        'title': model.title,
        'url': model.url,
        'createdAt': timestampFromDateValue(model.createdAt)
      };
}

final articleProvider = ChangeNotifierProvider((ref) => ArticleModel());

class ArticleModel extends ChangeNotifier {
  ArticleModel() : super();

  Article? _lastData;
  final List<Article> _articles = [];
  Article? get lastData => _lastData;
  List<Article> get articles => _articles;

  Future<List<Article>> load(String providerId, [dynamic lastCreatedAt]) async {
    final data = lastCreatedAt == null
        ? await Firestore.getByQuery<Article>(
            FirestoreReference.providerArticles(providerId)
                .orderBy('createdAt', descending: true)
                .limit(firestore_load_limit))
        : await Firestore.getByQuery<Article>(
            FirestoreReference.providerArticles(providerId)
                .orderBy('createdAt', descending: true)
                .startAfter([timestampFromDateValue(lastCreatedAt)]).limit(
                    firestore_load_limit));

    if (data.isNotEmpty) {
      _lastData = data[data.length - 1];
      _articles.addAll(data);

      print('length - ${_articles.length.toString()}');
    }
    notifyListeners();

    return _articles;
  }
}
