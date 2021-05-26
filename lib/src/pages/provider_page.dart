import 'package:ddzz/src/features/provider_provider.dart';
import 'package:ddzz/src/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderPage extends HookWidget {
  ProviderPage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Constants.pageBackGroundColor,
        appBar: AppBar(
          title: const Text('Provider'),
        ),
        body: HookBuilder(builder: (context) {
          final futureProvider = useProvider(providerProvider);
          final snapshot = useFuture(useMemoized(futureProvider.load, []),
              initialData: null);

          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        await futureProvider.load();
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: futureProvider.providers.length,
                          itemBuilder: (context, index) {
                            if (index < futureProvider.providers.length) {
                              final provider = futureProvider.providers[index];
                              if (index ==
                                  futureProvider.providers.length - 1) {
                                Future(() {
                                  futureProvider.load(provider.createdAt);
                                });
                              }
                              return makeCard(provider, () async {});
                            } else {
                              return Text('記事がありません');
                            }
                          })));
        }));
  }
}
