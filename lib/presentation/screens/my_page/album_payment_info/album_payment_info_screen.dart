import 'package:cherrypic/presentation/screens/my_page/album_payment_info/components/payment_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';
import '../../../../core/router/route_path.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import 'album_payment_info_view_model.dart';
import 'album_payment_info_model.dart';
import 'components/type_toggle.dart';

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
      appBar: const CustomSubAppBar(title: '앨범 결제정보'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    // pro/premium 토글
                    TypeToggle(
                      selected: viewModel.selectedFilter,
                      onChanged: (type) => viewModel.changeFilter(type),
                    ),

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
          child: PaymentBox(
            model: item,
            showDates: false,
            onTap: () {
              context.push(
                RoutePath.myPage_payment_info,
                extra: item,
              );
            },
          ),
        );
      },
    );
  }
}
