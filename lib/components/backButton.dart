import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  BuildContext myContext;

  MyBackButton({required this.myContext});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(myContext);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF8B72BE),
      ),
      child: const Text(
        'ยกเลิก',
      ),
    );
  }
}

// ElevatedButton BackButton(BuildContext myContext){
//   return ElevatedButton(
//     onPressed: () {
//       Navigator.pop(myContext);
//     },
//     child: Text(
//       'ยกเลิก',
//     ),
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Color(0xFF8B72BE),
//     ),
//   );
// }
