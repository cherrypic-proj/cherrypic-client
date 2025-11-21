import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/router/app_router.dart';
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
  // 기본 선택값: 카카오페이
  PaymentMethodType _selectedMethod = PaymentMethodType.kakao;
  bool _isProcessingPayment = false;

  final AlbumRepository _albumRepository = AlbumRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();
  final ImageUploadService _imageUploadService = ImageUploadService();

  // UI 표시용 모델 생성
  PaymentInfoModel _getPaymentModel() {
    if (widget.subscriptionType == 'premium') {
      return PaymentInfoModel(
        productPrice: 6900,
        subscriptionValue: 'CherryPic Premium',
        nextPaymentDate: '2025년 9월 20일', // 실제 로직에 맞게 수정 필요
        totalPrice: 6900,
      );
    } else {
      return PaymentInfoModel(
        productPrice: 3900,
        subscriptionValue: 'CherryPic Pro',
        nextPaymentDate: '2025년 9월 20일', // 실제 로직에 맞게 수정 필요
        totalPrice: 3900,
      );
    }
  }

  // [핵심] 결제 프로세스 시작
  Future<void> _processPayment() async {
    if (_isProcessingPayment || !mounted) return;

    setState(() {
      _isProcessingPayment = true; // 중복 클릭 방지 잠금
    });

    try {
      final subscriptionType = widget.subscriptionType?.toUpperCase() ?? 'PRO';

      // 1. 서버에 결제 사전 등록 (Merchant UID 발급)
      final readyResponse = await _paymentRepository.readyPayment(
        type: subscriptionType,
        albumId: null,
      );

      if (!mounted) return;

      // 2. 아임포트 결제 데이터 생성 (카카오/토스 분기 처리 포함)
      final paymentData = IamportService.createPaymentDataForEnvironment(
        merchantUid: readyResponse.merchantUid,
        name: readyResponse.purpose,
        amount: readyResponse.price,
        buyerName: readyResponse.buyerName,
        paymentType: _selectedMethod,
        isProduction: false, // 실배포 시 true로 변경 필요
      );

      // 3. 결제 화면(WebView)으로 이동하고, 결과(성공 시 true)를 기다림
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return IamportPayment(
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
              // [중요] 결제 결과 콜백 처리
              callback: (Map<String, String> result) {
                _handlePaymentResultAndCreateAlbum(result);
              },
            );
          },
        ),
      ).then((paymentAndAlbumCreationSuccess) {
        // 결제창이 닫히면 항상 버튼 잠금 해제
        if (mounted) {
          setState(() {
            _isProcessingPayment = false;
          });
        }
        // 최종 성공 신호(true)를 받으면 이 화면도 닫고 이전 화면(AlbumAddScreen)으로 신호를 전달
        if (paymentAndAlbumCreationSuccess == true) {
          context.pop(true);
        }
      });
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('결제 준비 중 오류가 발생했습니다.\n${e.toString()}');
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  // [핵심] 결제 결과 처리 및 앨범 생성
  Future<void> _handlePaymentResultAndCreateAlbum(
    Map<String, String> result,
  ) async {
    if (!mounted) return;

    // 1. 결제 성공 여부 판단 (IamportService의 로직 사용)
    final isSuccess = IamportService.isPaymentSuccessful(result);
    final impUid = IamportService.getImpUid(result);
    final errorMsg = result['error_msg'];

    // 실패 시 처리
    if (!isSuccess || impUid == null) {
      if (mounted) Navigator.pop(context); // 웹뷰 닫기
      _showGlobalDialog('결제 실패', errorMsg ?? '결제가 취소되었습니다.');
      return;
    }

    // 성공 시 처리: 로딩 다이얼로그 표시 (웹뷰 위)
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      // 2. 서버 검증 (Verify)
      final verifyResponse = await _paymentRepository.verifyPayment(impUid);
      final paymentId = verifyResponse.paymentId;

      // 3. 커버 이미지 업로드 (이미지가 있는 경우만)
      String? coverUrl;
      final albumData = widget.albumData ?? {};
      final coverImage = albumData['coverImage'];

      if (coverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(coverImage);
      }

      // 4. 앨범 생성 요청
      String apiType = widget.subscriptionType?.toUpperCase() ?? 'PRO';

      final requestDto = AlbumCreateRequestDto(
        title: (albumData['albumName'] as String? ?? '').trim(),
        coverUrl: coverUrl,
        type: apiType,
        paymentId: paymentId,
        permissionControl: albumData['isPermissionEnabled'] as bool? ?? false,
      );

      await _albumRepository.createAlbum(requestDto);

      // 5. 모든 과정 성공 시: 로딩 다이얼로그 닫고, 결제창에 성공(true) 신호 보내기
      if (mounted) {
        // Pop loading dialog
        Navigator.pop(context);
        // Pop IamportPayment screen, returning `true` for success
        Navigator.pop(context, true);
      }
    } catch (e) {
      // 로딩 및 웹뷰 닫기 (안전 처리)
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);

      if (mounted) {
        _showGlobalDialog(
          '오류',
          '결제는 성공했으나 앨범 생성 중 오류가 발생했습니다.\n${e.toString()}',
        );
      }
    }
  }

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
