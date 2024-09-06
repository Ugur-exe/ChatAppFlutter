
import 'package:chatappwithflutter/model/chat_model.dart';

class User {
  final String userId;
  final String nameSurname;
  final String email;
  final String profileImageUrl;
  final String status; // Kullanıcının online durumu
  final List<ChatModel>? lastMessageModel;

  // Constructor
  User({
    this.userId = "",
    this.nameSurname = "",
    this.email = "",
    this.profileImageUrl = "",
    this.status = "offline",
    this.lastMessageModel,
  });

  // JSON'dan User nesnesi oluşturmak için
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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

  // User nesnesini JSON'a dönüştürmek için
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
