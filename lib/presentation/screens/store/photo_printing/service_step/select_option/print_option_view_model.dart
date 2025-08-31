import 'package:flutter/material.dart';
import '../../../../../../core/constants/color.dart';
import 'print_option_model.dart';

class PrintOptionViewModel extends ChangeNotifier {
  final List<PrintOptionModel> _options = [
    PrintOptionModel(
      title: '일반 인화',
      subtitle: '3×5” (89×127mm)',
      priceText: '장당 300원 X 2장 → 600원',
      priceColor: AppColor.mainRed,
      divideColor: AppColor.mainRed,
      dotColor: AppColor.mainRed,
    ),
    PrintOptionModel(
      title: '포토 인화',
      subtitle: '4×6” (102×152mm)',
      priceText: '장당 500원',
      priceColor: AppColor.mainRed,
      divideColor: AppColor.mainRed,
      dotColor: AppColor.mainRed,
    ),
    PrintOptionModel(
      title: '중형 인화',
      subtitle: '5×7” (127×178mm)',
      priceText: '장당 1000원',
      priceColor: AppColor.mainRed,
      divideColor: AppColor.mainRed,
      dotColor: AppColor.mainRed,
    ),
    PrintOptionModel(
      title: '대형 인화',
      subtitle: '8×10” (203×254mm)',
      priceText: '장당 2500원',
      priceColor: AppColor.mainRed,
      divideColor: AppColor.mainRed,
      dotColor: AppColor.mainRed,
    ),
    PrintOptionModel(
      title: '문서형 인화',
      subtitle: 'A4 (210×297mm)',
      priceText: '장당 3000원',
      priceColor: AppColor.mainRed,
      divideColor: AppColor.mainRed,
      dotColor: AppColor.mainRed,
    ),
  ];

  List<PrintOptionModel> get options => _options;

  int? _selectedIndex = 0;
  int? get selectedIndex => _selectedIndex;

  bool isSelected(int index) => _selectedIndex == index;

  void selectOption(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}