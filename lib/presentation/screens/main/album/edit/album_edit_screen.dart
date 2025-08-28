import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_section.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:cherrypic/presentation/screens/main/album/edit/album_edit_view_model.dart';
// [수정] AlbumPermissionToggle 경로
import 'package:cherrypic/presentation/screens/main/album/components/album_permission_toggle.dart';
import 'package:cherrypic/presentation/widgets/custom_button.dart';

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

                  // [수정] 기존 멤버 관리 UI를 컴포넌트로 대체
                  AlbumPermissionToggle(
                    isPermissionEnabled: _viewModel.isPermissionEnabled,
                    onPermissionToggled: _viewModel.togglePermission,
                    members: _viewModel.filteredMembers,
                    searchController: _viewModel.searchController,
                    onUpdateRole: _viewModel.updateMemberRole,
                    onKickMember: _viewModel.kickMember,
                    showMemberList: true, // 설정 화면에서는 멤버 리스트를 보여줌
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

  // [제거] _buildMemberManagementSection, _buildMemberListBox, _buildMemberListItem 함수 삭제

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 115,
          height: 40,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('앨범 삭제', style: AppFont.size16),
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
            ),
            child: Text('앨범 구독 해지', style: AppFont.size16),
          ),
        ),
      ],
    );
  }
}
