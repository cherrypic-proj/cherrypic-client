import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_path.dart';

Future<void> showMiniAddMenu(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'close',
    barrierColor: Colors.black26,
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, _, __) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Material(
              color: Colors.white,
              elevation: 8,
              child: SizedBox(
                width: 300,
                height: 323,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 상단 빨간 바
                    Container(
                      height: 53,
                      decoration: BoxDecoration(
                        color: AppColor.mainRed,
                        borderRadius: const BorderRadius.vertical(),
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            iconSize: 35,
                            splashRadius: 25,
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),

                    // 임시 앨범 버튼
                    const SizedBox(height: 46),
                    Center(
                      child: SizedBox(
                        width: 88,
                        height: 43,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColor.mainRed, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            // TODO: 임시 앨범 액션
                          },
                          child: Text(
                            '임시 앨범',
                            style: AppFont.size16.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // 스토어 / 행사
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CircleMenuButton(
                          assetPath: 'assets/images/menu_icon_2.png',
                          label: '스토어',
                        ),
                        const SizedBox(width: 60),
                        _CircleMenuButton(
                          assetPath: 'assets/images/menu_icon_1.png',
                          label: '행사',
                          onTap: () {
                            // 다이얼로그 닫은 후, 이동
                            Navigator.of(context).pop();
                            context.push(RoutePath.event);
                          },
                        ),
                      ],
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _CircleMenuButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback? onTap;

  const _CircleMenuButton({
    super.key,
    required this.assetPath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              color: AppColor.mainRed,
              shape: BoxShape.circle,
            ),
            child: Center(child: Image.asset(assetPath, width: 20, height: 20)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppFont.size14.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
