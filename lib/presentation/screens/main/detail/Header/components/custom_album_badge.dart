import 'dart:ui';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/components/invitation_link_dialog.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/components/member_count_button.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/font.dart';
import 'member_list_popup.dart';

class CustomAlbumBadge extends StatelessWidget {
  final int albumId; // 추가
  final String userName;
  final String memberCountText;
  final bool showBadgeType;
  final bool showAddMemberButton;
  final List<MemberListData>? members;

  const CustomAlbumBadge({
    super.key,
    required this.albumId, // 추가
    required this.userName,
    required this.memberCountText,
    required this.showBadgeType,
    required this.showAddMemberButton,
    this.members,
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
                  _buildRightSection(context), // context 전달
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

  Widget _buildRightSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMemberCountButton(),
        const SizedBox(width: 14),
        if (showAddMemberButton) _buildAddMemberButton(context),
      ],
    );
  }

  Widget _buildMemberCountButton() {
    return MemberCountButton(members: members ?? []);
  }

  Widget _buildAddMemberButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onAddMemberPressed(context),
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

  Future<void> _onAddMemberPressed(BuildContext context) async {
    try {
      // 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true, // 추가
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // API 호출
      final repository = AlbumRepository();
      final response = await repository.createInvitationLink(albumId);

      // 로딩 닫기
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // 초대 링크 다이얼로그 표시
      if (context.mounted) {
        showDialog(
          context: context,
          useRootNavigator: true,
          barrierDismissible: true,
          builder: (dialogContext) =>
              InvitationLinkDialog(invitationLink: response.invitationLink),
        );
      }
    } catch (e) {
      // 로딩 닫기
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // 에러 표시
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('초대 링크 생성 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
