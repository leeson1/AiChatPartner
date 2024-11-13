import 'package:chat/models/message.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:chat/service/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = [];
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chatService.connect();
    _chatService.onMessageReceived = _handleReceivedMessage;
  }

  void _handleReceivedMessage(String message) {
    setState(() {
      _messages.insert(
        0,
        Message(
          text: message,
          isUser: false,
        ),
      );
      _isLoading = false;
    });
    _scrollToBottom();
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textEditingController.clear();
    setState(() {
      _messages.insert(
        0,
        Message(
          text: text,
          isUser: true,
        ),
      );
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      await _chatService.sendMessage(text);
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          Message(
            text: '发送失败，请重试',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _chatService.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 聊天助手'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) => ChatMessageWidget(
                message: _messages[index],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          hintText: '请输入消息',
                          border: InputBorder.none,
                        ),
                        enabled: !_isLoading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () =>
                                _handleSubmitted(_textEditingController.text),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: _isLoading ? Colors.grey : Colors.blue[300],
                            shape: BoxShape.circle,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  '发送',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
