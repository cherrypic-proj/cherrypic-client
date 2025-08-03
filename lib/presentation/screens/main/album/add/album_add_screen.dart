import 'package:cherrypic/presentation/screens/main/album/components/album_cover_section.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';

class AlbumAddScreen extends StatelessWidget {
  const AlbumAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '앨범 추가',
          style: AppFont.size20.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: AlbumCoverSection(),
        ),
      ),
    );
  }
}
