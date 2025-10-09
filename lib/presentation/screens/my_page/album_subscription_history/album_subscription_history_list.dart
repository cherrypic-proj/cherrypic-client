import 'package:flutter/material.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';

/// 앨범 가입 이력 아이콘 타입
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

  static const Map<NoticeIconType, String> _iconPathMap = {
    NoticeIconType.subscribeIn: 'assets/images/subscription_in.png',
    NoticeIconType.subscribeOut: 'assets/images/subscription_out.png',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(onTap: onTap, child: _buildContent()),
        _buildCustomDivider(2),
      ],
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 96, 16),
      color: Colors.white,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(_iconPathMap[iconType]!, width: 24, height: 24),
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
                  style: AppFont.size10.copyWith(color: AppColor.subGrey),
                ),
              ],
            ),
          ),
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
}