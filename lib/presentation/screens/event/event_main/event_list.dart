import 'package:flutter/material.dart';
import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/font.dart';

class EventList extends StatelessWidget {
  final String eventImage;
  final String date;
  final String title;
  final VoidCallback? onTap;


  const EventList({
    super.key,
    required this.eventImage,
    required this.date,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(onTap: onTap, child: _buildContent()),
        _buildCustomDivider(1),
      ],
    );
  }

  /// 앨범 가입 이력 리스트 본문
  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 17.5, 10, 17.5),
      color: Colors.white,
      width: double.infinity,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(eventImage, width: 45, height: 45),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 이벤트 SubTitle(날짜)
                Text(
                  date,
                  style: AppFont.size10.copyWith(color: AppColor.subGrey),
                ),

                const SizedBox(height: 4),

                /// 이벤트 Title
                Text(
                  title,
                  style: AppFont.size16.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 리스트 구분선
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
