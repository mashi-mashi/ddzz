import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ddzz/src/features/article_provider.dart';
import 'package:ddzz/src/features/provider_provider.dart';
import 'package:ddzz/src/features/auth_controller.dart';

class FirestoreReference {
  static String get _userId => AuthController().user?.uid ?? '';
  static String base() => 'deluca/v1/';
  static CollectionReference providers() => FirebaseFirestore.instance
      .collection(FirestoreReference.base() + 'providers')
      .withConverter<Provider>(
          fromFirestore: (snapshot, _) =>
              Provider.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (model, _) => Provider.toJson(model));

  static CollectionReference articles() {
    var collectionReference = FirebaseFirestore.instance
        .collection(FirestoreReference.base() + 'articles')
        .withConverter<Article>(
            fromFirestore: (snapshot, _) =>
                Article.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (model, _) => Article.toJson(model));
    return collectionReference;
  }

  static CollectionReference providerArticles(String providerId) =>
      FirebaseFirestore.instance
          .collection(
              FirestoreReference.base() + 'providers/$providerId/articles')
          .withConverter<Article>(
              fromFirestore: (snapshot, _) =>
                  Article.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (model, _) => Article.toJson(model));

  static CollectionReference userSubscriptions() {
    return FirebaseFirestore.instance.collection(FirestoreReference.base() +
        'users/' +
        FirestoreReference._userId +
        '/subscriptions');
  }

  static CollectionReference userPicks() {
    return FirebaseFirestore.instance.collection(FirestoreReference.base() +
        'users/' +
        FirestoreReference._userId +
        '/picks');
  }
}
