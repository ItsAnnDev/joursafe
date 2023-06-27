import 'package:flutter/material.dart';
import 'package:joursafe/theme.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUserMessage;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUserMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
          bottomRight: isCurrentUserMessage ? Radius.zero : Radius.circular(14),
          bottomLeft: isCurrentUserMessage ? Radius.circular(14) : Radius.zero,
        ),
        color: isCurrentUserMessage ? blueMessageColor : orangeMessageColor,
      ),
      child: Text(
        message,
        style: chatAndReports,
      ),
    );
  }
}
