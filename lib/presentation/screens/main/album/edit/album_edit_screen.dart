import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_section.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:cherrypic/presentation/screens/main/album/edit/album_edit_view_model.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_permission_toggle.dart';
import 'package:cherrypic/presentation/widgets/custom_button.dart';
import 'package:cherrypic/presentation/widgets/dialogs/album_delete_dialog.dart';

class AlbumEditScreen extends StatefulWidget {
  final int albumId;
  const AlbumEditScreen({super.key, required this.albumId});

  @override
  State<AlbumEditScreen> createState() => _AlbumEditScreenState();
}

class _AlbumEditScreenState extends State<AlbumEditScreen> {
  late final AlbumEditViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AlbumEditViewModel(albumId: widget.albumId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // --- 앨범 삭제 확인 다이얼로그를 표시하는 함수 ---
  void _showAlbumDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlbumDeleteDialog(viewModel: _viewModel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
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
              '앨범 설정',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AlbumCoverSection(
                      viewModel: _viewModel.albumCoverViewModel,
                    ),
                  ),
                  const SizedBox(height: 80),
                  const AlbumTypeSelector(),
                  const SizedBox(height: 50),

                  AlbumPermissionToggle(
                    isPermissionEnabled: _viewModel.isPermissionEnabled,
                    onPermissionToggled: _viewModel.togglePermission,
                    members: _viewModel.filteredMembers,
                    searchController: _viewModel.searchController,
                    onUpdateRole: _viewModel.updateMemberRole,
                    onKickMember: _viewModel.kickMember,
                    showMemberList: true,
                  ),
                  const SizedBox(height: 40),

                  CustomButton(
                    text: '변경 사항 저장',
                    onPressed: () {},
                    variant: AppButtonVariant.outlined,
                  ),
                  const SizedBox(height: 50),

                  _buildBottomButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 115,
          height: 40,
          child: ElevatedButton(
            onPressed: _showAlbumDeleteDialog, // 다이얼로그 호출
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '앨범 삭제',
                  style: AppFont.size16.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Image.asset(
                  'assets/images/trash_icon.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '앨범 구독 해지',
                  style: AppFont.size16.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.remove_circle_outline,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
