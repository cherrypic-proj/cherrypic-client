import 'package:flutter/material.dart';
import '../../../core/constants/color.dart';
import '../../widgets/address_box_card.dart';
import '../../widgets/custom_box_card.dart';

class BoxCardTest extends StatefulWidget {
  const BoxCardTest({super.key});

  @override
  State<BoxCardTest> createState() => _BoxCardTestState();
}

class _BoxCardTestState extends State<BoxCardTest> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = List.filled(3, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('버튼 테스트'), backgroundColor: Colors.red),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBoxCard(
                selected: isSelected[0],
                borderColor: AppColor.mainRed,
                dotColor: AppColor.mainRed,
                title: '일반인화',
                subtitle: '3×5” (89×127mm)',
                priceText: '장당 300원 X 2장 → 600원',
                priceColor: AppColor.mainRed,
                divideColor: AppColor.mainRed,
                onTap: () {
                  setState(() {
                    isSelected[0] = !isSelected[0];
                  });
                },
              ),
        
              const SizedBox(height: 16),
              CustomBoxCard(
                selected: isSelected[1],
                borderColor: AppColor.subGrey,
                dotColor: AppColor.subGrey,
                title: '일반인화',
                subtitle: '3×5” (89×127mm)',
                priceText: '장당 300원 X 2장 → 600원',
                priceColor: AppColor.mainRed,
                divideColor: AppColor.mainRed,
                onTap: () {
                  setState(() {
                    isSelected[1] = !isSelected[1];
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomBoxCard(
                selected: isSelected[2],
                borderColor: AppColor.subDarkGreen,
                dotColor: AppColor.subDarkGreen,
                priceColor: AppColor.subDarkGreen,
                title: '일반인화',
                subtitle: '3×5” (89×127mm)',
                priceText: '장당 300원 X 2장 → 600원',
                divideColor: AppColor.subDarkGreen,
                onTap: () {
                  setState(() {
                    isSelected[2] = !isSelected[2];
                  });
                },
              ),
              const SizedBox(height: 8),
              AddressBoxCard(
                isFixed: false,
                title: '집',
                label: '기본 배송지',
                receiver: '홍길동',
                phone: '010 - 1234 - 5678',
                address: '서울 동작구 상도로 369 [06978]',
              ),
              const SizedBox(height: 8),
              AddressBoxCard(
                isFixed: true,
                title: '집',
                label: '기본 배송지',
                receiver: '홍길동',
                phone: '010 - 1234 - 5678',
                address: '서울 동작구 상도로 369 [06978]',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
