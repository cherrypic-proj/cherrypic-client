import 'package:cherrypic/presentation/screens/main/album/components/album_cover_section.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_view_model.dart'; // ViewModel 임포트
import 'package:cherrypic/presentation/screens/main/album/components/album_permission_toggle.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:go_router/go_router.dart';

class AlbumAddScreen extends StatefulWidget {
  const AlbumAddScreen({super.key});

  @override
  State<AlbumAddScreen> createState() => _AlbumAddScreenState();
}

class _AlbumAddScreenState extends State<AlbumAddScreen> {
  late final AlbumCoverViewModel _albumCoverViewModel;

  @override
  void initState() {
    super.initState();
    _albumCoverViewModel = AlbumCoverViewModel();
  }

  @override
  void dispose() {
    _albumCoverViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '앨범 추가',
          style: AppFont.size20.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AlbumCoverSection(viewModel: _albumCoverViewModel),
              const SizedBox(height: 80),
              const AlbumTypeSelector(),
              const SizedBox(height: 50),
              const AlbumPermissionToggle(showLockSetting: false),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
