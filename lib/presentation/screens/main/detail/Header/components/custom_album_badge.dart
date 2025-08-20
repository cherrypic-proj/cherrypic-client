import 'dart:ui';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/components/member_count_button.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/font.dart';
import 'member_list_popup.dart';

final List<MemberListData> _dummyMembers = [
  MemberListData('김나은', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('김지현', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('나용준', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('최현태', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('한금준', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('황상환', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('김나은', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('김지현', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('나용준', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('최현태', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('한금준', const AssetImage('assets/images/sample_photo.png')),
  MemberListData('황상환', const AssetImage('assets/images/sample_photo.png')),
];

class CustomAlbumBadge extends StatelessWidget {
  final String userName;
  final String memberCountText;
  final bool showBadgeType;
  final bool showAddMemberButton;

  const CustomAlbumBadge({
    super.key,
    required this.userName,
    required this.memberCountText,
    required this.showBadgeType,
    required this.showAddMemberButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: double.infinity,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(130, 0, 0, 0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLeftSection(),
                  const Spacer(),
                  _buildRightSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSection() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: (!showBadgeType && !showAddMemberButton) ? 18 : 0,
          ),
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
    return MemberCountButton(members: _dummyMembers);
  }

  Widget _buildAddMemberButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        backgroundColor: AppColor.subSlicer,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
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
