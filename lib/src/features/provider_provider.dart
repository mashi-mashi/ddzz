import 'package:ddzz/src/infrastructure/firebase_reference.dart';
import 'package:ddzz/src/infrastructure/firestore.dart';
import 'package:ddzz/utils/datetime-utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const firestore_load_limit = 15;

class Provider {
  String id;
  String title;
  String url;
  DateTime createdAt;

  Provider(
      {required this.id,
      required this.title,
      required this.url,
      required this.createdAt});

  factory Provider.fromJson(String id, Map<String, dynamic> data) {
    return Provider(
        id: id,
        title: data['title'].toString(),
        url: data['url'].toString(),
        createdAt: dateFromTimestampValue(data['createdAt']));
  }

  static Map<String, dynamic> toJson(Provider model) => {
        'id': model.id,
        'title': model.title,
        'url': model.url,
        'createdAt': timestampFromDateValue(model.createdAt)
      };
}

final providerProvider = ChangeNotifierProvider((ref) => ProviderModel());

class ProviderModel extends ChangeNotifier {
  ProviderModel() : super();

  dynamic _lastData;
  final List<Provider> _providers = [];
  dynamic get lastData => _lastData;
  List<Provider> get providers => _providers;

  Future<List<Provider>> load([dynamic lastCreatedAt]) async {
    final data = lastCreatedAt == null
        ? await Firestore.getByQuery<Provider>(FirestoreReference.providers()
            .orderBy('createdAt', descending: true)
            .limit(firestore_load_limit))
        : await Firestore.getByQuery<Provider>(FirestoreReference.providers()
            .orderBy('createdAt', descending: true)
            .startAfter([timestampFromDateValue(lastCreatedAt)]).limit(
                firestore_load_limit));

    if (data.isNotEmpty) {
      _lastData = data[data.length - 1];
      _providers.clear();
      _providers.addAll(data);

      print(
          'length - ${providers.length.toString()} lastdata - ${_lastData['title'].toString()}');
    }
    notifyListeners();

    return _providers;
  }
}
