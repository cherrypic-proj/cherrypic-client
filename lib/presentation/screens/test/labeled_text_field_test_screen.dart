import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/text/custom_labeled_text_field.dart';
import 'package:cherrypic/presentation/widgets/text/horizontal_labeled_text_field.dart';
import 'package:cherrypic/presentation/widgets/menu_button.dart';

class LabeledTextFieldTestScreen extends StatelessWidget {
  const LabeledTextFieldTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('텍스트필드 테스트')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MenuButton(
            iconPath: 'assets/images/menu_icon_1.png',
            title: '스토어',
          ),
          const SizedBox(height: 8),
          const MenuButton(
            iconPath: 'assets/images/menu_icon_2.png',
            title: '행사',
          ),
          const SizedBox(height: 32),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomLabeledTextField(
                      title: '임시 앨범 이름',
                      hintText: '임시 앨범 이름을 작성해주세요. (최대 00자)',
                    ),
                    SizedBox(height: 32),
                    HorizontalLabeledTextField(
                      title: '배송지명',
                      hintText: '배송지명을 입력하세요',
                    ),
                    SizedBox(height: 24),
                    HorizontalLabeledTextField(
                      title: '수령인',
                      hintText: '수령인을 입력하세요',
                    ),
                    SizedBox(height: 24),
                    HorizontalLabeledTextField(
                      title: '연락처',
                      hintText: '000-0000-0000',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
