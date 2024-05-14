import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorProfileModel {
  final String name;
  final String username;

  DonorProfileModel({required this.name, required this.username});

  factory DonorProfileModel.fromMap(Map<String, dynamic> data) {
    return DonorProfileModel(
      name: data['name'],
      username: data['username'],
    );
  }
}