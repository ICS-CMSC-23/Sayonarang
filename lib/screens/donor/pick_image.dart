//GOODS NA SKSKS

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _selectedImage != null
            ? Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black12, // Add a color here
                  borderRadius: BorderRadius.circular(10), // Change the border radius here
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black12, // Add a color here
                  shape: BoxShape.rectangle, // Use BoxShape.rectangle to make it not circular
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                _pickImageFromGallery();
              },
              child: const Text("Gallery"),
            ),
            ElevatedButton(
              onPressed: () {
                _pickImageFromCamera();
              },
              child: const Text("Camera"),
            ),
          ],
        ),
      ],
    );
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      _selectedImage = File(returnImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      _selectedImage = File(returnImage.path);
    });
  }
}