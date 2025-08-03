import 'dart:ui';
import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomGaugeBar extends StatelessWidget {
  final double usedGB;
  final double totalGB;

  const CustomGaugeBar({
    required this.usedGB,
    required this.totalGB,
    super.key,
  })  : assert(usedGB >= 0 && usedGB <= totalGB);

  @override
  Widget build(BuildContext context) {
    final double ratio = (usedGB / totalGB).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.subSlicer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 6,
                          percent: ratio,
                          barRadius: const Radius.circular(999),
                          backgroundColor: AppColor.subLightGrey,
                          progressColor: AppColor.highlightBlue,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: usedGB.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColor.highlightBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '/${totalGB.toStringAsFixed(0)} GB',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
