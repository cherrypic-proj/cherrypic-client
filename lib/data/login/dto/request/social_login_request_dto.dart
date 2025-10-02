class SocialLoginRequestDto {
  final String idToken;

  SocialLoginRequestDto({required this.idToken});

  Map<String, dynamic> toJson() {
    return {'idToken': idToken};
  }
}
