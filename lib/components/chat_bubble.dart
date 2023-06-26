import 'package:flutter/material.dart';
import 'package:joursafe/theme.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({
    super.key,
    required this.message,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue
      ),
      child: Text(
        message,
        style: normalSize.copyWith(color: Colors.white)
      ),
    );
  }
}