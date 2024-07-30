import 'package:cloud_firestore/cloud_firestore.dart';

class UsersFirebaseServices {
  final _userCollection = FirebaseFirestore.instance.collection("users");
  Stream<QuerySnapshot> getMessages() {
    return _userCollection.snapshots();
  }

  Future<void> sendMessage(
      String fromUserId, String toUserId, String text) async {
    // Firestore instance olamiz
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Yangi hujjat yaratamiz va ma'lumotlarni saqlaymiz
    await firestore.collection('messages').add({
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(), // vaqtni saqlash uchun
    });
  }
}
