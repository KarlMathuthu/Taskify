import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskify/resources/storage_res.dart';

class ProjectRes {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createPersonalProject(
    String name,
    String description,
    Uint8List imagefile,
    String illustrations,
    String adminUID,
    String membersUID,
  ) async {
    String res = 'Some error occured';
    try {
      String logoUrl = await StorageRes().uploadImageToStorage(
        imagefile,
      );

      //Adding data user's database.
      await _firestore
          .collection('users')
          .doc(membersUID)
          .collection('projects')
          .add({
        'name': name,
        'description': description,
        'createDate': DateTime.now(),
        'finished': false,
        'logoUrl': logoUrl,
        'illustration': illustrations,
        'admin': adminUID,
      });

      res = 'success';
    } catch (error) {
      res = 'failed to create project';
    }
    return res;
  }
}
