import "package:json_annotation/json_annotation.dart";

part "ping_model.g.dart";

@JsonSerializable()
class Ping {
  final int time;
  final String status;

  Ping(this.time, this.status);

  factory Ping.fromJson(Map<String, dynamic> json) => _$PingFromJson(json);
  Map<String, dynamic> toJson() => _$PingToJson(this);
}
