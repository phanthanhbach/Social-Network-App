import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  final TextEditingController controller;

  const PostTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 5,
      maxLength: 500,
      decoration: InputDecoration(
        hintText: 'What\'s on your mind?',
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
