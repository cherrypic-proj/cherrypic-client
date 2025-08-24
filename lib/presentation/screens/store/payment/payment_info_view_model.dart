import 'package:cherrypic/presentation/screens/store/payment/payment_info_model.dart';
import 'package:intl/intl.dart';

class PaymentInfoViewModel {
  final PaymentInfoModel model;

  PaymentInfoViewModel(this.model);

  String get formattedProductPrice => '월 ${_format(model.productPrice)}원';
  String get formattedSubscriptionValue => '${model.subscriptionValue} 앨범';
  String get nextPaymentDate => model.nextPaymentDate;
  String get formattedTotalPrice => '월 ${_format(model.totalPrice)}원';

  String _format(int value) => NumberFormat('#,###').format(value);
}