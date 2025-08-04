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
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 198, 20),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(
                    date,
                    style: AppFont.size10.copyWith(
                      color: AppColor.subGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    title,
                    style: AppFont.size16.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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
}
