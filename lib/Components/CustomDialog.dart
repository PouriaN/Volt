import 'package:flutter/material.dart';
import 'package:volt/Resources/Strings.dart';
import 'package:volt/Resources/TextThemes.dart';

class CustomDialog extends StatelessWidget {
  final List<String> messages;
  final Color? messageColor;

  CustomDialog({required this.messages, this.messageColor});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        height: messages.length == 1 ? 150 : 300,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) => Text(messages[index],
                      style:
                          dialogMessageTextTheme.copyWith(color: messageColor),
                      textAlign: TextAlign.center)),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(messageColor)),
                onPressed: () => Navigator.pop(context),
                child: Text(strOK)),
          ],
        ),
      ),
    );
  }
}
