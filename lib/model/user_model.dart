import 'package:chatappwithflutter/model/chat_model.dart';

class UserModel {
  final String userId;
  final String nameSurname;
  final String email;
  final String profileImageUrl;
  final String status;
  final List<ChatModel>? lastMessageModel;

  
  UserModel({
    this.userId = "",
    this.nameSurname = "",
    this.email = "",
    this.profileImageUrl = "",
    this.status = "",
    this.lastMessageModel,
  });

  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? "",
      nameSurname: json['nameSurname'] ?? "",
      email: json['email'] ?? "",
      profileImageUrl: json['profileImageUrl'] ?? "",
      status: json['status'] ?? "offline",
      lastMessageModel: (json['lastMessageModel'] as List<dynamic>?)
          ?.map((e) => ChatModel.fromJson(e))
          .toList(),
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nameSurname': nameSurname,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'status': status,
      'lastMessageModel': lastMessageModel?.map((e) => e.toJson()).toList(),
    };
  }
}
