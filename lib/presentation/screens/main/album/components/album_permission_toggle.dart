import 'package:cherrypic/presentation/widgets/dialogs/participant_kick_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/data/album/dto/response/participant_dto.dart';

class AlbumPermissionToggle extends StatelessWidget {
  final bool isPermissionEnabled;
  final ValueChanged<bool> onPermissionToggled;
  final bool showMemberList;
  final List<ParticipantDto>? participants;
  final bool isLoadingParticipants;
  final bool isEditable;
  final Function(ParticipantDto)? onKickMember;

  const AlbumPermissionToggle({
    super.key,
    required this.isPermissionEnabled,
    required this.onPermissionToggled,
    this.showMemberList = false,
    this.participants,
    this.isLoadingParticipants = false,
    this.isEditable = true,
    this.onKickMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (showMemberList) ...[
          const SizedBox(height: 20),
          _buildMemberListBox(context),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '멤버별 권한 부여',
              style: AppFont.size18.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.info_outline, size: 18, color: AppColor.mainRed),
          ],
        ),
        Switch(
          value: isPermissionEnabled,
          activeTrackColor: isEditable
              ? AppColor.mainRed
              : Colors.grey, // 비활성화시 회색
          onChanged: isEditable ? onPermissionToggled : null, // 비활성화시 클릭 불가
        ),
      ],
    );
  }

  Widget _buildMemberListBox(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: '멤버 검색',
              hintStyle: AppFont.size16.copyWith(color: Colors.grey.shade500),
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoadingParticipants
                ? const Center(child: CircularProgressIndicator())
                : participants == null || participants!.isEmpty
                ? Center(
                    child: Text(
                      '참가자가 없습니다',
                      style: AppFont.size14.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: participants!.length,
                    itemBuilder: (context, index) =>
                        _buildMemberListItem(context, participants![index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberListItem(
    BuildContext context,
    ParticipantDto participant,
  ) {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundImage: participant.profileImageUrl != null
                ? NetworkImage(participant.profileImageUrl!)
                : null,
            child: participant.profileImageUrl == null
                ? const Icon(Icons.person, size: 12)
                : null,
          ),
          const SizedBox(width: 10),
          Text(participant.nickname, style: AppFont.size16),
          const Spacer(),
          TextButton(
            onPressed: () {
              if (onKickMember != null) {
                _showKickConfirmDialog(context, participant);
              }
            },
            child: Text(
              '내보내기',
              style: AppFont.size14.copyWith(
                color: AppColor.mainRed,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              participant.role,
              style: AppFont.size14.copyWith(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  void _showKickConfirmDialog(
    BuildContext context,
    ParticipantDto participant,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ParticipantKickDialog(
          participant: participant,
          onConfirm: () {
            onKickMember?.call(participant);
          },
        );
      },
    );
  }
}
