import 'package:flutter/material.dart';

class NeumorphicProgress extends StatefulWidget {
  const NeumorphicProgress({super.key, required double percent});

  @override
  State<NeumorphicProgress> createState() => _NeumorphicProgressState();
}

class _NeumorphicProgressState extends State<NeumorphicProgress> {
  @override
  Widget build(BuildContext context) {
    return const NeumorphicProgress(percent:0.5);
  }
}