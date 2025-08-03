import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';

class AlbumAddScreen extends StatelessWidget {
  const AlbumAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const Center(child: Text('앨범 추가 화면')),
    );
  }
}
