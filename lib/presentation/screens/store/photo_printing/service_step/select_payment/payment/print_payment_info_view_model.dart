import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/payment/print_payment_info_model.dart';
import 'package:intl/intl.dart';

class PrintPaymentInfoViewModel {
  final PrintPaymentInfoModel model;

  PrintPaymentInfoViewModel(this.model);

  String formatPrice(int value) => '${_format(value)}원';

  String discountPrice(int value) => '-${_format(value)}원';

  /// 금액 format
  String _format(int value) => NumberFormat('#,###').format(value);
}