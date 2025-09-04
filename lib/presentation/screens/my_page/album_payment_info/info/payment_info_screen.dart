import 'package:flutter/material.dart';

import '../../../../widgets/custom_sub_app_bar.dart';
import '../album_payment_info_model.dart';
import '../components/payment_box.dart';

class PaymentInfoScreen extends StatelessWidget {
  final AlbumPaymentInfoModel item;

  const PaymentInfoScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: ''),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaymentBox(model: item, isFlatStyle: true, showDates: true),
          ],
        ),
      ),
    );
  }
}
