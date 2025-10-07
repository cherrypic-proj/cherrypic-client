import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_section.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_view_model.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_permission_toggle.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:cherrypic/presentation/screens/main/album/edit/album_edit_view_model.dart';
import 'package:cherrypic/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlbumEditScreen extends StatefulWidget {
  final int albumId;
  final AlbumDetailDto albumData;

  const AlbumEditScreen({
    super.key,
    required this.albumId,
    required this.albumData,
  });

  @override
  State<AlbumEditScreen> createState() => _AlbumEditScreenState();
}

class _AlbumEditScreenState extends State<AlbumEditScreen> {
  late final AlbumCoverViewModel _albumCoverViewModel;
  late final AlbumEditViewModel _albumEditViewModel;

  @override
  void initState() {
    super.initState();

    // 기존 데이터로 초기화
    _albumCoverViewModel = AlbumCoverViewModel();
    _albumCoverViewModel.setInitialData(
      albumName: widget.albumData.title,
      coverImageUrl: widget.albumData.coverUrl,
    );

    _albumEditViewModel = AlbumEditViewModel(
      albumId: widget.albumId,
      initialData: widget.albumData,
    );
  }

  @override
  void dispose() {
    _albumCoverViewModel.dispose();
    _albumEditViewModel.dispose();
    super.dispose();
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('앨범을 수정하는 중입니다...'),
          ],
        ),
      ),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('성공'),
        content: const Text('앨범이 성공적으로 수정되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              context.pop(true); // 수정 화면 닫기 (새로고침 트리거)
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateAlbum() async {
    _showLoadingDialog();

    // 커버 이미지가 변경되었으면 ViewModel에 전달
    if (_albumCoverViewModel.coverImage != null) {
      _albumEditViewModel.setCoverImage(_albumCoverViewModel.coverImage);
    }

    // 앨범 이름 동기화
    _albumEditViewModel.setAlbumName(_albumCoverViewModel.albumName);

    final success = await _albumEditViewModel.updateAlbum();

    _hideLoadingDialog();

    if (success && mounted) {
      _showSuccessDialog();
    } else if (_albumEditViewModel.error != null) {
      _showErrorDialog(_albumEditViewModel.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_albumCoverViewModel, _albumEditViewModel]),
      builder: (context, child) {
        final bool isButtonEnabled = _albumEditViewModel.isUpdateButtonEnabled;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 앨범 커버 & 이름
                  AlbumCoverSection(viewModel: _albumCoverViewModel),
                  const SizedBox(height: 80),

                  // 앨범 유형 (읽기 전용)
                  _buildAlbumTypeDisplay(),
                  const SizedBox(height: 50),

                  // 멤버별 권한 부여 (Basic은 비활성화)
                  AlbumPermissionToggle(
                    isPermissionEnabled:
                        _albumEditViewModel.isPermissionEnabled,
                    onPermissionToggled: (_) {}, // 수정 불가
                    showMemberList:
                        _albumEditViewModel.albumType != AlbumType.basic,
                    participants: _albumEditViewModel.participants,
                    isLoadingParticipants:
                        _albumEditViewModel.isLoadingParticipants,
                  ),
                  const SizedBox(height: 40),

                  // 수정 버튼
                  CustomButton(
                    text: _albumEditViewModel.isLoading
                        ? '수정 중...'
                        : '변경 사항 저장',
                    onPressed: isButtonEnabled ? _updateAlbum : null,
                  ),

                  const SizedBox(height: 20),

                  // 앨범 삭제 & 나가기 버튼
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: 앨범 삭제 기능
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('앨범 삭제'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: 앨범 구독 해지 기능
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('앨범 구독 해지'),
                        ),
                      ),
                    ],
                  ),

                  if (_albumEditViewModel.error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _albumEditViewModel.error!,
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                          ),
                          TextButton(
                            onPressed: _albumEditViewModel.clearError,
                            child: const Text('닫기'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 앨범 유형 표시 (수정 불가)
  Widget _buildAlbumTypeDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '앨범 유형',
          style: AppFont.size18.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 333,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                '선택) ',
                style: AppFont.size14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                _albumEditViewModel.albumType?.displayName ?? 'Basic 앨범',
                style: AppFont.size16.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
