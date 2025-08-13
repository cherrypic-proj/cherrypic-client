import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/event/scalloped_background_painter.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import 'event_list_info_view_model.dart';

class EventListInfo extends StatelessWidget {
  const EventListInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = EventListInfoViewModel();

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Center(
          child: Container(
            width: 330,
            decoration: BoxDecoration(
              color: const Color(0xFFFACCCF).withOpacity(0.2),
            ),
            padding: const EdgeInsets.fromLTRB(20, 43, 20, 43),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📸 참여 방법', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                for (var i = 0; i < viewModel.participationMethods.length; i++) ...[
                  _buildNumberedText(i + 1, viewModel.participationMethods[i]),
                  if (i != viewModel.participationMethods.length - 1) const SizedBox(height: 4),
                ],
                const SizedBox(height: 24),

                const Text('🎁 이벤트 혜택', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                for (var item in viewModel.eventBenefits) ...[
                  _buildIconText(item.icon, item.text),
                ],
                const SizedBox(height: 24),

                const Text('🗓️ 이벤트 기간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('2025.07.15 ~ 2025.07.31'),
                for (var item in viewModel.eventDateNotes) ...[
                  _buildIconText(item.icon, item.text),
                ],
                const SizedBox(height: 24),

                const Text('📌 참여 유의사항', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                for (var item in viewModel.participationNotes) ...[
                  _buildIconText(item.icon, item.text),
                ],
              ],
            ),
          ),
        ),
        /// 중첩시키기
        Positioned(
          top: -20,
          child: Center(
            child: ClipRect(
              child: CustomPaint(
                painter: ScallopedBackgroundPainter(
                  color: AppColor.mainRed,
                  count: 11,
                  diameter: 50,
                ),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: Center(
                    child: Text(
                      '가족사진을 공유하고, 특별한 선물을 받아보세요!',
                      textAlign: TextAlign.center,
                      style: AppFont.size16.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 번호 있는 텍스트 출력 함수
  Widget _buildNumberedText(int index, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index. ', style: const TextStyle(fontSize: 16)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// 아이콘과 텍스트 출력 함수
  Widget _buildIconText(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$icon ', style: const TextStyle(fontSize: 16)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}