import 'package:flutter/material.dart';
import 'package:racing_manager/Resources/TextThemes.dart';

class CustomTextField extends TextFormField {
  final bool isObscure;
  final String label;
  final TextEditingController controller;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final void Function(bool isObscure)? onPrefixPressed;

  CustomTextField(
      {required this.controller,
      required this.label,
      this.isObscure = false,
      this.onPrefixPressed,
      this.suffixIcon,
      this.prefixIcon})
      : super(
          controller: controller,
          obscureText: isObscure,
          style: textThemeFields,
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
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Icon(prefixIcon,
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                : null,
          ),
        );
}
