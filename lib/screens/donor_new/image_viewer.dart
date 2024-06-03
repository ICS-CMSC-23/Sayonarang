import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class ShowFullImage extends StatelessWidget {
  final dynamic image;

  const ShowFullImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? imageProvider;
    if (image is String) {
      imageProvider = NetworkImage(image);
    } else if (image is File) {
      imageProvider = FileImage(image);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        constraints: const BoxConstraints.expand(
          height: double.infinity,
          width: double.infinity,
        ),
        child: PhotoView(
          imageProvider: imageProvider!,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }
}
