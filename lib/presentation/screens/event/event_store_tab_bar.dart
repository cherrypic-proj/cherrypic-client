import 'package:flutter/material.dart';

import '../../../core/constants/color.dart';

class EventStoreTabBar extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const EventStoreTabBar({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 12, 30, 12),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
        ),
        _buildCustomDivider(1),
      ],
    );
  }

  Widget _buildCustomDivider(double thickness) {
    return Divider(
      color: AppColor.subSlicer,
      thickness: thickness,
      height: 1,
      indent: 0,
      endIndent: 0,
    );
  }
}
