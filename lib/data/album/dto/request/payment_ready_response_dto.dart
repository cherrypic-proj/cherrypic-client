class PaymentReadyResponseDto {
  final String type;
  final int price;
  final String merchantUid;
  final String buyerName;
  final String purpose; // RENEWAL 등

  PaymentReadyResponseDto({
    required this.type,
    required this.price,
    required this.merchantUid,
    required this.buyerName,
    required this.purpose,
  });

  factory PaymentReadyResponseDto.fromJson(Map<String, dynamic> json) {
    return PaymentReadyResponseDto(
      type: json['type'],
      price: json['price'],
      merchantUid: json['merchantUid'],
      buyerName: json['buyerName'],
      purpose: json['purpose'],
    );
  }
}
