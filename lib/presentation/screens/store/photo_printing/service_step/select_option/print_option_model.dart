import 'package:flutter/material.dart';

class PrintOptionModel {
  final String title;
  final String subtitle;
  final String priceText;
  final Color priceColor;
  final Color divideColor;
  final Color dotColor;

  const PrintOptionModel({
    required this.title,
    required this.subtitle,
    required this.priceText,
    required this.priceColor,
    required this.divideColor,
    required this.dotColor,
  });
}