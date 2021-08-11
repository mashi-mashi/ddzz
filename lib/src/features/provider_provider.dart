import 'package:ddzz/src/infrastructure/firebase_reference.dart';
import 'package:ddzz/src/infrastructure/firestore.dart';
import 'package:ddzz/utils/datetime-utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const firestore_load_limit = 15;

class ServiceProvider {
  String id;
  String title;
  String url;
  DateTime createdAt;

  ServiceProvider(
      {required this.id,
      required this.title,
      required this.url,
      required this.createdAt});

  factory ServiceProvider.fromJson(String id, Map<String, dynamic> data) {
    return ServiceProvider(
        id: id,
        title: data['title'].toString(),
        url: data['url'].toString(),
        createdAt: dateFromTimestampValue(data['createdAt']));
  }

  static Map<String, dynamic> toJson(ServiceProvider model) => {
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
  final List<ServiceProvider> _providers = [];
  dynamic get lastData => _lastData;
  List<ServiceProvider> get providers => _providers;

  Future<List<ServiceProvider>> load([dynamic lastCreatedAt]) async {
    final data = lastCreatedAt == null
        ? await Firestore.getByQuery<ServiceProvider>(
            FirestoreReference.providers()
                .orderBy('createdAt', descending: true)
                .limit(firestore_load_limit))
        : await Firestore.getByQuery<ServiceProvider>(
            FirestoreReference.providers()
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
