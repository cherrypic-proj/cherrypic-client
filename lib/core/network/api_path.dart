class ApiPath {
  static const String authSocialLogin = '/auth/social-login';
  static const String authReissue = '/auth/reissue';

  // 앨범 관련 API
  static const String albums = '/albums';
  static String albumDetail(int albumId) => '/albums/$albumId';

  // ... 다른 API 경로들도 여기에 추가
}
