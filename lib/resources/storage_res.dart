import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class StorageRes {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  //Uploading the Image to FirebaseStorage.

  Future<String> uploadImageToStorage(
    Uint8List imagefile,
  ) async {
    // creating location to our firebase storage
    final String imageName = const Uuid().v1();

    Reference ref =
        _firebaseStorage.ref().child('projects logos').child(imageName);

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(imagefile);

    TaskSnapshot snapshot = await uploadTask;
    //Getting downloadUrl.
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
