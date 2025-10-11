import 'package:cherrypic/presentation/screens/my_page/album_management/album_management_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/font.dart';
import '../../../../core/router/route_path.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import '../../../widgets/toggle/badge_toggle.dart';
import '../../../widgets/toggle/payment_box.dart';
import '../../../widgets/toggle/type_toggle.dart';
import '../album_payment_info/album_payment_info_model.dart';

class AlbumManagementScreen extends StatefulWidget {
  const AlbumManagementScreen({super.key});

  @override
  State<AlbumManagementScreen> createState() => _AlbumManagementScreenState();
}

class _AlbumManagementScreenState extends State<AlbumManagementScreen> {
  late final AlbumManagementViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AlbumManagementViewModel();
    viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '앨범 관리'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 28),

          TypeToggle(
            selected: viewModel.toggleTypeForSelectedStatus,
            onChanged: viewModel.onToggleTypeChanged,
            mode: ToggleMode.manage,
          ),

          const SizedBox(height: 28),

          BadgeToggle(
            selected: viewModel.selectedBadge,
            availableBadges: viewModel.availableBadges,
            onChanged: viewModel.changeBadge,
          ),

          const SizedBox(height: 35),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    _buildSubscriptionList(viewModel.displayedItems),

                    if (viewModel.displayedItems.length > 3)
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
              final path = '${RoutePath.myPage_payment_info}?albumId=${item.albumId}';

              context.push(
                path,
                extra: item,
              );
            },
          ),
        );
      },
    );
  }
}