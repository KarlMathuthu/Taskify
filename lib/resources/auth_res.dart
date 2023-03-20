import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRes {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createAccount(
    String name,
    String surname,
    String email,
    String photoUrl,
    String password,
  ) async {
    String res = 'Some error accoured';
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
          'name': name,
          'surname': surname,
          'email': email,
          'photoUrl': photoUrl,
          'password': password,
          'uid': _auth.currentUser!.uid,
        });
        res = 'success';
      } catch (error) {
        res = 'failed to create account!';
      }
    } else {
      res = 'fill in all the fields';
    }
    return res;
  }

  Future<String> login(
    String email,
    String password,
  ) async {
    String res = 'Some error occured';
    if (email.isEmpty) {
      res = 'Enter your email';
    } else if (password.isEmpty) {
      res = 'Enter password';
    } else if (!email.contains('@')) {
      res = 'Email is invalid';
    } else {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } catch (error) {
        res = 'Error while trying to login';
      }
    }
    return res;
  }

  Future<String> resetPassword(String email) async {
    String res = 'Some error occured';
    if (email.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        res = 'success';
      } catch (error) {
        res = 'User not found';
      }
    } else {
      res = 'enter email';
    }
    return res;
  }
}
