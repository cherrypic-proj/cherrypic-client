import 'package:cherrypic/core/router/route_path.dart';
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

  // --- (Dialog 관련 메서드는 동일) ---
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
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  // 앨범 데이터 생성 메서드
  Map<String, dynamic> _getAlbumData() {
    final albumName = _albumCoverViewModel.albumName;
    final cleanAlbumName = albumName == '앨범 이름이 표시됩니다' ? '' : albumName;

    return {
      'albumName': cleanAlbumName,
      'coverImage': _albumCoverViewModel.coverImage,
      'isPermissionEnabled': _albumAddViewModel.isPermissionEnabled,
    };
  }

  // 구독 타입을 문자열로 변환
  String _getSubscriptionTypeString(dynamic selectedType) {
    if (selectedType == null) return 'basic';

    // selectedType의 구조에 따라 적절히 변환
    if (selectedType.toString().toLowerCase().contains('pro')) {
      return 'pro';
    } else if (selectedType.toString().toLowerCase().contains('premium')) {
      return 'premium';
    } else {
      return 'basic';
    }
  }

  Future<void> _createAlbum() async {
    final selectedType = _albumAddViewModel.selectedAlbumType;
    final albumName = _albumCoverViewModel.albumName;
    final cleanAlbumName = albumName == '앨범 이름이 표시됩니다' ? '' : albumName;

    if (selectedType == null) {
      _showErrorDialog('앨범 유형을 선택해주세요.');
      return;
    }

    if (cleanAlbumName.trim().isEmpty) {
      _showErrorDialog('앨범 이름을 입력해주세요.');
      return;
    }

    // 무료 앨범인 경우 바로 생성
    if (selectedType.price == 0) {
      _showLoadingDialog();

      bool success = await _albumAddViewModel.createFreeAlbum(
        albumName: cleanAlbumName,
        coverImage: _albumCoverViewModel.coverImage,
      );

      _hideLoadingDialog();

      if (success) {
        _showSuccessDialog();
      } else if (_albumAddViewModel.error != null) {
        _showErrorDialog(_albumAddViewModel.error!);
      }
    } else {
      // 유료 앨범인 경우 결제 화면으로 이동
      final subscriptionType = _getSubscriptionTypeString(selectedType);
      final albumData = _getAlbumData();

      context.push(
        RoutePath.payment_method,
        extra: {'subscriptionType': subscriptionType, 'albumData': albumData},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_albumCoverViewModel, _albumAddViewModel]),
      builder: (context, child) {
        final bool isButtonEnabled = _albumAddViewModel.isCreateButtonEnabled(
          _albumCoverViewModel.albumName,
        );

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

                  CustomButton(
                    text: _albumAddViewModel.isLoading ? '생성 중...' : '앨범 생성',
                    onPressed: isButtonEnabled && !_albumAddViewModel.isLoading
                        ? _createAlbum
                        : null, // 조건이 충족되지 않으면 null로 비활성화
                  ),

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
