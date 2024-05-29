import 'package:flutter/material.dart';

class MatchResultCircle extends StatelessWidget {
  final String result;

  const MatchResultCircle({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    Color color;
    String displayText;

    if (result == 'W') {
      color = Colors.green;
      displayText = 'W';
    } else if (result == 'L') {
      color = Colors.red;
      displayText = 'L';
    } else {
      color = Colors.grey; // Default color for unexpected values
      displayText = '';
    }

    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          displayText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}
