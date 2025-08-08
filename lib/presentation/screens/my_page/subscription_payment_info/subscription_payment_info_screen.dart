import 'package:cherrypic/presentation/screens/my_page/subscription_payment_info/subscription_box.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';
import '../../../widgets/album/album_badge_type.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_tab_bar.dart';

class SubscriptionPaymentInfoList {
  final AlbumBadgeType badgeType;
  final String title;
  final String startDate;
  final String? nextDate;
  final String price;

  SubscriptionPaymentInfoList({
    required this.badgeType,
    required this.title,
    required this.startDate,
    this.nextDate,
    required this.price,
  });
}

class SubscriptionPaymentInfoScreen extends StatefulWidget {
  SubscriptionPaymentInfoScreen({super.key});

  @override
  State<SubscriptionPaymentInfoScreen> createState() =>
      _SubscriptionPaymentInfoScreenState();

  final List<SubscriptionPaymentInfoList> subscriptionPaymentInfoItems = [
    SubscriptionPaymentInfoList(
      badgeType: AlbumBadgeType.basic,
      title: '음식(양식, 중식, 한식, 일식) 음식 음식',
      startDate: '2025/06/23',
      price: '월 0원',
    ),
    SubscriptionPaymentInfoList(
      badgeType: AlbumBadgeType.pro,
      title: '프랑스 여행_2025. 06. 24',
      startDate: '2025/05/25',
      nextDate: '2025/08/25',
      price: '월 3,900원',
    ),
    SubscriptionPaymentInfoList(
      badgeType: AlbumBadgeType.premium,
      title: '호주 여행',
      startDate: '2025/06/28',
      nextDate: '2025/08/25',
      price: '월 5,900원',
    ),
    SubscriptionPaymentInfoList(
      badgeType: AlbumBadgeType.pro,
      title: '등반',
      startDate: '2025/07/01',
      nextDate: '2025/09/01',
      price: '월 3,900원',
    ),
  ];
}

class _SubscriptionPaymentInfoScreenState
    extends State<SubscriptionPaymentInfoScreen> {
  int subscriptionCount = 4;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTabBar(title: '구독 및 결제 정보'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: '구독',
                        style: AppFont.size18.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: ' ($subscriptionCount)',
                            style: AppFont.size14.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 26.78),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _isExpanded
                        ? widget.subscriptionPaymentInfoItems.length
                        : (widget.subscriptionPaymentInfoItems.length > 2
                              ? 2
                              : widget.subscriptionPaymentInfoItems.length),
                    itemBuilder: (context, index) {
                      final item = widget.subscriptionPaymentInfoItems[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: (_isExpanded && index == widget.subscriptionPaymentInfoItems.length - 1) ||
                              (!_isExpanded && index == 1)
                              ? 0
                              : 30,
                        ),
                        child: SubscriptionBox(
                          badgeType: item.badgeType,
                          title: item.title,
                          startDate: item.startDate,
                          nextDate: item.nextDate,
                          price: item.price,
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isExpanded ? '접기' : '전체 보기',
                          style: AppFont.size16.copyWith(
                            color: AppColor.mainRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          _isExpanded
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: AppColor.mainRed,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
