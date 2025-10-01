import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class InvitationLinkDialog extends StatelessWidget {
  final String invitationLink;

  const InvitationLinkDialog({super.key, required this.invitationLink});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 (제목 + 닫기 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '멤버 추가 ',
                      style: AppFont.size18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/profile_icon.png',
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 20, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 설명 텍스트
            Text(
              '링크를 공유하여 멤버를 추가하세요',
              style: AppFont.size14.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // 링크 텍스트
            Text(
              invitationLink,
              style: AppFont.size14.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),

            // 유지 시간 안내
            Text(
              '*해당 링크는 30분간 유지됩니다',
              style: AppFont.size12.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 25),

            // 버튼들 (가운데 정렬)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 링크 복사 버튼
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: invitationLink),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('링크가 복사되었습니다'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Image.asset(
                    'assets/images/link_copy.png',
                    width: 95,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 10),

                // 링크 공유 버튼
                Builder(
                  builder: (btnContext) {
                    return GestureDetector(
                      onTap: () async {
                        final box = btnContext.findRenderObject() as RenderBox?;
                        final position = box != null
                            ? box.localToGlobal(Offset.zero) & box.size
                            : null;

                        await Share.share(
                          invitationLink,
                          subject: '앨범 초대',
                          sharePositionOrigin: position,
                        );
                      },
                      child: Image.asset(
                        'assets/images/link_share.png',
                        width: 95,
                        height: 30,
                      ),
                    );
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
