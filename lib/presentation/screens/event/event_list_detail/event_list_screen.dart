import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';
import '../../../widgets/menu_button.dart';
import 'event_list_info.dart';
import '../event_store_tab_bar.dart';

class EventListScreen extends StatelessWidget {
  final String eventImage;
  final String date;
  final String title;

  const EventListScreen({
    super.key,
    required this.eventImage,
    required this.date,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// 상단 메뉴 버튼
          MenuButton(iconType: EventStoreIconType.event, title: '행사'),

          /// backButton Bar
          EventStoreTabBar(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이벤트 상단 요약 카드
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: _buildContent(),
                  ),
                  const SizedBox(height: 34.47),

                  /// 이벤트 상세 정보
                  const EventListInfo(),

                  const SizedBox(height: 25.83),

                  /// 이벤트 마무리 멘트
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 0,
                    ).copyWith(bottom: 129),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Baseline(
                          baseline: 25,
                          baselineType: TextBaseline.alphabetic,
                          child: Image.asset(
                            'assets/images/CherryPic_logo.png',
                            width: 20,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '지금 바로 가족의 따뜻한 순간을 공유하세요!',
                            style: AppFont.size18.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 이벤트 이미지 + 제목 + 날짜
  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 17.5, 10, 17.5),
      color: Colors.white,
      width: double.infinity,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(eventImage, width: 45, height: 45),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: AppFont.size10.copyWith(color: AppColor.subGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppFont.size16.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
