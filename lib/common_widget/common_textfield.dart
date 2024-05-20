import 'package:flutter/material.dart';

class common_text_field extends StatelessWidget {
  common_text_field(
      {super.key,
      this.hinttext,
      this.keyboardType,
      this.validator,
      this.controller,
      this.onTap,
      this.maxLength,
      this.prefixIcon,
      this.counterText});

  final String? hinttext;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final Widget? prefixIcon;
  final String? counterText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      controller: controller,
      onTap: onTap,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hinttext,
        fillColor: Colors.grey.shade200,
        filled: true,
        counterText: counterText,
        prefixIcon: prefixIcon,
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
    );
  }
}
