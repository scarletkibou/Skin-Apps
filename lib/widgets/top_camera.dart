import 'package:firebase_r/widgets/instruction.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: 40,
          right: 30,
          child: Instruction(),
        )
      ],
    );
  }
}
