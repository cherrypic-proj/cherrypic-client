import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/main/album/edit/album_edit_view_model.dart';

class AlbumPermissionToggle extends StatelessWidget {
  final bool isPermissionEnabled;
  final ValueChanged<bool> onPermissionToggled;
  final bool showMemberList;

  // --- 멤버 리스트 관련 파라미터 (선택적) ---
  final List<Member>? members;
  final TextEditingController? searchController;
  final Function(Member, String)? onUpdateRole;
  final Function(Member)? onKickMember;

  const AlbumPermissionToggle({
    super.key,
    required this.isPermissionEnabled,
    required this.onPermissionToggled,
    this.showMemberList = false, // 기본값 false
    // 멤버 리스트를 보여줄 때만 필요한 파라미터들
    this.members,
    this.searchController,
    this.onUpdateRole,
    this.onKickMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (isPermissionEnabled && showMemberList) ...[
          const SizedBox(height: 20),
          _buildMemberListBox(),
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
          activeThumbColor: AppColor.mainRed,
          onChanged: onPermissionToggled,
        ),
      ],
    );
  }

  Widget _buildMemberListBox() {
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
            controller: searchController,
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
            child: ListView.separated(
              itemCount: members!.length,
              itemBuilder: (context, index) =>
                  _buildMemberListItem(members![index]),
              separatorBuilder: (context, index) => const SizedBox(height: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberListItem(Member member) {
    const roles = ['방장', '일반회원', '읽기 전용'];
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundImage: NetworkImage(member.profileImageUrl),
          ),
          const SizedBox(width: 10),
          Text(member.name, style: AppFont.size16),
          const Spacer(),
          TextButton(
            onPressed: () => onKickMember!(member),
            child: Text(
              '내보내기',
              style: AppFont.size14.copyWith(
                color: AppColor.mainRed,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: member.role,
            underline: const SizedBox.shrink(),
            isDense: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.shade700,
              size: 20,
            ),
            style: AppFont.size14.copyWith(color: Colors.grey.shade700),
            items: roles
                .map(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: AppFont.size14),
                  ),
                )
                .toList(),
            onChanged: (String? newValue) {
              if (newValue != null) onUpdateRole!(member, newValue);
            },
          ),
        ],
      ),
    );
  }
}
