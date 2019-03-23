import "package:json_annotation/json_annotation.dart";

part "ping_model.g.dart";

@JsonSerializable()
class Ping {
  @JsonKey(name: "timestamp")
  final int timestamp;
  
  @JsonKey(name: "status")
  final String status;

  Ping(this.timestamp, this.status);

  factory Ping.fromJson(Map<String, dynamic> json) =>
      _$PingFromJson(json);
  Map<String, dynamic> toJson() => _$PingToJson(this);
}
