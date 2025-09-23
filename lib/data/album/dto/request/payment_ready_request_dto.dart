class PaymentReadyRequestDto {
  final String type; // PRO, PREMIUM
  final int? albumId; // 첫 생성시엔 null

  PaymentReadyRequestDto({required this.type, this.albumId});

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'type': type};

    if (albumId != null) {
      json['albumId'] = albumId;
    }

    return json;
  }
}
