class ApiPath {
  static const String authSocialLogin = '/auth/social-login';
  static const String authReissue = '/auth/reissue';

  // 앨범 관련 API
  static const String albums = '/albums';
  static String albumDetail(int albumId) => '/albums/$albumId';
  static String albumInvitationLink(int albumId) =>
      '/albums/$albumId/invitation-link';
  static String albumImages(int albumId) => '/albums/$albumId/images';

  static String albumSubscription(int albumId) => '/albums/$albumId/subscriptions';

  // 앨범 이벤트
  static const String events = '/events';
  static const String eventsCoverUploadUrl = '/events/cover-upload-url';
  static String eventImages(int eventId) => '/events/$eventId/images';
  static String eventDetail(int eventId) => '/events/$eventId';

  // ... 다른 API 경로들도 여기에 추가

  // 멤버 관련 API
  static String memberInfo() => '/members/me';
  static const String memberProfileImage = '/members/profile-upload-url';

  // 결제 관련 API
  static const String albumPaymentInfo = '/payments';
}
