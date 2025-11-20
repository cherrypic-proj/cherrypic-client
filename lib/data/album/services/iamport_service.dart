import 'package:cherrypic/presentation/screens/store/components/payment_method_box.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class IamportService {
  // 가맹점 식별 코드
  static const String userCode = 'imp51387560';

  /// ------------------------------------------------------------
  /// ✅ [핵심] 환경별/결제수단별 통합 결제 데이터 생성 함수
  /// 이 함수 하나로 카카오페이와 토스페이를 모두 처리합니다.
  /// ------------------------------------------------------------
  static PaymentData createPaymentDataForEnvironment({
    required String merchantUid,
    required String name,
    required int amount,
    required String buyerName,
    required PaymentMethodType paymentType, // 여기서 카카오인지 토스인지 구분
    bool isProduction = false,
  }) {
    String pg;
    String method;

    // 1. 결제 수단에 따른 PG사 및 PayMethod 설정 분기
    if (paymentType == PaymentMethodType.kakao) {
      // [카카오페이 설정]
      pg = 'kakaopay';
      // 카카오는 'card'나 'EASY_PAY' 등을 사용 (보통 card로 해도 앱이 뜹니다)
      method = 'card';
    } else {
      // [토스페이 설정] - 앱 연동을 위한 필수 설정
      pg = 'tosspay_v2';
      // 토스페이 앱을 바로 띄우려면 반드시 'tosspay'여야 함
      method = 'tosspay';
    }

    return PaymentData(
      pg: pg, // 위에서 결정된 PG사
      payMethod: method, // 위에서 결정된 결제 방식
      name: name,
      merchantUid: merchantUid,
      amount: amount,
      buyerName: buyerName,
      buyerTel: '010-1234-5678',
      buyerEmail: 'test@example.com',
      buyerAddr: '서울시 강남구 신사동 661-16',
      buyerPostcode: '06018',
      appScheme: 'cherrypic', // 필수 설정

      // ⚠️ mRedirectUrl은 제거했습니다 (앱 복귀 충돌 방지)
      customData: {
        'service_type': 'subscription',
        'platform': 'mobile_app',
        'environment': isProduction ? 'production' : 'development',
      },
    );
  }

  /// ------------------------------------------------------------
  /// ✅ 결제 결과 성공 여부 판단 함수
  /// (imp_uid가 있으면 성공으로 간주하도록 수정됨)
  /// ------------------------------------------------------------
  static bool isPaymentSuccessful(Map<String, String> result) {
    final success = result['success'];
    final impSuccess = result['imp_success'];
    final impUid = result['imp_uid'];
    final errorMsg = result['error_msg'];

    print(
      '🔍 결제 결과 분석: success=$success, imp_success=$impSuccess, imp_uid=$impUid',
    );

    // 성공 조건: success가 true이거나, imp_uid가 존재하면 성공으로 간주
    if (success == 'true' ||
        impSuccess == 'true' ||
        (impUid != null && errorMsg == null)) {
      print('✅ 결제 성공 확인 (imp_uid: $impUid)');
      return true;
    } else {
      final errorCode = result['error_code'];
      print('❌ 결제 실패: $errorCode - $errorMsg');
      return false;
    }
  }

  // IMP UID 추출 헬퍼 함수
  static String? getImpUid(Map<String, String> result) {
    return result['imp_uid'];
  }
}

// (선택 사항) 결제 결과 모델 클래스 - 필요하면 사용
class PaymentResult {
  final bool isSuccess;
  final String? impUid;
  final String? errorMessage;

  PaymentResult({required this.isSuccess, this.impUid, this.errorMessage});
}
