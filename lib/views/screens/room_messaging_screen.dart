import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/models/messaging_model.dart';
import 'package:chat_app/services/firebase_chat_service.dart';
import 'package:chat_app/services/push_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoomMessageScreen extends StatefulWidget {
  final int index;
  final String email;
  final String token;

  const RoomMessageScreen({
    super.key,
    required this.email,
    required this.token,
    required this.index,
  });

  @override
  State<RoomMessageScreen> createState() => _RoomMessageScreenState();
}

class _RoomMessageScreenState extends State<RoomMessageScreen> {
  final chatController = ChatController();
  final smsTextEditingController = TextEditingController();
  final chatFirebaseServices = ChatFirebaseService();
  // ignore: prefer_typing_uninitialized_variables
  late final chatRoomId;
  @override
  void initState() {
    super.initState();
    dynamic box = [widget.email, FirebaseAuth.instance.currentUser!.email]
      ..sort();
    chatRoomId = box.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 26, 28, 50),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(0, 26, 28, 50),
        centerTitle: true,
        title: const Text(
          "Chat with tester version",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: ChatFirebaseService().getMessages(chatRoomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              snapshot.hasError) {
            return Center(
              child: Text(
                "Message mavjud emas ${snapshot.error}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
          final messages = snapshot.data!.docs;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Message message =
                        Message.fromQuerySnapshot(messages[index]);
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(214, 1, 34, 248),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Text(
                                message.text,
                                // messages[index]["name"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 5,
                                top: 40,
                                bottom: 2,
                              ),
                              child: Text(
                                DateFormat("HH:mm")
                                    .format(message.timestamp.toDate()),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
        child: TextFormField(
          controller: smsTextEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            label: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Write a message...",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                chatFirebaseServices.sendMessage(chatRoomId: chatRoomId, data: {
                  "text": smsTextEditingController.text,
                  "sender-email": widget.email,
                  "time-stamp": FieldValue.serverTimestamp(),
                });
                FirebasePushNotificationService.sendNotificationMessage(
                  title: smsTextEditingController.text,
                  token: widget.token,
                  body: smsTextEditingController.text,
                );
                smsTextEditingController.clear();
              },
              icon: const Icon(
                Icons.send,
                color: Colors.blue,
              ),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
