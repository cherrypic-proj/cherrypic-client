import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../data/album/repositories/album_repository.dart';
import 'payment_info_model.dart';

class PaymentInfoViewModel extends ChangeNotifier {
  final AlbumRepository _repository;

  List<PaymentInfoModel> _payments = [];

  final NumberFormat _currencyFormatter = NumberFormat.decimalPattern('ko_KR');

  PaymentInfoViewModel({AlbumRepository? repository})
      : _repository = repository ?? AlbumRepository();

  List<PaymentInfoModel> get payments {
    return List.unmodifiable(_payments);
  }

  Future<void> loadPayments(int albumId) async {
    try {
      final response = await _repository.getAlbumPaymentInfo(albumId: albumId);

      _payments = response.content.map((dto) {
        final dateString = _formatDate(dto.paidAt);

        final formattedAmount = _formatAmountToCurrency(dto.amount);

        return PaymentInfoModel(
          date: dateString,
          amount: formattedAmount,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      // 에러 처리 로직 추가
      debugPrint('결제 내역 로딩 에러: $e');
    }
  }

  String _formatAmountToCurrency(int amount) {
    final negativeAmount = -amount;

    final formatted = _currencyFormatter.format(negativeAmount);

    return '$formatted 원';
  }

  String _formatDate(String paidAt) {
    try {
      final dateTime = DateTime.parse(paidAt);
      return DateFormat('yyyy/MM/dd').format(dateTime);
    } catch (e) {
      // 파싱 실패 시 원본 문자열 반환
      return paidAt;
    }
  }
}