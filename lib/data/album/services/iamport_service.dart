import 'package:cherrypic/presentation/screens/store/components/payment_method_box.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class IamportService {
  // React 코드와 동일한 가맹점 코드 사용
  static const String userCode = 'imp14735503';

  // 기존 호환성을 위한 카카오페이 결제 데이터 생성
  static PaymentData createPaymentData({
    required String merchantUid,
    required String name,
    required int amount,
    required String buyerName,
  }) {
    return PaymentData(
      pg: 'kakaopay', // React 코드와 동일
      payMethod: 'card',
      name: name, // 테스트 표시 제거 (React 코드와 동일)
      merchantUid: merchantUid,
      amount: amount, // 실제 금액 사용 (React 코드와 동일)
      buyerName: buyerName,
      buyerTel: '010-1234-5678',
      buyerEmail: 'test@example.com',
      buyerAddr: '서울시 강남구 신사동 661-16',
      buyerPostcode: '06018',
      appScheme: 'cherrypic',
      customData: {'service_type': 'subscription', 'platform': 'mobile_app'},
    );
  }

  // 토스페이 결제 데이터 생성
  static PaymentData createTossPaymentData({
    required String merchantUid,
    required String name,
    required int amount,
    required String buyerName,
  }) {
    return PaymentData(
      pg: 'tosspay',
      payMethod: 'card',
      name: name,
      merchantUid: merchantUid,
      amount: amount,
      buyerName: buyerName,
      buyerTel: '010-1234-5678',
      buyerEmail: 'test@example.com',
      buyerAddr: '서울시 강남구 신사동 661-16',
      buyerPostcode: '06018',
      appScheme: 'cherrypic',
      customData: {'service_type': 'subscription', 'platform': 'mobile_app'},
    );
  }

  // 결제 결과 처리 (React 코드 로직과 동일)
  static bool isPaymentSuccessful(Map<String, String> result) {
    // React: rsp.success 체크
    final success = result['success'];
    final impSuccess = result['imp_success'];

    print('결제 결과 success 값: $success');
    print('결제 결과 imp_success 값: $impSuccess');
    print('전체 결과: $result');

    // React 코드와 동일한 로직
    if (success == 'true' || impSuccess == 'true') {
      print('✅ 결제 성공');
      return true;
    } else {
      final errorCode = result['error_code'];
      final errorMsg = result['error_msg'];
      print('❌ 결제 실패: $errorCode - $errorMsg');
      return false;
    }
  }

  // IMP UID 추출 (React: rsp 객체에서 추출)
  static String? getImpUid(Map<String, String> result) {
    return result['imp_uid'];
  }

  // 환경별 결제 데이터 생성
  static PaymentData createPaymentDataForEnvironment({
    required String merchantUid,
    required String name,
    required int amount,
    required String buyerName,
    required PaymentMethodType paymentType,
    bool isProduction = false,
  }) {
    String pg;

    // React 코드 기반 PG 설정
    if (paymentType == PaymentMethodType.kakao) {
      pg = 'kakaopay'; // React 코드와 동일
    } else {
      pg = 'tosspay';
    }

    return PaymentData(
      pg: pg,
      payMethod: 'card',
      name: name, // React 코드처럼 원본 이름 사용
      merchantUid: merchantUid,
      amount: amount, // React 코드처럼 실제 금액 사용
      buyerName: buyerName,
      buyerTel: '010-1234-5678',
      buyerEmail: 'test@example.com',
      buyerAddr: '서울시 강남구 신사동 661-16',
      buyerPostcode: '06018',
      appScheme: 'cherrypic',
      customData: {
        'service_type': 'subscription',
        'platform': 'mobile_app',
        'environment': isProduction ? 'production' : 'development',
      },
    );
  }
}

// 결제 결과 모델
class PaymentResult {
  final bool isSuccess;
  final String? impUid;
  final String? errorMessage;

  PaymentResult({required this.isSuccess, this.impUid, this.errorMessage});
}
