import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/data/album/repositories/payment_repository.dart';
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
  final String? subscriptionType; // 'pro' 또는 'premium'
  final Map<String, dynamic>? albumData; // 앨범 생성 데이터

  const PaymentMethodScreen({super.key, this.subscriptionType, this.albumData});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethodType _selectedMethod = PaymentMethodType.kakao;
  bool _isProcessingPayment = false;

  // 구독 타입에 따른 결제 정보 생성
  PaymentInfoModel _getPaymentModel() {
    if (widget.subscriptionType == 'pro') {
      return PaymentInfoModel(
        productPrice: 3900,
        subscriptionValue: 'CherryPic Pro',
        nextPaymentDate: '2025년 9월 20일',
        totalPrice: 3900,
      );
    } else if (widget.subscriptionType == 'premium') {
      return PaymentInfoModel(
        productPrice: 6900,
        subscriptionValue: 'CherryPic Premium',
        nextPaymentDate: '2025년 9월 20일',
        totalPrice: 6900,
      );
    } else {
      // 기본값 (기존 코드와 동일)
      return PaymentInfoModel(
        productPrice: 3900,
        subscriptionValue: 'CherryPic Pro',
        nextPaymentDate: '2025년 9월 20일',
        totalPrice: 3900,
      );
    }
  }

  // 실제 결제 처리
  Future<void> _processPayment() async {
    if (_isProcessingPayment) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      // 1. 결제 준비 API 호출
      final subscriptionType = widget.subscriptionType?.toUpperCase() ?? 'PRO';
      final readyResponse = await PaymentRepository().readyPayment(
        type: subscriptionType,
        albumId: null,
      );

      // 2. 아임포트 결제 데이터 생성
      final paymentData = IamportService.createPaymentDataForEnvironment(
        merchantUid: readyResponse.merchantUid,
        name: readyResponse.purpose,
        amount: readyResponse.price,
        buyerName: readyResponse.buyerName,
        paymentType: _selectedMethod,
        isProduction: false,
      );

      // 3. 결제 진행
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IamportPayment(
            appBar: AppBar(
              title: const Text('결제하기'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            initialChild: Container(
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('결제 준비중...'),
                  ],
                ),
              ),
            ),
            userCode: IamportService.userCode,
            data: paymentData,
            callback: (result) {
              Navigator.pop(context, result);
            },
          ),
        ),
      );

      if (result != null) {
        _handlePaymentResult(result);
      } else {
        _showErrorDialog('결제가 취소되었습니다.');
      }
    } catch (e) {
      _showErrorDialog('결제 준비 중 오류가 발생했습니다: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  // 결제 결과 처리
  void _handlePaymentResult(Map<String, String> result) {
    final isSuccess = IamportService.isPaymentSuccessful(result);
    final impUid = IamportService.getImpUid(result);

    if (isSuccess && impUid != null) {
      // 결제 성공 - 완료 화면으로 이동
      context.pushReplacement(
        RoutePath.payment_complete,
        extra: {
          'subscriptionType': widget.subscriptionType,
          'albumData': widget.albumData,
          'paymentMethod': _selectedMethod,
          'impUid': impUid,
          'isSuccess': true,
        },
      );
    } else {
      // 결제 실패
      final errorMsg = result['error_msg'] ?? '결제에 실패했습니다.';
      _showErrorDialog('결제 실패: $errorMsg');
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

                      /// Title
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

                      /// 결제 수단 방식 Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaymentMethodBox(
                            type: PaymentMethodType.kakao,
                            isSelected:
                                _selectedMethod == PaymentMethodType.kakao,
                            onTap: () {
                              setState(() {
                                _selectedMethod = PaymentMethodType.kakao;
                              });
                            },
                          ),
                          const SizedBox(width: 70),
                          PaymentMethodBox(
                            type: PaymentMethodType.toss,
                            isSelected:
                                _selectedMethod == PaymentMethodType.toss,
                            onTap: () {
                              setState(() {
                                _selectedMethod = PaymentMethodType.toss;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 38.8),

                /// 구분선
                Container(height: 4, color: AppColor.subSlicer),
                const SizedBox(height: 46.28),

                /// 결제 정보
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

                      /// 결제 세부 정보
                      PaymentInfo(viewModel: viewModel),
                      const SizedBox(height: 92.45),

                      /// 결제하기 버튼
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
