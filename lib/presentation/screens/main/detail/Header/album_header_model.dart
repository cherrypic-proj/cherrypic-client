class AlbumHeaderData {
  final int albumId;
  final String title; // 앨범명
  final String coverUrl; // 커버 이미지
  final int photoCount; // 사진 수
  final double progress; // 0.0 ~ 1.0
  final String badgeText; // 배지 텍스트

  AlbumHeaderData({
    required this.albumId,
    required this.title,
    required this.coverUrl,
    required this.photoCount,
    required this.progress,
    required this.badgeText,
  });
}
