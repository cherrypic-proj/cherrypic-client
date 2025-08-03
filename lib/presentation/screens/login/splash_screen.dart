import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/login/login_screen.dart';
import 'package:cherrypic/presentation/screens/main/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3), () async {
        final hasHistory = await hasSocialLoginHistory();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => hasHistory ? const MainScreen() : const LoginScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
    );
  }

  // 소셜 로그인 기록 여부
  Future<bool> hasSocialLoginHistory() async {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: AppColor.mainPink,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/CherryPic_logo.png',
                  width: 130,
                  height: 198,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/CherryPic_title.png',
                  width: 223,
                  height: 71,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
