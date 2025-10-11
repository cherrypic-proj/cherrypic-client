
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';
import '../../../../core/router/route_path.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import '../../../widgets/toggle/payment_box.dart';
import '../../../widgets/toggle/type_toggle.dart';
import 'album_payment_info_view_model.dart';
import 'album_payment_info_model.dart';


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
    final filteredItems = viewModel.filteredItems;

    return Scaffold(
      appBar: const CustomSubAppBar(title: '앨범 결제정보'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 28),

                      // pro/premium 토글
                      TypeToggle(
                        selected: viewModel.selectedFilter,
                        onChanged: (type) => viewModel.onToggleType(type),
                      ),

                      const SizedBox(height: 35),

                      _buildSubscriptionList(filteredItems),

                      if (viewModel.shouldShowToggle)
                        GestureDetector(
                          onTap: viewModel.toggleExpansion,
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
          ),
        ],
      ),
    );
  }

  /// 리스트 빌더
  Widget _buildSubscriptionList(List<AlbumPaymentInfoModel> items) {
    // 항목이 없을 경우 처리
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Text(
          '결제 정보가 없습니다.',
          style: AppFont.size16.copyWith(color: Colors.grey),
        ),
      );
    }

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
