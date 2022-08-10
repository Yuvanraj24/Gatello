
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../Style/Colors.dart';

Widget textFormField(
    {bool obscureText = false,
      required TextStyle textStyle,
      TextStyle? hintStyle,
      String? hintText,
      String? labelText,
      TextStyle? labelStyle,
      TextStyle? labelDisabledStyle,
      TextStyle? errorStyle,
      Color borderColor = const Color(accent),
      Color cursorColor = const Color(black),
      double borderWidth = 2.0,
      double borderRadius = 5,
      Color? fillColor,
      int minLines = 1,
      int maxLines = 1,
      Widget? prefix,
      int errorMaxLines = 3,
      int maxLength = 500,
      bool counter = false,
      FocusNode? focusNode,
      bool enabled = true,
      bool border = true,
      bool filled = true,
      bool autofocus = false,
      void Function()? onTap,
      TextInputAction? textInputAction,
      EdgeInsetsGeometry? contentPadding,
      void Function(String)? onFieldSubmitted,
      TextInputType keyboardType = TextInputType.text,
      required TextEditingController textEditingController,
      void Function(String)? onChanged,
      required String? Function(String?) validator,
      double? labelRightPadding,
      double? labelLeftPadding,
      double? labelTopPadding,
      double? labelBottomPadding,
      Widget? suffixIcon}) {
  return TextFormField(
    controller: textEditingController,
    obscureText: obscureText,
    style: textStyle,
    minLines: minLines,
    maxLines: maxLines,
    maxLength: maxLength,
    onChanged: onChanged,
    focusNode: focusNode,
    enabled: enabled,
    autofocus: autofocus,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    onFieldSubmitted: onFieldSubmitted,
    cursorColor: cursorColor,
    cursorHeight: 20,
    cursorWidth: 1,
    validator: validator,
    onTap: onTap,
    decoration: InputDecoration(
        errorMaxLines: errorMaxLines,
        alignLabelWithHint: true,
        suffixIcon: suffixIcon,
        prefixIcon: prefix,
        // label: (labelText != null && labelStyle != null && focusNode != null)
        //     ? Padding(
        //         padding: const EdgeInsets.only(bottom: 30),
        //         child: Text(labelText, style: focusNode.hasFocus ? labelStyle : labelDisabledStyle),
        //       )
        //     : null,
        label: (labelText != null && labelStyle != null)
            ? Padding(
          padding: (labelRightPadding != null || labelLeftPadding != null || labelTopPadding != null || labelBottomPadding != null)
              ? EdgeInsets.only(left: labelLeftPadding ?? 0, top: labelTopPadding ?? 0, bottom: labelBottomPadding ?? 0, right: labelRightPadding ?? 0)
              : EdgeInsets.zero,
          child: Text(labelText, style: labelStyle),
        )
            : null,
        labelStyle: labelStyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: (border) ? BorderSide(color: borderColor, width: borderWidth) : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: (border) ? BorderSide(color: borderColor, width: borderWidth) : BorderSide.none,
        ),
        filled: filled,
        counter: (counter) ? null : SizedBox.shrink(),
        counterStyle: TextStyle(
          height: (counter) ? null : double.minPositive,
        ),
        contentPadding: contentPadding,
        errorStyle: errorStyle,
        hintStyle: hintStyle,
        hintText: hintText,
        fillColor: fillColor),
  );
}
