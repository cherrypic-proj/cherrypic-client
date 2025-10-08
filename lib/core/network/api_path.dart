class ApiPath {
  static const String authSocialLogin = '/auth/social-login';
  static const String authReissue = '/auth/reissue';

  // 앨범 관련 API
  static const String albums = '/albums';
  static String albumDetail(int albumId) => '/albums/$albumId';
  static String albumInvitationLink(int albumId) =>
      '/albums/$albumId/invitation-link';
  static String albumImages(int albumId) => '/albums/$albumId/images';

  // 앨범 이벤트
  static const String events = '/events';
  static const String eventsCoverUploadUrl = '/events/cover-upload-url';
  static String eventImages(int eventId) => '/events/$eventId/images';

  // ... 다른 API 경로들도 여기에 추가
}
