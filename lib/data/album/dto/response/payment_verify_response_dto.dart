class PaymentVerifyResponseDto {
  final int paymentId;

  PaymentVerifyResponseDto({required this.paymentId});

  factory PaymentVerifyResponseDto.fromJson(Map<String, dynamic> json) {
    return PaymentVerifyResponseDto(paymentId: json['paymentId']);
  }
}
