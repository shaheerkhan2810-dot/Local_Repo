import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/models/journal_entry.dart';

class JournalTile extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;

  const JournalTile({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceBright, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceBright,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  entry.moodEmoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.title?.isNotEmpty == true
                              ? entry.title!
                              : 'Untitled',
                          style: const TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppDateUtils.formatDate(entry.date),
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  if (entry.richContent.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.textPreview,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (entry.mediaUrls.isNotEmpty ||
                      entry.voiceNoteUrl != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (entry.mediaUrls.isNotEmpty) ...[
                          const Icon(Icons.image_outlined,
                              size: 12, color: AppColors.textHint),
                          const SizedBox(width: 2),
                          Text(
                            '${entry.mediaUrls.length}',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (entry.voiceNoteUrl != null)
                          const Icon(Icons.mic_none_rounded,
                              size: 12, color: AppColors.textHint),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
