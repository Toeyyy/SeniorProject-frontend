import 'package:flutter/material.dart';

class TagBox extends StatelessWidget {
  String text = '';
  double? textSize = 14;

  TagBox({super.key, required this.text, this.textSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: const Color(0xFF8B72BE),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFFF5F5F5),
          fontSize: textSize,
        ),
      ),
    );
  }
}
