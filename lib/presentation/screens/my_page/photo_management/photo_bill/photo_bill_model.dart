import '../../../../widgets/album/album_badge_type.dart';

class PhotoBillModel {
  final String title;
  final String date;
  final AlbumBadgeType badgeType;

  PhotoBillModel({
    required this.title,
    required this.date,
    required this.badgeType,
  });
}