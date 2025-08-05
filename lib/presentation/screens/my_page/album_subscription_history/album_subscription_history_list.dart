import 'package:flutter/material.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';

enum NoticeIconType { subscribeIn, subscribeOut }

class AlbumSubscriptionHistoryList extends StatelessWidget {
  final String date;
  final String title;
  final VoidCallback? onTap;
  final NoticeIconType iconType;

  const AlbumSubscriptionHistoryList({
    super.key,
    required this.date,
    required this.title,
    required this.onTap,
    required this.iconType,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 96, 16),
              color: Colors.white,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      _getIconPath(iconType),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppFont.size16.copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: AppFont.size10.copyWith(
                            color: AppColor.subGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildCustomDivider(2),
        ],
      ),
    );
  }

  Widget _buildCustomDivider(double thickness) {
    return Divider(
      color: AppColor.subSlicer,
      thickness: thickness,
      height: 0.5,
      indent: 0,
      endIndent: 0,
    );
  }

  String _getIconPath(NoticeIconType type) {
    switch (type) {
      case NoticeIconType.subscribeIn:
        return 'assets/images/subscription_in.png';
      case NoticeIconType.subscribeOut:
        return 'assets/images/subscription_out.png';
    }
  }
}
