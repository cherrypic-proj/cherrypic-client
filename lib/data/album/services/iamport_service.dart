import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class IamportService {
  // 아임포트 가맹점 식별코드 (테스트용)
  static const String userCode = 'iamport'; // 테스트 가맹점 코드

  // 결제 데이터 생성
  static IamportPayment createPaymentData({
    required String merchantUid,
    required String name,
    required int amount,
    required String buyerName,
  }) {
    return IamportPayment(
      pg: 'html5_inicis', // PG사 (테스트용 - 이니시스)
      payMethod: 'card', // 결제 방법
      name: name, // 상품명
      merchantUid: merchantUid, // 고유 주문번호
      amount: amount, // 결제 금액
      buyerName: buyerName, // 구매자 이름
      buyerTel: '010-1234-5678', // 구매자 전화번호 (테스트용)
      buyerEmail: 'test@example.com', // 구매자 이메일 (테스트용)
      buyerAddr: '서울특별시 강남구', // 구매자 주소 (테스트용)
      buyerPostcode: '06018', // 구매자 우편번호 (테스트용)
      appScheme: 'cherrypic', // 앱 스킴
      cardQuota: [2, 3], // 할부 개월수
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
}

// 결제 결과 모델
class PaymentResult {
  final bool isSuccess;
  final String? impUid;
  final String? errorMessage;

  PaymentResult({required this.isSuccess, this.impUid, this.errorMessage});
}
