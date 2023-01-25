import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  // lookup for the the code in the picker pkg
  final ImagePicker _picker = ImagePicker();
  // Pick an image
  final XFile? image = await _picker.pickImage(source: source);

  if (image != null) {
    return await image.readAsBytes(); // uint8file
  } else {
    print('encountered some error');
  }
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
