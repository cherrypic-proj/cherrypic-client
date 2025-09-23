// lib/data/album/dto/response/album_dto.dart (수정 완료)

import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';

class AlbumDto {
  final int albumId;
  final String title;
  final String? coverUrl;
  final String type; // BASIC, PRO, PREMIUM
  final int price;
  final String? status; // ACTIVE, CANCELED, EXPIRED (null 허용)
  final bool marked; // 좋아요 표시
  final String createdAt;

  AlbumDto({
    required this.albumId,
    required this.title,
    this.coverUrl,
    required this.type,
    required this.price,
    this.status, // null 허용
    required this.marked,
    required this.createdAt,
  });

  factory AlbumDto.fromJson(Map<String, dynamic> json) {
    return AlbumDto(
      albumId: json['albumId'],
      title: json['title'],
      coverUrl: json['coverUrl'],
      type: json['type'],
      price: json['price'] ?? 0,
      status: json['status'],
      marked: json['marked'] ?? false,
      createdAt: json['createdAt'],
    );
  }

  // UI에서 사용할 형태로 변환
  Map<String, dynamic> toAlbumData() {
    return {
      'id': albumId,
      'title': title,
      'imageUrl': coverUrl ?? '',
      'badgeType': _typeToBadgeType(),
      'isLiked': marked,
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
  final bool isLast;

  AlbumListResponseDto({required this.albums, required this.isLast});

  factory AlbumListResponseDto.fromJson(Map<String, dynamic> json) {
    return AlbumListResponseDto(
      albums: (json['content'] as List? ?? [])
          .map((albumJson) => AlbumDto.fromJson(albumJson))
          .toList(),
      isLast: json['isLast'] ?? true,
    );
  }
}
