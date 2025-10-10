import 'package:cherrypic/presentation/widgets/dialogs/dialog_action_button.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/data/album/dto/response/participant_dto.dart';

class ParticipantKickDialog extends StatelessWidget {
  final ParticipantDto participant;
  final VoidCallback onConfirm;

  const ParticipantKickDialog({
    super.key,
    required this.participant,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 340,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '내보내기',
                      style: AppFont.size18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColor.mainRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/door_open.png',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
                IconButton(
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 안내 문구
            Text.rich(
              TextSpan(
                style: AppFont.size16.copyWith(
                  height: 1.5,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: participant.nickname,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' 님을 앨범에서 내보내시겠습니까?'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DialogActionButton(
                  text: '취소',
                  isConfirm: false,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                DialogActionButton(
                  text: '내보내기',
                  isConfirm: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
