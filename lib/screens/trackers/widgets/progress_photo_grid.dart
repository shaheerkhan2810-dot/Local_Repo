import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/tracker_entry.dart';

class ProgressPhotoGrid extends StatelessWidget {
  final List<TrackerEntry> entries;

  const ProgressPhotoGrid({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final photos = entries
        .where((e) => e.mediaUrls.isNotEmpty)
        .expand((e) => e.mediaUrls.map((url) => (url: url, date: e.date)))
        .toList();

    if (photos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📷', style: TextStyle(fontSize: 40)),
            SizedBox(height: 12),
            Text(
              'No progress photos yet',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Add photos when logging entries',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final item = photos[index];
        return GestureDetector(
          onTap: () => _showFullscreen(context, item.url),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.url,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textHint),
                    ),
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.broken_image_outlined,
                    color: AppColors.textHint, size: 24),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFullscreen(BuildContext context, String url) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.of(ctx).pop(),
        child: Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: AppColors.textHint),
            ),
          ),
        ),
      ),
    );
  }
}
