import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyCancelButton extends StatelessWidget {
  final BuildContext myContext;

  const MyCancelButton({super.key, required this.myContext});

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

class MyPopButton extends StatelessWidget {
  final BuildContext myContext;

  const MyPopButton({super.key, required this.myContext});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        myContext.pop();
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

class MyBackButton extends StatelessWidget {
  final BuildContext myContext;

  const MyBackButton({super.key, required this.myContext});

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
        'กลับ',
      ),
    );
  }
}
