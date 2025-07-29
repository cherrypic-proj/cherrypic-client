import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/text/custom_labeled_text_field.dart';

class LabeledTextFieldTestScreen extends StatelessWidget {
  const LabeledTextFieldTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('텍스트필드 테스트')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomLabeledTextField(
          title: '임시 앨범 이름',
          hintText: '임시 앨범 이름을 작성해주세요. (최대 00자)',
        ),
      ),
    );
  }
}
