class AlbumHeaderData {
  final int albumId;
  final String title; // 앨범명
  final String coverUrl; // 커버 이미지
  final int photoCount; // 사진 수
  final double progress; // 0.0 ~ 1.0
  final String badgeText; // 배지 텍스트

  final String hostName; // 호스트 이름
  final int numOfParticipants; // 참여자 수
  final double capacityUsed; // 사용 용량 (GB)
  final double totalCapacity; // 총 용량 (GB)

  AlbumHeaderData({
    required this.albumId,
    required this.title,
    required this.coverUrl,
    required this.photoCount,
    required this.progress,
    required this.badgeText,
    required this.hostName,
    required this.numOfParticipants,
    required this.capacityUsed,
    required this.totalCapacity,
  });
}
