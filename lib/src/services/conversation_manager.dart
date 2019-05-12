import "dart:async";
import "package:flutter/services.dart";

class ConversationManager {
  static const channel = const MethodChannel('beepvoice.app/conversation');

  Future<int> join(String conversationId) async {
    try {
      await channel.invokeMethod('join', conversationId);
    } on PlatformException catch (e) {
      print(e);
      return -1;
    }

    return 1;
  }

  Future<int> exit() async {
    try {
      await channel.invokeMethod('exit');
    } on PlatformException catch (e) {
      print(e);
      return -1;
    }

    return 1;
  }

  Future<String> get() async {
    try {
      final String conversationId = await channel.invokeMethod('get');
      return conversationId;
    } on PlatformException catch (e) {
      print(e);
      return "";
    }
  }
}
