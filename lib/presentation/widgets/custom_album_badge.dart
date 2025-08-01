import 'dart:ui';
import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';
import '../../core/constants/font.dart';

class CustomAlbumBadge extends StatelessWidget {
  final String userName;
  final String memberCountText;
  final bool showBadgeType;
  final String badgeType;
  final bool showAddMemberButton;

  const CustomAlbumBadge({
    super.key,
    required this.userName,
    required this.memberCountText,
    required this.showBadgeType,
    required this.badgeType,
    required this.showAddMemberButton,
  });

  @override
  Widget build(BuildContext context) {
    final badgeImagePath = _getBadgeImagePath(badgeType);
    double containerWidth = (showBadgeType && showAddMemberButton) ? 316 : 223;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: containerWidth,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLeftSection(badgeImagePath),
                const SizedBox(width: 14),
                _buildRightSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getBadgeImagePath(String type) {
    switch (type) {
      case 'pro':
        return 'assets/images/pro_badge.png';
      case 'premium':
        return 'assets/images/premium_badge.png';
      case 'basic':
      default:
        return 'assets/images/basic_badge.png';
    }
  }

  Widget _buildLeftSection(String badgeImagePath) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: (!showBadgeType && !showAddMemberButton) ? 18 : 0),
          child: Image.asset(
            'assets/images/crown_icon.png',
            width: 24,
            height: 18,
          ),
        ),
        const SizedBox(width: 14),
        Text(
          userName,
          style: AppFont.size16.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(width: (!showBadgeType && !showAddMemberButton) ? 0 : 14),
        if (showBadgeType)
          Image.asset(badgeImagePath, height: 18),
      ],
    );
  }

  Widget _buildRightSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMemberCountButton(),
        const SizedBox(width: 14),
        if (showAddMemberButton) _buildAddMemberButton(),
      ],
    );
  }

  Widget _buildMemberCountButton() {
    return SizedBox(
      width: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          backgroundColor: Colors.transparent,
          elevation: 0,
          side: const BorderSide(color: Colors.white, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              memberCountText,
              style: AppFont.size14.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.person, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMemberButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        backgroundColor: AppColor.subSlicer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Text(
        '멤버 추가',
        style: AppFont.size14.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
