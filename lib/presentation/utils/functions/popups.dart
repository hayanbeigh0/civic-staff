import 'package:flutter/material.dart';

Future<dynamic> primaryPopupDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText,
  required VoidCallback ontap,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          ElevatedButton(
            onPressed: ontap,
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}
