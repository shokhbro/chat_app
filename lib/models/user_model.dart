import 'package:cloud_firestore/cloud_firestore.dart';

class UserModels {
  final String id;
  final String token;
  final String name;
  final String email;

  UserModels({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory UserModels.fromJson(QueryDocumentSnapshot query) {
    return UserModels(
      id: query.id,
      name: query["user-name"],
      token: query["user-token"],
      email: query["user-email"],
    );
  }
}
