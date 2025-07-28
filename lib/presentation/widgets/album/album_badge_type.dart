import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';

enum AlbumBadgeType { none, basic, pro, premium }

extension AlbumBadgeTypeExtension on AlbumBadgeType {
  String get label {
    switch (this) {
      case AlbumBadgeType.basic:
        return 'Basic';
      case AlbumBadgeType.pro:
        return 'CherryPic Pro';
      case AlbumBadgeType.premium:
        return 'CherryPic Premium';
      case AlbumBadgeType.none:
        return '';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AlbumBadgeType.basic:
        return Colors.white;
      case AlbumBadgeType.pro:
        return AppColor.mainLightRed;
      case AlbumBadgeType.premium:
        return AppColor.mainRed;
      case AlbumBadgeType.none:
        return Colors.transparent;
    }
  }

  Color get borderColor {
    switch (this) {
      case AlbumBadgeType.basic:
        return const Color(0xFFBCBCBC);
      case AlbumBadgeType.pro:
        return AppColor.mainLightRed;
      case AlbumBadgeType.premium:
        return AppColor.mainRed;
      case AlbumBadgeType.none:
        return const Color(0xFFBCBCBC);
    }
  }

  Color get shadowColor {
    switch (this) {
      case AlbumBadgeType.basic:
        return Color.fromRGBO(189, 189, 189, 0.5); // 회색
      case AlbumBadgeType.pro:
        return Color.fromRGBO(255, 112, 112, 0.5); // mainLightRed
      case AlbumBadgeType.premium:
        return Color.fromRGBO(255, 0, 0, 0.8); // mainRed
      case AlbumBadgeType.none:
        return Colors.transparent;
    }
  }

  Color get textColor {
    switch (this) {
      case AlbumBadgeType.basic:
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}
