import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  
  @override
  Widget build(BuildContext context) {
  
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[500]!,
      highlightColor: Colors.grey[600]!,
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 20,
                    color: Colors.grey[800],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 20,
                        color: Colors.grey[500],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 20,
                        color: Colors.grey[500],
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 20,
                    color: Colors.grey[500],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 20,
                        color: Colors.grey[500],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 100,
                    height: 40,
                    color: Colors.grey[500],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
  }
