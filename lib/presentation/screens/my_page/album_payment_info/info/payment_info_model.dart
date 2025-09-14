class PaymentInfoModel {
  final String date;   // 결제일자
  final String amount; // 결제 금액

  const PaymentInfoModel({
    required this.date,
    required this.amount,
  });
}