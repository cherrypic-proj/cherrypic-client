import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';

class EventCoverCard extends StatelessWidget {
  final String title;
  final int photoCount;
  final String imageUrl;

  const EventCoverCard({
    super.key,
    required this.title,
    required this.photoCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 124,
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppFont.size18.copyWith(
                              color: Colors.white,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 2),
                          Text(
                            '$photoCount장',
                            style: AppFont.size12.copyWith(
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
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
