import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../album_detail_view_model.dart';

class AlbumUploadOverlay extends StatelessWidget {
  const AlbumUploadOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumDetailViewModel>(
      builder: (context, vm, _) {
        if (!vm.isUploading) return const SizedBox.shrink();

        return Positioned.fill(
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(40),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        vm.uploadProgress,
                        style: AppFont.size16,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
