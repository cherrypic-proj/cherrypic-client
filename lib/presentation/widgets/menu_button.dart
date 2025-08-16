import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';

enum EventStoreIconType { event, store }

class MenuButton extends StatelessWidget {
  final EventStoreIconType iconType;
  final String title;

  const MenuButton({super.key, required this.iconType, required this.title});

  static const Map<EventStoreIconType, String> _iconPathMap = {
    EventStoreIconType.event: 'assets/images/menu_icon_1.png',
    EventStoreIconType.store: 'assets/images/menu_icon_2.png',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(color: AppColor.mainRed),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(_iconPathMap[iconType]!, width: 20, height: 20),
          const SizedBox(width: 10),
          Text(
            title,
            style: AppFont.size20.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
