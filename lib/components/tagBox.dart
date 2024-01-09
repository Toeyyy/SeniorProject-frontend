import 'package:flutter/material.dart';

class TagBox extends StatelessWidget {
  String text = '';

  TagBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Color(0xFF8B72BE),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFFF5F5F5),
        ),
      ),
    );
  }
}
