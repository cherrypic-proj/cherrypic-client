import 'package:cherrypic/presentation/screens/my_page/subscription_payment_info/subscription_box.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/font.dart';
import '../../../widgets/album/album_badge_type.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_tab_bar.dart';

class SubscriptionPaymentInfoList {
  final AlbumBadgeType badgeType;

  SubscriptionPaymentInfoList({required this.badgeType});
}

class SubscriptionPaymentInfoScreen extends StatefulWidget {
  SubscriptionPaymentInfoScreen({super.key});

  @override
  State<SubscriptionPaymentInfoScreen> createState() =>
      _SubscriptionPaymentInfoScreenState();

  final List<SubscriptionPaymentInfoList> subscriptionPaymentInfoItems = [
    SubscriptionPaymentInfoList(badgeType: AlbumBadgeType.basic),
    SubscriptionPaymentInfoList(badgeType: AlbumBadgeType.pro),
    SubscriptionPaymentInfoList(badgeType: AlbumBadgeType.premium),
  ];
}

class _SubscriptionPaymentInfoScreenState
    extends State<SubscriptionPaymentInfoScreen> {
  int subscriptionCount = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomTabBar(title: '구독 및 결제 정보'),
          Expanded(
            child: Padding(
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.subscriptionPaymentInfoItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.subscriptionPaymentInfoItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SubscriptionBox(badgeType: item.badgeType),
                        );
                      },
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
