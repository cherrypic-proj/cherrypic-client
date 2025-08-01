import 'package:cherrypic/presentation/screens/main/ad_banner_placeholder.dart';
import 'package:cherrypic/presentation/screens/main/album_section.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: const [
            SizedBox(height: 16),
            AdBannerPlaceholder(),
            Expanded(child: AlbumSection()),
          ],
        ),
      ),
    );
  }
}
