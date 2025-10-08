import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_path.dart';
import 'photo_management_model.dart';


class PhotoManagementViewModel extends ChangeNotifier {
  final List<PhotoManagementModel> _menuItems = [
    PhotoManagementModel(
      title: '실물사진 결제 내역',
      onTap: (context) => context.push(RoutePath.myPage_photo_bill),
    ),
    PhotoManagementModel(
      title: '실물사진 배송지 관리',
      onTap: (context) => context.push(RoutePath.myPage_address_management),
    ),
  ];

  List<PhotoManagementModel> get menuItems => _menuItems;
}