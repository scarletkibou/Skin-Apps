import 'package:firebase_r/widgets/dialog.dart';
import 'package:flutter/material.dart';

class Instruction extends StatelessWidget {
  const Instruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => ImageDialog());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 212, 8, 18),
          padding: EdgeInsets.symmetric(vertical: 20),
        ),
        child: const Text('Instructions'),
      ),
    );
  }
}
