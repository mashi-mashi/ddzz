import 'package:ddzz/src/features/article_provider.dart';
import 'package:ddzz/src/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArticlePage extends HookWidget {
  ArticlePage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Constants.pageBackGroundColor,
        appBar: AppBar(
          title: const Text('Articles'),
        ),
        body: HookBuilder(builder: (context) {
          final futureProvider = useProvider(articleProvider);
          final snapshot = useFuture(
              useMemoized(() {
                futureProvider.load('7W95xCWlIwJkRRa9La1y');
              }, []),
              initialData: null);

          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        await futureProvider.load('7W95xCWlIwJkRRa9La1y');
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: futureProvider.articles.length,
                          itemBuilder: (context, index) {
                            final lenght = futureProvider.articles.length;
                            if (index < lenght) {
                              final article = futureProvider.articles[index];
                              if (index == lenght - 1) {
                                print(
                                    'index: ${index.toString()} length: ${lenght - 1}');
                                Future(() {
                                  futureProvider.load('7W95xCWlIwJkRRa9La1y',
                                      article.createdAt);
                                });
                              }
                              return makeCard(
                                  title: '$index ${article.title}',
                                  createdAt: article.createdAt,
                                  onTap: () async {});
                              // return Card(
                              //   elevation: 8.0,
                              //   margin: EdgeInsets.symmetric(
                              //       horizontal: 10.0, vertical: 6.0),
                              //   child: Container(
                              //     child: ListTile(
                              //         title: Text('$index ${article.title}')),
                              //   ),
                              // );
                            } else {
                              return Text('記事がありません');
                            }
                          })));
        }));
  }
}
