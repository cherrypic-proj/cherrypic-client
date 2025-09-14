import '../../../widgets/album/album_badge_type.dart';

class AlbumPaymentInfoModel {
  final AlbumBadgeType badgeType;
  final String title;
  final String createDate;
  final String? startDate;
  final String? nextDate;
  final String price;

  const AlbumPaymentInfoModel({
    required this.badgeType,
    required this.title,
    required this.createDate,
    this.startDate,
    this.nextDate,
    required this.price,
  });
}