import "package:json_annotation/json_annotation.dart";

part "user_model.g.dart";

@JsonSerializable()
class User {
  final String id;

  @JsonKey(name: "first_name")
  final String firstName;

  @JsonKey(name: "last_name")
  final String lastName;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "username")
  final String username;

  @JsonKey(name: "bio")
  final String bio;

  @JsonKey(name: "profile_pic")
  final String profilePic;

  User(this.id, this.firstName, this.lastName, this.phoneNumber, this.username,
      this.bio, this.profilePic);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
