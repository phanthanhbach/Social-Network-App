import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? errorMsg;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final String? Function(String?)? validation;
  final String? Function(String?)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    required this.keyboardType,
    this.errorMsg,
    this.onTap,
    this.focusNode,
    this.validation,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      focusNode: focusNode,
      onChanged: onChanged,
      validator: validation,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorMsg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }
}
