import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'member_list_popup.dart';

class MemberCountButton extends StatefulWidget {
  const MemberCountButton({
    super.key,
    required this.members,
    this.offset = const Offset(-6, 40),
  });

  final List<MemberListData> members;
  final Offset offset;

  @override
  State<MemberCountButton> createState() => _MemberCountButtonState();
}

class _MemberCountButtonState extends State<MemberCountButton> {
  final LayerLink _link = LayerLink();

  void _toggle() {
    if (MemberListPopup.isShown) {
      MemberListPopup.hide();
    } else {
      MemberListPopup.show(
        context,
        _link,
        widget.members,
        offset: widget.offset,
      );
    }
  }

  @override
  void dispose() {
    MemberListPopup.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.members.length.toString();

    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(80),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Center(
                  child: Text(
                    count,
                    textAlign: TextAlign.center,
                    // 라인박스 높이로 인해 위로 붙는 현상 방지
                    strutStyle: const StrutStyle(
                      forceStrutHeight: true,
                      height: 1.0,
                      leading: 0.0,
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.person, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
