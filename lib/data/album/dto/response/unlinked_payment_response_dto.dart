class UnlinkedPaymentResponseDto {
  final int paymentId;
  final String albumType;
  final int amount;
  final String purpose;
  final String paidAt;

  UnlinkedPaymentResponseDto({
    required this.paymentId,
    required this.albumType,
    required this.amount,
    required this.purpose,
    required this.paidAt,
  });

  factory UnlinkedPaymentResponseDto.fromJson(Map<String, dynamic> json) {
    return UnlinkedPaymentResponseDto(
      paymentId: json['paymentId'] as int,
      albumType: json['albumType'] as String,
      amount: json['amount'] as int,
      purpose: json['purpose'] as String,
      paidAt: json['paidAt'] as String,
    );
  }
}
