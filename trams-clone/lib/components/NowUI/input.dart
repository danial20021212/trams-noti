// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../constant/theme.dart';

class Input extends StatelessWidget {
  final String? placeholder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool autofocus;
  final Color borderColor;
  final String? errorText;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextInputType? keyboardType;
  final double radius;
  final Color fillColor;
  final Color? color;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;

  const Input({
    super.key,
    this.placeholder,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.autofocus = false,
    this.borderColor = NowUIColors.border,
    this.controller,
    this.errorText,
    this.labelText,
    this.keyboardType,
    this.radius = 32.0,
    this.fillColor = NowUIColors.white,
    this.color,
    this.labelStyle,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: NowUIColors.muted,
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      autofocus: autofocus,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 14,
        color: color ?? const Color.fromARGB(255, 100, 98, 133),
      ),
      textAlignVertical: TextAlignVertical(y: 0.6),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fillColor,
        hintStyle: TextStyle(
          color: NowUIColors.time,
          fontSize: 14,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        hintText: placeholder,
        labelText: labelText,
        labelStyle: labelStyle,
        errorText: errorText,
      ),
    );
  }
}
