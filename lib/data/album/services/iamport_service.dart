import 'package:cherrypic/presentation/screens/store/components/payment_method_box.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class IamportService {
  // 실제 가맹점 식별코드로 변경 필요 (아임포트에서 발급받은 코드)
  // 테스트용: imp00000000, 실제용: imp + 고유번호
  static const String userCode = 'iamport'; // 테스트 가맹점 코드

  // 실제 서비스에서는 환경에 따라 분리
  // static const String userCode = 'kakaopay.TC0ONETIME'; // 실제 카카오페이 가맹점 코드

  // 카카오페이 결제 데이터 생성
  static PaymentData createPaymentData({
    required String merchantUid,
    required String name,
    required int amount,
    required String buyerName,
  }) {
    return PaymentData(
      pg: 'kakaopay.TC0ONETIME', // 실제 채널 키 사용
      payMethod: 'card', // 결제 방법
      name: name, // 상품명
      merchantUid: merchantUid, // 고유 주문번호
      amount: amount, // 결제 금액
      buyerName: buyerName, // 구매자 이름
      buyerTel: '010-1234-5678', // 구매자 전화번호 (실제 사용자 정보로 변경 필요)
      buyerEmail: 'test@example.com', // 구매자 이메일 (실제 사용자 정보로 변경 필요)
      buyerAddr: '서울특별시 강남구', // 구매자 주소
      buyerPostcode: '06018', // 구매자 우편번호
      appScheme: 'cherrypic', // 앱 스킴 (실제 앱의 URL Scheme으로 변경)
      // 카카오페이 전용 설정
      customData: {
        'service_type': 'subscription', // 구독 서비스 표시
        'platform': 'mobile_app', // 플랫폼 정보
      },
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
      pg: 'tosspay.tosstest', // 토스페이 PG 설정 (테스트: tosstest, 실제: 실제 가맹점코드)
      payMethod: 'card',
      name: name,
      merchantUid: merchantUid,
      amount: amount,
      buyerName: buyerName,
      buyerTel: '010-1234-5678',
      buyerEmail: 'test@example.com',
      buyerAddr: '서울특별시 강남구',
      buyerPostcode: '06018',
      appScheme: 'cherrypic',
      customData: {'service_type': 'subscription', 'platform': 'mobile_app'},
    );
  }

  // 결제 결과 처리
  static bool isPaymentSuccessful(Map<String, String> result) {
    final success = result['success'];
    final errorCode = result['error_code'];
    final errorMsg = result['error_msg'];

    if (success == 'true') {
      return true;
    } else {
      // 결제 실패 로그
      print('결제 실패: $errorCode - $errorMsg');
      return false;
    }
  }

  // IMP UID 추출
  static String? getImpUid(Map<String, String> result) {
    return result['imp_uid'];
  }

  // 결제 환경 설정 (개발/운영 분리)
  static PaymentData createPaymentDataForEnvironment({
    required String merchantUid,
    required String name,
    required int amount,
    required String buyerName,
    required PaymentMethodType paymentType,
    bool isProduction = false, // 운영 환경 여부
  }) {
    String pg;

    if (paymentType == PaymentMethodType.kakao) {
      // 임시로 여러 형식을 시도해볼 수 있도록 설정
      pg = 'kakaopay'; // 가장 기본적인 형식부터 시도
    } else {
      pg = isProduction ? 'tosspay' : 'tosspay.tosstest';
    }

    return PaymentData(
      pg: pg,
      payMethod: 'card',
      name: name,
      merchantUid: merchantUid,
      amount: amount,
      buyerName: buyerName,
      buyerTel: '010-1234-5678',
      buyerEmail: 'test@example.com',
      buyerAddr: '서울특별시 강남구',
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

// PaymentMethodType은 payment_method_box.dart에서 import하여 사용

// 결제 결과 모델
class PaymentResult {
  final bool isSuccess;
  final String? impUid;
  final String? errorMessage;

  PaymentResult({required this.isSuccess, this.impUid, this.errorMessage});
}
