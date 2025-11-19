import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/info/payment_info_model.dart';
import 'package:cherrypic/presentation/screens/my_page/album_payment_info/info/payment_info_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/custom_sub_app_bar.dart';
import '../../../../widgets/toggle/payment_box.dart';
import '../../../../widgets/toggle/payment_history_box.dart';
import '../album_payment_info_model.dart';


class PaymentInfoScreen extends StatelessWidget {
  final AlbumPaymentInfoModel item;
  final PaymentInfoViewModel viewModel;
  final int albumId;

  const PaymentInfoScreen({super.key, required this.item, required this.viewModel, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: ''),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaymentBox(model: item, isFlatStyle: true, showDates: true),

            const SizedBox(height: 52.73),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '결제 내역',
                      style: AppFont.size16.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                    ),
                  ),

                  const SizedBox(height: 28.27),

                  // 결제 내역
                  _buildPaymentHistoryList(viewModel.payments),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 리스트 빌더
  Widget _buildPaymentHistoryList(List<PaymentInfoModel> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return PaymentHistoryBox(model: item);
      },
    );
  }
}
