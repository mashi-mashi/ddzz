import 'package:ddzz/src/features/auth_controller.dart';
import 'package:ddzz/src/pages/article_page.dart';
import 'package:ddzz/src/pages/service_provider_page.dart';
import 'package:ddzz/src/pages/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 強制アップデート情報を取得してダイアログを表示するデモページ
class AuthPage extends HookConsumerWidget {
  const AuthPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _navigateToPage(Widget page) {
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => page));
    }

    final user = ref.watch(authControllerProvider);
    final authenticator = ref.watch(authControllerProvider.notifier);
    final hasSigned = user != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            Text('ログイン状態：${hasSigned ? 'ログイン済み' : '未ログイン'}'),
            const SizedBox(height: 16),
            if (hasSigned) ...[
              Text('ニックネーム：${user!.displayName ?? '名無し'}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _navigateToPage(ProviderPage());
                },
                child: const Text('じゃんぷ'),
              ),
              ElevatedButton(
                onPressed: () {
                  _navigateToPage(ArticlePage(providerId: ''));
                },
                child: const Text('じゃんぷ2'),
              ),
              ElevatedButton(
                onPressed: () {
                  _navigateToPage(WebViewPage());
                },
                child: const Text('web view'),
              ),
              ElevatedButton(
                onPressed: () async {
                  authenticator.signOutGoogle();
                },
                child: const Text('LOGOUT'),
              ),
            ] else
              ElevatedButton(
                onPressed: () async {
                  authenticator.signInGoogle();
                },
                child: const Text('google login'),
              ),
          ],
        ),
      ),
    );
  }
}
