class AlbumSubscriptionInfoDto {
  final String subscriptionStartAt;
  final String subscriptionEndAt;
  final String subscriptionNextBillingAt;
  final String status;

  AlbumSubscriptionInfoDto({
    required this.subscriptionStartAt,
    required this.subscriptionEndAt,
    required this.subscriptionNextBillingAt,
    required this.status,
  });

  factory AlbumSubscriptionInfoDto.fromJson(Map<String, dynamic> json) {
    return AlbumSubscriptionInfoDto(
      subscriptionStartAt: json['subscriptionStartAt'] as String,
      subscriptionEndAt: json['subscriptionEndAt'] as String,
      subscriptionNextBillingAt: json['subscriptionNextBillingAt'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptionStartAt': subscriptionStartAt,
      'subscriptionEndAt': subscriptionEndAt,
      'subscriptionNextBillingAt': subscriptionNextBillingAt,
      'status': status
    };
  }
}
