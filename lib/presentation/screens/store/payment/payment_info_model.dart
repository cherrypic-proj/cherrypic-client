class PaymentInfoModel {
  final int productPrice;
  final String subscriptionValue;
  final String nextPaymentDate;
  final int totalPrice;

  PaymentInfoModel({
    required this.productPrice,
    required this.subscriptionValue,
    required this.nextPaymentDate,
    required this.totalPrice,
  });
}