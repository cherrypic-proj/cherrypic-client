import 'package:flutter/material.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';

class NoticeList extends StatelessWidget {
  final String date;
  final String title;
  final VoidCallback? onTap;

  const NoticeList({
    super.key,
    required this.date,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(onTap: onTap, child: _buildNoticeTile()),
        _buildCustomDivider(2),
      ],
    );
  }

  Widget _buildNoticeTile() {
    const EdgeInsets contentPadding = EdgeInsets.fromLTRB(30, 20, 30, 20);

    return Container(
      padding: contentPadding,
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: AppFont.size10.copyWith(
              color: AppColor.subGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppFont.size16.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
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