
import 'package:flutter/material.dart';

class OnlineAvatar extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;

  OnlineAvatar({
    required this.imageUrl,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 23, // Adjust size as needed
          backgroundImage: AssetImage(imageUrl),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? Colors.green : Colors.grey,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}