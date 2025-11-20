import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/repositories/payment_repository.dart';
import 'package:cherrypic/data/album/services/album_cover_image_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentResultProcessingScreen extends StatefulWidget {
  final Map<String, String> queryParams;

  // [중요] 결제 화면(PaymentMethodScreen)에서 결제 시작 전에
  // 여기에 앨범 생성에 필요한 데이터를 임시로 저장해두어야 합니다.
  // 앱이 백그라운드에서 죽지 않는 한 이 데이터는 유지됩니다.
  static Map<String, dynamic>? pendingAlbumData;

  const PaymentResultProcessingScreen({super.key, required this.queryParams});

  @override
  State<PaymentResultProcessingScreen> createState() =>
      _PaymentResultProcessingScreenState();
}

class _PaymentResultProcessingScreenState
    extends State<PaymentResultProcessingScreen> {
  // 리포지토리 및 서비스 초기화
  final AlbumRepository _albumRepository = AlbumRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();
  final ImageUploadService _imageUploadService = ImageUploadService();

  @override
  void initState() {
    super.initState();
    print(
      '🚀 [DEBUG] PaymentResultProcessingScreen 진입 성공! 쿼리: ${widget.queryParams}',
    );
    // 화면이 렌더링 된 직후 로직 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processPaymentResult();
    });
  }

  Future<void> _processPaymentResult() async {
    final result = widget.queryParams;

    // 1. 결제 성공 여부 판단 (imp_success 또는 success 키 확인)
    final isSuccess =
        result['imp_success'] == 'true' || result['success'] == 'true';
    final impUid = result['imp_uid'];
    final errorMsg = result['error_msg'];

    // 2. 결제 실패 시 처리
    if (!isSuccess || impUid == null) {
      _showErrorAndGoBack('결제가 취소되었거나 실패했습니다.\n${errorMsg ?? ""}');
      return;
    }

    // 3. 임시 저장된 앨범 데이터 확인
    // (결제 전 PaymentResultProcessingScreen.pendingAlbumData 에 저장했어야 함)
    final albumData = PaymentResultProcessingScreen.pendingAlbumData;
    if (albumData == null) {
      // 데이터를 찾을 수 없는 경우 (앱이 완전히 종료되었다가 켜진 경우 등)
      // 실제 상용 앱에서는 SharedPreferences나 DB에 저장했다가 복구하는 로직이 권장됩니다.
      _showErrorAndGoBack(
        '앨범 생성 정보를 찾을 수 없습니다. 고객센터에 문의해주세요.\n(결제번호: $impUid)',
      );
      return;
    }

    try {
      // 4. 서버 검증 (Verify)
      debugPrint('[PaymentResult] 1. 결제 검증 시작: $impUid');
      final verifyResponse = await _paymentRepository.verifyPayment(impUid);
      final paymentId = verifyResponse.paymentId;

      // 5. 커버 이미지 업로드
      debugPrint('[PaymentResult] 2. 커버 이미지 업로드 시작');
      String? coverUrl;
      final coverImage = albumData['coverImage']; // Uint8List 타입 가정

      if (coverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(coverImage);
      }

      // 6. 앨범 생성 요청
      debugPrint('[PaymentResult] 3. 앨범 생성 요청');
      final String subscriptionType = albumData['subscriptionType'] ?? 'PRO';
      final String albumName = albumData['albumName'] ?? '';
      final bool isPermissionEnabled =
          albumData['isPermissionEnabled'] ?? false;

      final requestDto = AlbumCreateRequestDto(
        title: albumName.trim(),
        coverUrl: coverUrl,
        type: subscriptionType, // 'PRO' or 'PREMIUM'
        paymentId: paymentId,
        permissionControl: isPermissionEnabled,
      );

      await _albumRepository.createAlbum(requestDto);

      // 7. 성공 시 데이터 초기화 및 홈으로 이동
      PaymentResultProcessingScreen.pendingAlbumData = null; // 데이터 사용 완료 후 삭제

      if (mounted) {
        // 스택을 비우고 홈으로 이동
        context.go(RoutePath.home);
      }
    } catch (e) {
      debugPrint('[PaymentResult] 오류 발생: $e');
      _showErrorAndGoBack('결제는 성공했으나 앨범 생성 중 오류가 발생했습니다.\n${e.toString()}');
    }
  }

  void _showErrorAndGoBack(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              context.go(RoutePath.home); // 홈으로 이동
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.red, // 앱 테마색(CherryPic Red)에 맞게 조정
            ),
            SizedBox(height: 24),
            Text(
              '결제 확인 중...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '잠시만 기다려주세요.\n앨범을 생성하고 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
