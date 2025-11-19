import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/router/app_router.dart'; // [중요] rootNavigatorKey 사용
import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/repositories/payment_repository.dart';
import 'package:cherrypic/data/album/services/album_cover_image_service.dart';
import 'package:cherrypic/data/album/services/iamport_service.dart';
import 'package:cherrypic/presentation/screens/store/subscription/payment/payment_info.dart';
import 'package:cherrypic/presentation/screens/store/subscription/payment/payment_info_model.dart';
import 'package:cherrypic/presentation/screens/store/subscription/payment/payment_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import '../../../../core/constants/font.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import '../../store/components/payment_method_box.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String? subscriptionType;
  final Map<String, dynamic>? albumData;

  const PaymentMethodScreen({super.key, this.subscriptionType, this.albumData});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethodType _selectedMethod = PaymentMethodType.kakao;
  bool _isProcessingPayment = false;

  final AlbumRepository _albumRepository = AlbumRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();
  final ImageUploadService _imageUploadService = ImageUploadService();

  PaymentInfoModel _getPaymentModel() {
    if (widget.subscriptionType == 'premium') {
      return PaymentInfoModel(
        productPrice: 6900,
        subscriptionValue: 'CherryPic Premium',
        nextPaymentDate: '2025년 9월 20일',
        totalPrice: 6900,
      );
    } else {
      return PaymentInfoModel(
        productPrice: 3900,
        subscriptionValue: 'CherryPic Pro',
        nextPaymentDate: '2025년 9월 20일',
        totalPrice: 3900,
      );
    }
  }

  Future<void> _processPayment() async {
    if (_isProcessingPayment) return;
    if (!mounted) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final subscriptionType = widget.subscriptionType?.toUpperCase() ?? 'PRO';
      final readyResponse = await _paymentRepository.readyPayment(
        type: subscriptionType,
        albumId: null,
      );

      if (!mounted) return;

      final paymentData = IamportService.createPaymentDataForEnvironment(
        merchantUid: readyResponse.merchantUid,
        name: readyResponse.purpose,
        amount: readyResponse.price,
        buyerName: readyResponse.buyerName,
        paymentType: _selectedMethod,
        isProduction: false,
      );

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IamportPayment(
            appBar: AppBar(
              title: const Text('결제하기'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            initialChild: const Center(child: CircularProgressIndicator()),
            userCode: IamportService.userCode,
            data: paymentData,
            callback: (Map<String, String> result) {
              _handlePaymentResultAndCreateAlbum(result);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('결제 준비 중 오류: ${e.toString()}');
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  Future<void> _handlePaymentResultAndCreateAlbum(
    Map<String, String> result,
  ) async {
    // 1. 아임포트 웹뷰 닫기 (화면이 살아있으면)
    if (mounted) {
      Navigator.pop(context);
    }
    // 화면 전환 애니메이션 대기
    await Future.delayed(const Duration(milliseconds: 300));

    final isSuccess = IamportService.isPaymentSuccessful(result);
    final impUid = IamportService.getImpUid(result);
    final errorMsg = result['error_msg'];

    // 실패 시 전역 다이얼로그
    if (!isSuccess || impUid == null) {
      _showGlobalDialog('결제 실패', errorMsg ?? '결제가 취소되었습니다.');
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
      return;
    }

    // 2. 로딩 다이얼로그 표시 (rootNavigatorKey 사용)
    final globalContext = rootNavigatorKey.currentContext;
    if (globalContext != null) {
      showDialog(
        context: globalContext,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      print('[DEBUG] 1. 결제 검증 시작: $impUid');
      // 결제 검증
      final verifyResponse = await _paymentRepository.verifyPayment(impUid);
      final paymentId = verifyResponse.paymentId;

      print('[DEBUG] 2. 커버 이미지 업로드 시작');
      // 이미지 업로드
      String? coverUrl;
      final albumData = widget.albumData ?? {};
      final coverImage = albumData['coverImage'];

      if (coverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(coverImage);
      }

      print('[DEBUG] 3. 앨범 생성 요청');
      // 앨범 생성
      String apiType = widget.subscriptionType?.toUpperCase() ?? 'PRO';
      final requestDto = AlbumCreateRequestDto(
        title: (albumData['albumName'] as String? ?? '').trim(),
        coverUrl: coverUrl,
        type: apiType,
        paymentId: paymentId,
        permissionControl: albumData['isPermissionEnabled'] as bool? ?? false,
      );

      await _albumRepository.createAlbum(requestDto);

      // 로딩 닫기
      if (globalContext != null && Navigator.canPop(globalContext)) {
        Navigator.pop(globalContext);
      }

      print('[DEBUG] 4. 모든 과정 성공! 홈으로 이동');
      // [핵심] 홈으로 이동 (rootNavigatorKey 사용)
      rootNavigatorKey.currentContext?.go(RoutePath.home);
    } catch (e) {
      print('[ERROR] 앨범 생성 실패: $e');

      // 로딩 닫기
      if (globalContext != null && Navigator.canPop(globalContext)) {
        Navigator.pop(globalContext);
      }

      _showGlobalDialog('오류', '결제는 성공했으나 앨범 생성 중 오류가 발생했습니다.\n${e.toString()}');
    }
  }

  // 전역 다이얼로그 표시 헬퍼 (화면이 죽어도 뜸)
  void _showGlobalDialog(String title, String message) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림'),
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

  @override
  Widget build(BuildContext context) {
    final model = _getPaymentModel();
    final viewModel = PaymentInfoViewModel(model);

    return Scaffold(
      appBar: const CustomSubAppBar(title: 'CherryPic 정기 구독'),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 39.5),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '결제수단을 선택하세요',
                          style: AppFont.size18.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 38.8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaymentMethodBox(
                            type: PaymentMethodType.kakao,
                            isSelected:
                                _selectedMethod == PaymentMethodType.kakao,
                            onTap: () => setState(
                              () => _selectedMethod = PaymentMethodType.kakao,
                            ),
                          ),
                          const SizedBox(width: 70),
                          PaymentMethodBox(
                            type: PaymentMethodType.toss,
                            isSelected:
                                _selectedMethod == PaymentMethodType.toss,
                            onTap: () => setState(
                              () => _selectedMethod = PaymentMethodType.toss,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 38.8),
                Container(height: 4, color: AppColor.subSlicer),
                const SizedBox(height: 46.28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '결제 정보',
                          style: AppFont.size16.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      PaymentInfo(viewModel: viewModel),
                      const SizedBox(height: 92.45),
                      CustomButton(
                        onPressed: _isProcessingPayment
                            ? null
                            : _processPayment,
                        variant: AppButtonVariant.filled,
                        type: CustomButtonType.createAlbum,
                        text: _isProcessingPayment
                            ? '결제 처리중...'
                            : '${viewModel.formattedTotalPrice} 결제하기',
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
