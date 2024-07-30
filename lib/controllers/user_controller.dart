import 'package:chat_app/services/firebase_user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final _chatFirebaseServices = UserFirebaseServices();

  Stream<QuerySnapshot> get list {
    return _chatFirebaseServices.getUsers();
  }
}
