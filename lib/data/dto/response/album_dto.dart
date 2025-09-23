import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';

class AlbumDto {
  final int id;
  final String title;
  final String? coverImageUrl;
  final String type; // BASIC, PRO, PREMIUM
  final String status; // ACTIVE, CANCELED, EXPIRED
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;

  AlbumDto({
    required this.id,
    required this.title,
    this.coverImageUrl,
    required this.type,
    required this.status,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlbumDto.fromJson(Map<String, dynamic> json) {
    return AlbumDto(
      id: json['id'],
      title: json['title'],
      coverImageUrl: json['coverImageUrl'],
      type: json['type'],
      status: json['status'],
      isLiked: json['isLiked'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // UI에서 사용할 형태로 변환
  Map<String, dynamic> toAlbumData() {
    return {
      'id': id,
      'title': title,
      'imageUrl': coverImageUrl ?? '',
      'badgeType': _typeToBadgeType(),
      'isLiked': isLiked,
    };
  }

  AlbumBadgeType _typeToBadgeType() {
    switch (type.toUpperCase()) {
      case 'BASIC':
        return AlbumBadgeType.basic;
      case 'PRO':
        return AlbumBadgeType.pro;
      case 'PREMIUM':
        return AlbumBadgeType.premium;
      default:
        return AlbumBadgeType.none;
    }
  }
}

class AlbumListResponseDto {
  final List<AlbumDto> albums;
  final int totalCount;
  final bool hasNext;

  AlbumListResponseDto({
    required this.albums,
    required this.totalCount,
    required this.hasNext,
  });

  factory AlbumListResponseDto.fromJson(Map<String, dynamic> json) {
    return AlbumListResponseDto(
      albums: (json['albums'] as List)
          .map((albumJson) => AlbumDto.fromJson(albumJson))
          .toList(),
      totalCount: json['totalCount'],
      hasNext: json['hasNext'],
    );
  }
}
