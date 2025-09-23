import 'package:cherrypic/presentation/screens/main/album/add/album_add_view_model.dart';
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
  final GlobalKey<_AlbumTypeSelectorState> _typeSelectorKey = GlobalKey();

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
            Text('앨범을 생성하는 중입니다...'),
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
        content: const Text('앨범이 성공적으로 생성되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              context.pop(); // 앨범 추가 화면 닫기
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _createAlbum() async {
    final selectedType = _albumAddViewModel.selectedAlbumType;
    final albumName = _albumCoverViewModel.albumName;

    // 기본값이면 빈 문자열로 처리
    final cleanAlbumName = albumName == '앨범 이름이 표시됩니다' ? '' : albumName;

    if (selectedType == null) {
      _showErrorDialog('앨범 유형을 선택해주세요.');
      return;
    }

    if (cleanAlbumName.trim().isEmpty) {
      _showErrorDialog('앨범 이름을 입력해주세요.');
      return;
    }

    _showLoadingDialog();

    bool success = false;

    if (selectedType.price == 0) {
      // 무료 앨범 (BASIC)
      success = await _albumAddViewModel.createFreeAlbum(
        albumName: cleanAlbumName,
        coverImageUrl: _albumCoverViewModel.coverImageUrl,
      );
    } else {
      // 유료 앨범 (PRO, PREMIUM) - 결제 포함
      success = await _albumAddViewModel.createPaidAlbumWithPayment(
        context,
        albumName: cleanAlbumName,
        coverImageUrl: _albumCoverViewModel.coverImageUrl,
      );
    }

    _hideLoadingDialog();

    if (success) {
      _showSuccessDialog();
    } else if (_albumAddViewModel.error != null) {
      _showErrorDialog(_albumAddViewModel.error!);
    }
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

                  AlbumTypeSelector(
                    key: _typeSelectorKey,
                    onTypeSelected: (type) {
                      _albumAddViewModel.setSelectedAlbumType(type);
                    },
                  ),
                  const SizedBox(height: 50),

                  AlbumPermissionToggle(
                    isPermissionEnabled: _albumAddViewModel.isPermissionEnabled,
                    onPermissionToggled: _albumAddViewModel.togglePermission,
                    showMemberList: false,
                  ),
                  const SizedBox(height: 40),

                  // 앨범 생성 버튼
                  CustomButton(
                    text: _albumAddViewModel.isLoading ? '생성 중...' : '앨범 생성',
                    onPressed: _albumAddViewModel.isLoading
                        ? null
                        : _createAlbum,
                  ),

                  // 에러 메시지 표시
                  if (_albumAddViewModel.error != null) ...[
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
                              _albumAddViewModel.error!,
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                          ),
                          TextButton(
                            onPressed: _albumAddViewModel.clearError,
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
}
