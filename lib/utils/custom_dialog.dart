
import 'package:flutter/material.dart';

class CustomDialog {

  static void show(
    BuildContext context,
    String title,
    String message,
    {
      bool barrierDismissible = true,
      Future<bool> Function()? onWillPop,
      List<Widget>? actions,
    }
  ) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: onWillPop ?? () async => barrierDismissible,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: actions ??
                <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
          ),
        );
      },
    );
  }
}