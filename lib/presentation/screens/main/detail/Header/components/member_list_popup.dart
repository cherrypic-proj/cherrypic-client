import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';

/// 멤버 항목 데이터
class MemberListData {
  final String name;
  final ImageProvider image;
  const MemberListData(this.name, this.image);
}

/// 버튼 기준 오버레이 팝업
class MemberListPopup {
  static OverlayEntry? _barrier;
  static OverlayEntry? _popup;
  static bool get isShown => _popup != null;

  static void show(
    BuildContext context,
    LayerLink link,
    List<MemberListData> members, {
    Offset offset = const Offset(-6, 40),
  }) {
    if (isShown) return;
    final overlay = Overlay.of(context);
    _barrier = OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: hide,
        behavior: HitTestBehavior.translucent,
        child: const SizedBox.expand(),
      ),
    );
    _popup = OverlayEntry(
      builder: (_) => CompositedTransformFollower(
        link: link,
        showWhenUnlinked: false,
        offset: offset,
        child: Align(
          alignment: Alignment.topLeft,
          child: _MemberListCard(members: members),
        ),
      ),
    );
    overlay.insertAll([_barrier!, _popup!]);
  }

  static void hide() {
    _popup?.remove();
    _barrier?.remove();
    _popup = null;
    _barrier = null;
  }

  static void dispose() => hide();
}

class _MemberListCard extends StatelessWidget {
  const _MemberListCard({required this.members});
  final List<MemberListData> members;

  @override
  Widget build(BuildContext context) {
    final scrollbarTheme = ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(3),
      radius: const Radius.circular(8),
      thumbColor: WidgetStateProperty.all(Colors.white70),
    );

    return SizedBox(
      width: 130,
      height: 270,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(160),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(85),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ScrollbarTheme(
            data: scrollbarTheme,
            child: Scrollbar(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final m = members[index];
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: m.image,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          m.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFont.size14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
