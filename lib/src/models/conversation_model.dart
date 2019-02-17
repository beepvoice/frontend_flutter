import "package:json_annotation/json_annotation.dart";

part "conversation_model.g.dart";

@JsonSerializable()
class Conversation {
  final String id;
  final String title;

  Conversation(this.id, this.title);

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
