class AlbumPaymentInfoDto {
  final int paymentId;
  final String paidAt;
  final int amount;

  AlbumPaymentInfoDto({
    required this.paymentId,
    required this.paidAt,
    required this.amount,
  });

  factory AlbumPaymentInfoDto.fromJson(Map<String, dynamic> json) {
    return AlbumPaymentInfoDto(
      paymentId: json['paymentId'] as int,
      paidAt: json['paidAt'] as String,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'paidAt': paidAt,
      'amount': amount,
    };
  }
}

class AlbumPaymentInfoResponseDto {
  final List<AlbumPaymentInfoDto> content;
  final bool isLast;

  AlbumPaymentInfoResponseDto({required this.content, required this.isLast});

  factory AlbumPaymentInfoResponseDto.fromJson(Map<String, dynamic> json) {
    return AlbumPaymentInfoResponseDto(
      content: (json['content'] as List? ?? [])
          .map((item) => AlbumPaymentInfoDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      isLast: json['isLast'] as bool? ?? true,
    );
  }
}
