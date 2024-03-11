import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  BuildContext myContext;

  MyBackButton({super.key, required this.myContext});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(myContext);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B72BE),
      ),
      child: const Text(
        'ยกเลิก',
      ),
    );
  }
}
