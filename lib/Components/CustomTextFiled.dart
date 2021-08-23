import 'package:flutter/material.dart';
import 'package:racing_manager/Resources/TextThemes.dart';

class CustomTextField extends TextFormField {
  final bool isObscure;
  final String label;
  final TextEditingController controller;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType? inputType;
  final TextAlignVertical? alignVertical;
  final bool expand;
  final void Function(bool isObscure)? onPrefixPressed;

  CustomTextField(
      {required this.controller,
      required this.label,
      this.isObscure = false,
      this.onPrefixPressed,
      this.suffixIcon,
      this.inputType,
      this.alignVertical,
      this.expand = false,
      this.prefixIcon})
      : super(
          keyboardType: inputType,
          controller: controller,
          // expands: expand,
          obscureText: isObscure,
          maxLines: expand ? null : 1,
          minLines: expand ? 3 : 1,
          style: textThemeFields,
          textAlignVertical: alignVertical,
          decoration: InputDecoration(
            isDense: false,
            hintStyle: textThemeFieldsHint,
            hintText: label,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    // color: Theme.of(context).primaryColor,
                    width: 1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 2),
            ),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            prefixIcon: prefixIcon != null
                ? Builder(
                    builder: (context) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(prefixIcon,
                              color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
        );
}
