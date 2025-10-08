import 'package:flutter/cupertino.dart';

class PhotoManagementModel {
  final String title;
  final void Function(BuildContext context) onTap;

  PhotoManagementModel({
    required this.title,
    required this.onTap,
  });
}