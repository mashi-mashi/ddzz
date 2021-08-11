import 'package:ddzz/src/features/auth_controller.dart';
import 'package:ddzz/src/pages/article_page.dart';
import 'package:ddzz/src/pages/service_provider_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 強制アップデート情報を取得してダイアログを表示するデモページ
class AuthPage extends HookWidget {
  const AuthPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _navigateToPage(Widget page) {
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => page));
    }

    final user = useProvider(authControllerProvider);
    final authenticator = useProvider(authControllerProvider.notifier);
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
