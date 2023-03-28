import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRes {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> sendMessage(String message, String projectIndex) async {
    String res = 'Some error occured';
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('projects')
          .doc(projectIndex)
          .collection('messages')
          .add({
        'message': message,
        'type': 'text',
        'time': DateTime.now(),
        'senderId': _auth.currentUser!.uid,
      });

      res = 'success';
    } catch (error) {   
      res = error.toString();
    }
    return res;
  }

  Future deleteMessage() async {}
}
