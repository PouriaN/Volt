import 'package:flutter/material.dart';
import 'package:racing_manager/Resources/TextThemes.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Function callBack;
  final bool enable;
  final Color color;

  MainButton({required this.text, required this.callBack, this.color = Colors.blueAccent,this.enable = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: enable ? () => callBack() : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(color),
                minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
                  alignment: Alignment.center,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: enable
                  ? new Text(text,
                      style: textThemeMainButton, textAlign: TextAlign.center)
                  : CircularProgressIndicator(color: Colors.white)),
        ),
      ],
    );
  }
}
