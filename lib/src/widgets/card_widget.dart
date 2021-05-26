import 'package:ddzz/src/features/provider_provider.dart';
import 'package:ddzz/utils/datetime-utils.dart';
import 'package:flutter/material.dart';

Card makeCard(Provider provider, Future<dynamic> Function() onTap) {
  return Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      child: makeListTile(provider, onTap),
    ),
  );
}

ListTile makeListTile(Provider provider, Future<dynamic> Function() onTap) =>
    ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        provider.title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                child: LinearProgressIndicator(
                    value: 1,
                    valueColor: AlwaysStoppedAnimation(Colors.green))),
          ),
          Expanded(
            flex: 9,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                    formatDatetime(provider.createdAt,
                        format: 'yyyy/MM/dd HH:mm:ss'),
                    style: TextStyle(color: Colors.black))),
          ),
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () async {
        // await onTap();
      },
    );
