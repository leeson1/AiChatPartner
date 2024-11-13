import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../config/app_config.dart';

class ChatService {
  WebSocketChannel? _channel;
  final Duration timeout;
  Function(String)? onMessageReceived;

  ChatService({
    this.timeout = AppConfig.wsTimeout,
  });

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(AppConfig.wsUrl));

      _channel?.stream.listen(
        (message) {
          if (onMessageReceived != null) {
            onMessageReceived!(message.toString());
          }
        },
        onError: (error) {
          print('WebSocket Error: $error');
          reconnect();
        },
        onDone: () {
          print('WebSocket Connection Closed');
          reconnect();
        },
      );
    } catch (e) {
      print('WebSocket Connection Error: $e');
      reconnect();
    }
  }

  void reconnect() {
    Future.delayed(const Duration(seconds: 3), () {
      connect();
    });
  }

  Future<void> sendMessage(String message) async {
    try {
      if (_channel == null) {
        connect();
      }
      _channel?.sink.add(message);
    } catch (e) {
      print('Send Message Error: $e');
      throw Exception('发送消息失败');
    }
  }

  void dispose() {
    _channel?.sink.close(status.goingAway);
  }
}
