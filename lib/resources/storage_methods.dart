import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(childName).child(_auth
        .currentUser!.uid); // ref() reference to file already exits or no file
    // our child represents the folder we want to have in the storage for different unique folder we used uid of the user
    // folder hierachy will be childName -> Uid -> the picture

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    //now we will upload our file in the location defined in above line using ref object
    UploadTask uploadTask = ref.putData(file);

    //now we want to get the download url for the picture being uploaded so that we can store that also .
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
