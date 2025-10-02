class AlbumCreateRequestDto {
  final String title;
  final String? coverUrl;
  final String type; // BASIC, PRO, PREMIUM
  final int? paymentId; // 무료는 null, 유료는 결제 검증 후 받은 ID
  final bool permissionControl;

  AlbumCreateRequestDto({
    required this.title,
    this.coverUrl,
    required this.type,
    this.paymentId,
    required this.permissionControl,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'type': type,
      'permissionControl': permissionControl,
    };

    // coverUrl이 있는 경우에만 추가
    if (coverUrl != null && coverUrl!.isNotEmpty) {
      json['coverUrl'] = coverUrl;
    }

    // paymentId가 있는 경우에만 추가 (유료 앨범)
    if (paymentId != null) {
      json['paymentId'] = paymentId;
    }

    return json;
  }
}
