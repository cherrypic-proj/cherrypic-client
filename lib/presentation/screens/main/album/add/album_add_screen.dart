import 'package:cherrypic/presentation/screens/main/album/add/album_add_view_model.dart'; // 새로 만든 ViewModel 임포트
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_section.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_view_model.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_permission_toggle.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:cherrypic/presentation/widgets/custom_button.dart';
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
  late final AlbumAddViewModel _albumAddViewModel;

  @override
  void initState() {
    super.initState();
    _albumCoverViewModel = AlbumCoverViewModel();
    _albumAddViewModel = AlbumAddViewModel();
  }

  @override
  void dispose() {
    _albumCoverViewModel.dispose();
    _albumAddViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_albumCoverViewModel, _albumAddViewModel]),
      builder: (context, child) {
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AlbumCoverSection(viewModel: _albumCoverViewModel),
                  const SizedBox(height: 80),
                  const AlbumTypeSelector(),
                  const SizedBox(height: 50),

                  AlbumPermissionToggle(
                    isPermissionEnabled: _albumAddViewModel.isPermissionEnabled,
                    onPermissionToggled: _albumAddViewModel.togglePermission,
                    showMemberList: false,
                  ),
                  const SizedBox(height: 40),

                  // 앨범 생성 버튼
                  CustomButton(
                    text: '앨범 생성',
                    onPressed: () {
                      // TODO: 앨범 생성 로직 구현
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
