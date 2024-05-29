import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<String> labels;
  final ValueChanged<int> onTap;
  final int currentIndex;

  const CustomBottomNavigationBar({
    required this.labels,
    required this.onTap,
    required this.currentIndex, 
  });

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.labels.length, (index) {
          return GestureDetector(
            onTap: () => widget.onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 4),
                Text(
                  widget.labels[index],
                  style: TextStyle(
                    color: widget.currentIndex == index ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
