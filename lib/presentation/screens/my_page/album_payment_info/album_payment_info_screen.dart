import 'package:cherrypic/presentation/screens/my_page/album_payment_info/components/payment_box.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';
import '../../../widgets/album/album_badge_type.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import 'album_payment_info_view_model.dart';
import 'components/album_badge_toggle.dart';
import 'components/album_payment_info_model.dart';

/// 구독 및 결제 정보 리스트
const List<AlbumPaymentInfoModel> albumPaymentInfoItems = [
  AlbumPaymentInfoModel(
    badgeType: AlbumBadgeType.basic,
    title: '음식(양식, 중식, 한식, 일식) 음식 음식',
    createDate: '2025/06/23',
    price: '무료',
  ),
  AlbumPaymentInfoModel(
    badgeType: AlbumBadgeType.pro,
    title: '프랑스 여행_2025. 06. 24',
    createDate: '2025/06/23',
    startDate: '2025/05/25',
    nextDate: '2025/08/25',
    price: '월 3,900원',
  ),
  AlbumPaymentInfoModel(
    badgeType: AlbumBadgeType.premium,
    title: '호주 여행',
    createDate: '2025/06/23',
    startDate: '2025/06/28',
    nextDate: '2025/08/25',
    price: '월 5,900원',
  ),
  AlbumPaymentInfoModel(
    badgeType: AlbumBadgeType.pro,
    title: '등반',
    createDate: '2025/06/23',
    startDate: '2025/07/01',
    nextDate: '2025/09/01',
    price: '월 3,900원',
  ),
  AlbumPaymentInfoModel(
    badgeType: AlbumBadgeType.premium,
    title: '호주 여행',
    createDate: '2025/06/23',
    startDate: '2025/06/28',
    nextDate: '2025/08/25',
    price: '월 5,900원',
  ),
  AlbumPaymentInfoModel(
    badgeType: AlbumBadgeType.pro,
    title: '프랑스 여행_2025. 06. 24',
    createDate: '2025/06/23',
    startDate: '2025/05/25',
    nextDate: '2025/08/25',
    price: '월 3,900원',
  ),
];

/// 구독 및 결제 정보 화면
class AlbumPaymentInfoScreen extends StatefulWidget {
  const AlbumPaymentInfoScreen({super.key});

  @override
  State<AlbumPaymentInfoScreen> createState() => _AlbumPaymentInfoScreenState();
}

class _AlbumPaymentInfoScreenState extends State<AlbumPaymentInfoScreen> {
  late final AlbumPaymentInfoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AlbumPaymentInfoViewModel();
    viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '앨범 및 결제정보'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 35),
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
                              text: ' (${viewModel.allItems.length})',
                              style: AppFont.size14.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 19),

                    AlbumBadgeToggle(viewModel: viewModel.badgeToggleViewModel),

                    const SizedBox(height: 35),

                    _buildSubscriptionList(viewModel.displayedItems),

                    if (viewModel.shouldShowToggle)
                      GestureDetector(
                        onTap: viewModel.toggleExpand,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              viewModel.isExpanded ? '접기' : '전체 보기',
                              style: AppFont.size16.copyWith(
                                color: AppColor.mainRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              viewModel.isExpanded
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
            ),
          ),
        ],
      ),
    );
  }

  /// 리스트 빌더
  Widget _buildSubscriptionList(List<AlbumPaymentInfoModel> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 30),
          child: PaymentBox(model: item),
        );
      },
    );
  }
}
