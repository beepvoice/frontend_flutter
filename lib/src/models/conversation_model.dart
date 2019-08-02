import "package:json_annotation/json_annotation.dart";

part "conversation_model.g.dart";

@JsonSerializable()
class Conversation {
  final String id;
  final String title;
  final bool dm;
  final String picture;

  Conversation(this.id, this.title, this.picture, this.dm);

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
