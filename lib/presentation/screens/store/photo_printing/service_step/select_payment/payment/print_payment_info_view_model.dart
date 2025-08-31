import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/payment/print_payment_info_model.dart';
import 'package:intl/intl.dart';

class PrintPaymentInfoViewModel {
  final PrintPaymentInfoModel model;

  PrintPaymentInfoViewModel(this.model);

  /// 일반 금액 표시
  String formatPrice(int value) => '${_format(value)}원';

  /// 할인 금액 표시
  String discountPrice(int value) => '-${_format(value)}원';

  /// 금액 format
  String _format(int value) => NumberFormat('#,###').format(value);
}