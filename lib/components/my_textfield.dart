import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        // 模糊文本
        obscureText: obscureText,
        // 创建文本控制器获取按钮内容
        controller: controller,
        decoration: InputDecoration(
          // 未选中时的按钮颜色
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          // 选中时的按钮颜色
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          // 填充色
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
