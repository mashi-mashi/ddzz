import 'package:ddzz/src/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _navigateToPage(Widget page) {
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => page));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFixedExtentList(
            itemExtent: 64,
            delegate: SliverChildListDelegate.fixed(
              [
                ListTile(
                  title: const Text('Version Check Page'),
                  // onTap: () => _navigateToPage(const VersionCheckPage()),
                ),
                ListTile(
                    title: const Text('Authentication Page'),
                    onTap: () {
                      print("ontap");
                      _navigateToPage(const AuthPage());
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
