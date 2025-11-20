import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/router/app_router.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/repositories/payment_repository.dart';
import 'package:cherrypic/data/album/services/album_cover_image_service.dart';
import 'package:cherrypic/data/album/services/iamport_service.dart';
import 'package:cherrypic/presentation/screens/main/album/add/payment_result_processing_screen.dart';
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
    print('====== [DEBUG] _processPayment 함수 시작 ======');

    // 1. 이미 결제 진행 중이면 막음 (bool true 체크)
    if (_isProcessingPayment) {
      print('[DEBUG] ❌ 차단됨: 이미 결제가 진행 중입니다 (_isProcessingPayment = true)');
      return;
    }
    if (!mounted) {
      print('[DEBUG] ❌ 차단됨: 위젯이 마운트되지 않았습니다');
      return;
    }

    print('[DEBUG] 🔒 버튼 잠금 시작 (setState -> true)');
    setState(() {
      _isProcessingPayment = true; // 잠금 시작
    });

    try {
      final subscriptionType = widget.subscriptionType?.toUpperCase() ?? 'PRO';

      print('[DEBUG] 1. API 요청 시작: /payments/ready (Type: $subscriptionType)');

      final readyResponse = await _paymentRepository.readyPayment(
        type: subscriptionType,
        albumId: null,
      );

      print('[DEBUG] ✅ API 응답 성공: MerchantUid = ${readyResponse.merchantUid}');

      if (!mounted) {
        print('[DEBUG] ⚠️ API 응답 후 위젯 마운트 해제됨. 중단.');
        return;
      }

      print('[DEBUG] 2. 아임포트 결제 데이터 생성 중...');
      final paymentData = IamportService.createPaymentDataForEnvironment(
        merchantUid: readyResponse.merchantUid,
        name: readyResponse.purpose,
        amount: readyResponse.price,
        buyerName: readyResponse.buyerName,
        paymentType: _selectedMethod,
        isProduction: false,
      );

      print('[DEBUG] 3. 복구용 앨범 데이터 static 변수에 저장 중...');
      PaymentResultProcessingScreen.pendingAlbumData = {
        'albumName': widget.albumData?['albumName'],
        'coverImage': widget.albumData?['coverImage'],
        'isPermissionEnabled': widget.albumData?['isPermissionEnabled'],
        'subscriptionType': widget.subscriptionType?.toUpperCase() ?? 'PRO',
      };

      print('[DEBUG] 4. Navigator.push 실행 직전 (결제창 띄우기)');

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            print('[DEBUG] 📲 IamportPayment 위젯 build() 실행됨 (화면 그려지는 중)');
            return IamportPayment(
              appBar: AppBar(
                title: const Text('결제하기'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    print('[DEBUG] ✋ 사용자가 결제창 닫기 버튼(X) 클릭');
                    Navigator.pop(context);
                  },
                ),
              ),
              initialChild: const Center(child: CircularProgressIndicator()),
              userCode: IamportService.userCode,
              data: paymentData,
              callback: (Map<String, String> result) {
                print('[DEBUG] 📩 결제 결과 콜백 수신: $result');
                _handlePaymentResultAndCreateAlbum(result);
              },
            );
          },
        ),
      ).then((_) {
        print('[DEBUG] 🔄 결제창 닫힘(Pop) 감지됨. 버튼 잠금 해제 시도.');
        // [중요 수정] 결제 화면에서 돌아왔을 때 (취소했든, 완료했든)
        // 반드시 버튼 잠금을 풀어줘야 다음 시도가 가능합니다.
        if (mounted) {
          setState(() {
            _isProcessingPayment = false;
          });
          print('[DEBUG] 🔓 버튼 잠금 해제 완료 (_isProcessingPayment = false)');
        } else {
          print('[DEBUG] ⚠️ 마운트 해제로 인해 버튼 잠금 해제 스킵');
        }
      });
    } catch (e) {
      print('[DEBUG] 🚨 에러 발생: $e');

      if (!mounted) return;
      _showErrorDialog('결제 준비 중 오류: ${e.toString()}');

      setState(() {
        _isProcessingPayment = false;
      });
      print('[DEBUG] 🔓 에러 발생으로 버튼 잠금 해제 완료');
    }
  }

  Future<void> _handlePaymentResultAndCreateAlbum(
    Map<String, String> result,
  ) async {
    // ✅ [핵심 수정] 화면이 이미 죽었다면(리다이렉트 되어 이동했다면) 여기서 즉시 종료!
    // 이 코드가 없으면 "This widget has been unmounted" 에러가 발생합니다.
    if (!mounted) {
      print('[DEBUG] 화면이 Unmounted 상태이므로 콜백 로직을 중단합니다. (Redirect가 정상 동작함)');
      return;
    }

    final isSuccess = IamportService.isPaymentSuccessful(result);
    final impUid = IamportService.getImpUid(result);
    final errorMsg = result['error_msg'];

    // 1. 결제 실패 시 처리 (실패했을 땐 리다이렉트가 안 될 수 있으므로 여기서 처리)
    if (!isSuccess || impUid == null) {
      if (mounted) Navigator.pop(context); // 웹뷰 닫기
      _showGlobalDialog('결제 실패', errorMsg ?? '결제가 취소되었습니다.');
      return;
    }

    // 2. 결제 성공 시 처리 (혹시 리다이렉트가 실패했을 때를 대비한 비상용 코드)
    // 리다이렉트가 정상 작동하면 아래 코드는 실행되기 전에 위에서 return 됩니다.

    if (mounted) {
      // 로딩 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      print('[DEBUG] (Fallback) 1. 결제 검증 시작: $impUid');
      final verifyResponse = await _paymentRepository.verifyPayment(impUid);
      final paymentId = verifyResponse.paymentId;

      print('[DEBUG] (Fallback) 2. 커버 이미지 업로드 시작');
      String? coverUrl;
      final albumData = widget.albumData ?? {};
      final coverImage = albumData['coverImage'];

      if (coverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(coverImage);
      }

      print('[DEBUG] (Fallback) 3. 앨범 생성 요청');
      String apiType = widget.subscriptionType?.toUpperCase() ?? 'PRO';

      final requestDto = AlbumCreateRequestDto(
        title: (albumData['albumName'] as String? ?? '').trim(),
        coverUrl: coverUrl,
        type: apiType,
        paymentId: paymentId,
        permissionControl: albumData['isPermissionEnabled'] as bool? ?? false,
      );

      await _albumRepository.createAlbum(requestDto);

      // 4. 성공 시 홈으로 이동
      if (mounted) {
        context.go(RoutePath.home);
      }
    } catch (e) {
      print('[ERROR] 앨범 생성 실패: $e');

      // 안전하게 다이얼로그 닫기
      if (mounted && Navigator.canPop(context)) Navigator.pop(context); // 로딩 닫기
      if (mounted && Navigator.canPop(context)) Navigator.pop(context); // 웹뷰 닫기

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
