import 'package:flutter/material.dart';
import '../../../../widgets/album/album_badge_type.dart';
import 'photo_bill_model.dart';

class PhotoBillViewModel extends ChangeNotifier {
  final List<PhotoBillModel> _albums = [
    PhotoBillModel(
      title: '등산',
      date: '2025/06/25',
      badgeType: AlbumBadgeType.pro,
    ),
    PhotoBillModel(
      title: '여름 여행',
      date: '2025/07/02',
      badgeType: AlbumBadgeType.premium,
    ),
  ];

  List<PhotoBillModel> get albums => _albums;
}