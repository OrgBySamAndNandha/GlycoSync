import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// FIX: Added the missing import for the ChatMessage model.
import '../model/community_chat_model.dart';

class CommunityChatController {
  final ValueNotifier<List<ChatMessage>> messagesNotifier = ValueNotifier([]);
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  StreamSubscription? _chatSubscription;

  String? _currentUserName;
  String? _currentUserId;

  CommunityChatController() {
    _initializeUserAndListen();
  }

  // Fetch the current user's name and start listening for messages.
  Future<void> _initializeUserAndListen() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _currentUserId = user.uid;

    // Fetch user's name from the 'patients' collection
    final userDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(user.uid)
        .get();
    _currentUserName = userDoc.data()?['name'] ?? 'Anonymous';

    // Start listening for new messages
    listenToMessages();
  }

  // Listen to the stream of messages from Firestore.
  void listenToMessages() {
    _chatSubscription?.cancel();
    _chatSubscription = FirebaseFirestore.instance
        .collection('community_chat')
        .orderBy('timestamp', descending: true)
        .limit(50) // Load the 50 most recent messages
        .snapshots()
        .listen((snapshot) {
      final messages =
          snapshot.docs.map((doc) => ChatMessage.fromDocument(doc)).toList();
      messagesNotifier.value = messages;
      _scrollToBottom();
    });
  }

  // Send a new message to the Firestore collection.
  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || _currentUserId == null || _currentUserName == null) {
      return;
    }

    textController.clear();

    await FirebaseFirestore.instance.collection('community_chat').add({
      'text': text,
      'senderId': _currentUserId,
      'senderName': _currentUserName,
      'timestamp': Timestamp.now(),
    });
  }

  // Automatically scroll to the bottom of the chat list.
  void _scrollToBottom() {
    if (scrollController.hasClients) {
      // Use a short delay to ensure the UI has updated before scrolling
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // Clean up resources.
  void dispose() {
    _chatSubscription?.cancel();
    messagesNotifier.dispose();
    textController.dispose();
    scrollController.dispose();
  }
}

