import 'package:flutter/material.dart';
import '../models/message.dart';
import 'package:intl/intl.dart';

class ChatMessageWidget extends StatelessWidget {
  final Message message;
  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度
    final screenWidth = MediaQuery.of(context).size.width;
    // 设置气泡最大宽度为屏幕宽度的70%
    final maxBubbleWidth = screenWidth * 0.7;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: const Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: maxBubbleWidth, // 设置最大宽度
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(message.isUser ? 16.0 : 4.0),
                      topRight: Radius.circular(message.isUser ? 4.0 : 16.0),
                      bottomLeft: const Radius.circular(16.0),
                      bottomRight: const Radius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(fontSize: 16.0),
                    softWrap: true, // 允许自动换行
                    overflow: TextOverflow.visible, // 文本溢出时显示
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _formatTime(message.timestap),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser)
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue[300],
                child: const Text(
                  '我',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
