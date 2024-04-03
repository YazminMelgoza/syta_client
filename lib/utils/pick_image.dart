import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:syta_client/utils/show_snack_bar.dart'; 

Future<File?> pickImage(context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path); 
    }
  } catch (e) {
    if (!context.mounted) return null;
    showSnackBar(context, "No image selected");
    return null;
  }
  return image;
}