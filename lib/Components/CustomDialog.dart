import 'package:flutter/material.dart';
import 'package:racing_manager/Resources/Strings.dart';
import 'package:racing_manager/Resources/TextThemes.dart';

class CustomDialog extends Dialog {
  final String message;
  final Color? messageColor;

  CustomDialog({required this.message, this.messageColor})
      : super(
            child: Builder(
          builder: (context) => Container(
            width: 500,
            height: 150,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(message, style: dialogMessageTextTheme.copyWith(color: messageColor)),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(messageColor)
                  ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(strOK)),
              ],
            ),
          ),
        ));
}
