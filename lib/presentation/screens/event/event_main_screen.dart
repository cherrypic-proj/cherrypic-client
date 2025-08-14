import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/font.dart';
import '../../../core/router/route_path.dart';
import '../../widgets/menu_button.dart';
import 'event_main/event_card.dart';
import 'event_main/event_list.dart';

/// 메인 이벤트 카드 배너 데이터
class _EventCardData {
  final String title;
  final String imagePath;
  final Color backgroundColor;

  const _EventCardData({
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
  });
}

/// 공지 사항 데이터
class EventItem {
  final String eventImage;
  final String date;
  final String title;

  const EventItem({
    required this.eventImage,
    required this.date,
    required this.title,
  });
}

/// 공지 사항 리스트
const List<EventItem> eventItems = [
  EventItem(
    eventImage: 'assets/images/subscription_in.png',
    date: '2025.08.04',
    title: '서비스 점검 안내',
  ),
  EventItem(
    eventImage: 'assets/images/subscription_out.png',
    date: '2025.07.20',
    title: '신규 기능 업데이트',
  ),
  EventItem(
    eventImage: 'assets/images/subscription_in.png',
    date: '2025.07.01',
    title: '이용약관 변경 안내',
  ),
];

class EventMainScreen extends StatefulWidget {
  const EventMainScreen({super.key});

  @override
  State<EventMainScreen> createState() => _EventMainScreenState();
}

class _EventMainScreenState extends State<EventMainScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  /// 메인 이벤트 카드 배너 List
  final List<_EventCardData> _pageCards = [
    _EventCardData(
      title: '메인 이벤트 1',
      imagePath: 'assets/images/test_example.png',
      backgroundColor: Color(0xFFFFEDC4),
    ),
    _EventCardData(
      title: '메인 이벤트 2',
      imagePath: 'assets/images/test_example.png',
      backgroundColor: Color(0xFFC4D2FF),
    ),
    _EventCardData(
      title: '메인 이벤트 3',
      imagePath: 'assets/images/test_example.png',
      backgroundColor: AppColor.mainRed,
    ),
    _EventCardData(
      title: '메인 이벤트 4',
      imagePath: 'assets/images/test_example.png',
      backgroundColor: AppColor.subDarkGreen,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// 행사 menu_button
          MenuButton(iconType: EventStoreIconType.event, title: '행사'),

          const SizedBox(height: 44.5),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// 메인 이벤트 카드 배너
                  SizedBox(
                    height: 160,
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _pageCards.length,
                      itemBuilder: (context, index) {
                        final card = _pageCards[index];
                        return EventCard(
                          title: card.title,
                          imagePath: card.imagePath,
                          backgroundColor: card.backgroundColor,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20.5),

                  /// 페이지네이션
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pageCards.length, (index) {
                      final isActive = _currentPage == index;
                      return Container(
                        width: isActive ? 12 : 8,
                        height: isActive ? 12 : 8,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? AppColor.mainRed
                              : AppColor.mainLightRed,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 84.33),

                  /// 행사 Title
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '행사',
                        style: AppFont.size20.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 7.67),

                  /// 행사 List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: eventItems.map((item) {
                        return EventList(
                          eventImage: item.eventImage,
                          date: item.date,
                          title: item.title,
                          onTap: () {
                            context.push(
                              '${RoutePath.eventList}?date=${Uri.encodeComponent(item.date)}&title=${Uri.encodeComponent(item.title)}&image=${Uri.encodeComponent(item.eventImage)}',
                            );
                          },
                        );
                      }).toList(),
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
}
