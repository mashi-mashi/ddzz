import 'package:ddzz/utils/datetime-utils.dart';
import 'package:flutter/material.dart';

Card makeCard(
    {required String title,
    required DateTime createdAt,
    required Future<dynamic> Function() onTap}) {
  return Card(
    elevation: 0.2,
    margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
    child: Container(
      child: makeListTile(title: title, createdAt: createdAt, onTap: onTap),
    ),
  );
}

ListTile makeListTile(
        {required String title,
        required DateTime createdAt,
        required Future<dynamic> Function() onTap}) =>
    ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        title,
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
                    formatDatetime(createdAt, format: 'yyyy/MM/dd HH:mm:ss'),
                    style: TextStyle(color: Colors.black))),
          ),
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () async {
        await onTap();
      },
    );
