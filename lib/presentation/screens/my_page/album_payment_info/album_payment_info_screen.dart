import 'package:cherrypic/presentation/screens/my_page/album_payment_info/payment_box.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';
import '../../../widgets/album/album_badge_type.dart';
import '../../../widgets/custom_sub_app_bar.dart';

/// 구독 및 결제 정보 Model
class AlbumPaymentInfoList {
  final AlbumBadgeType badgeType;
  final String title;
  final String startDate;
  final String? nextDate;
  final String price;

  const AlbumPaymentInfoList({
    required this.badgeType,
    required this.title,
    required this.startDate,
    this.nextDate,
    required this.price,
  });
}

/// 구독 및 결제 정보 리스트
const List<AlbumPaymentInfoList> subscriptionPaymentInfoItems = [
  AlbumPaymentInfoList(
    badgeType: AlbumBadgeType.basic,
    title: '음식(양식, 중식, 한식, 일식) 음식 음식',
    startDate: '2025/06/23',
    price: '월 0원',
  ),
  AlbumPaymentInfoList(
    badgeType: AlbumBadgeType.pro,
    title: '프랑스 여행_2025. 06. 24',
    startDate: '2025/05/25',
    nextDate: '2025/08/25',
    price: '월 3,900원',
  ),
  AlbumPaymentInfoList(
    badgeType: AlbumBadgeType.premium,
    title: '호주 여행',
    startDate: '2025/06/28',
    nextDate: '2025/08/25',
    price: '월 5,900원',
  ),
  AlbumPaymentInfoList(
    badgeType: AlbumBadgeType.pro,
    title: '등반',
    startDate: '2025/07/01',
    nextDate: '2025/09/01',
    price: '월 3,900원',
  ),
];

/// 구독 및 결제 정보 화면
class AlbumPaymentInfoScreen extends StatefulWidget {
  const AlbumPaymentInfoScreen({super.key});

  @override
  State<AlbumPaymentInfoScreen> createState() =>
      _AlbumPaymentInfoScreenState();
}

class _AlbumPaymentInfoScreenState
    extends State<AlbumPaymentInfoScreen> {
  /// 전체 보기 여부
  bool _isExpanded = false;

  List<AlbumPaymentInfoList> get displayedItems => _isExpanded
      ? subscriptionPaymentInfoItems
      : subscriptionPaymentInfoItems.take(2).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '앨범 및 결제정보'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const SizedBox(height: 35),

                          /// 구독 Title + 구독 횟수
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: '앨범',
                                style: AppFont.size18.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' (${subscriptionPaymentInfoItems.length})',
                                    style: AppFont.size14.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 26.78),

                          /// 구독 및 결제 정보 리스트 띄우기
                          _buildSubscriptionList(displayedItems),

                          /// 전체 보기 or 접기
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
              )
          ),
        ],
      ),
    );
  }

  /// 앨범 및 결제 정보 리스트 띄우기 로직
  Widget _buildSubscriptionList(List<AlbumPaymentInfoList> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: _getBottomPadding(index, items.length),
          ),
          child: PaymentBox(
            badgeType: item.badgeType,
            title: item.title,
            startDate: item.startDate,
            nextDate: item.nextDate,
            price: item.price,
          ),
        );
      },
    );
  }

  /// 마지막 리스트와 아이콘 사이 여백 여부 지정
  double _getBottomPadding(int index, int length) {
    return index == length - 1 ? 0 : 30;
  }
}
