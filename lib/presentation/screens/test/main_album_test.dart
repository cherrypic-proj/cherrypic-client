import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';

import '../../widgets/custom_gauge_bar.dart';

class MainAlbumTest extends StatelessWidget {
  const MainAlbumTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: CustomGaugeBar(
            usedGB: 12,
            totalGB: 15,
          ),
        ),
      ),
    );
  }
}
