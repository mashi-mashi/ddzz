import 'package:ddzz/src/features/provider_provider.dart';
import 'package:ddzz/src/pages/article_page.dart';
import 'package:ddzz/src/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderPage extends HookConsumerWidget {
  ProviderPage() : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _navigateToPage(Widget page) {
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => page));
    }

    return Scaffold(
        // backgroundColor: Constants.pageBackGroundColor,
        appBar: AppBar(
          title: const Text('Provider'),
        ),
        body: HookBuilder(builder: (context) {
          final futureProvider = ref.watch(providerProvider);
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
                              return makeCard(
                                  title: provider.title,
                                  createdAt: provider.createdAt,
                                  onTap: () async {
                                    print('id: ${provider.id}');
                                    _navigateToPage(
                                        ArticlePage(providerId: provider.id));
                                  });
                            } else {
                              return Text('????????????????????????');
                            }
                          })));
        }));
  }
}
