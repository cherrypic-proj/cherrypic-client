import 'package:flutter/material.dart';
import 'payment_info_model.dart';

class PaymentInfoViewModel extends ChangeNotifier {
  /// 전체 결제 내역 리스트 (더미 데이터)
  final List<PaymentInfoModel> _allPayments = const [
    PaymentInfoModel(date: "2025/08/01", amount: "-3,900 원"),
    PaymentInfoModel(date: "2025/07/01", amount: "-3,900 원"),
    PaymentInfoModel(date: "2025/06/01", amount: "-3,900 원"),
  ];

  List<PaymentInfoModel> get payments {
    return List.unmodifiable(_allPayments);
  }
}