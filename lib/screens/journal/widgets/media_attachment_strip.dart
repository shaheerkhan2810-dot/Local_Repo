import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class MediaAttachmentStrip extends StatefulWidget {
  final List<String> existingUrls;
  final ValueChanged<List<XFile>> onFilesChanged;

  const MediaAttachmentStrip({
    super.key,
    this.existingUrls = const [],
    required this.onFilesChanged,
  });

  @override
  State<MediaAttachmentStrip> createState() => _MediaAttachmentStripState();
}

class _MediaAttachmentStripState extends State<MediaAttachmentStrip> {
  final _picker = ImagePicker();
  final List<XFile> _localFiles = [];

  Future<void> _pickImage() async {
    final files = await _picker.pickMultiImage(imageQuality: 80);
    if (files.isNotEmpty) {
      setState(() => _localFiles.addAll(files));
      widget.onFilesChanged(_localFiles);
    }
  }

  Future<void> _pickCamera() async {
    final file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (file != null) {
      setState(() => _localFiles.add(file));
      widget.onFilesChanged(_localFiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.existingUrls.length + _localFiles.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ATTACHMENTS',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.accentGold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add photo button
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 72,
                  height: 72,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.surfaceBright, width: 1),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: AppColors.accentGold, size: 24),
                      SizedBox(height: 2),
                      Text(
                        'Photo',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Camera button
              GestureDetector(
                onTap: _pickCamera,
                child: Container(
                  width: 72,
                  height: 72,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.surfaceBright, width: 1),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          color: AppColors.accentGold, size: 24),
                      SizedBox(height: 2),
                      Text(
                        'Camera',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Local files
              ..._localFiles.map(
                (f) => Stack(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: AppColors.surfaceBright,
                          child: const Icon(Icons.image_outlined,
                              color: AppColors.textHint),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _localFiles.remove(f));
                          widget.onFilesChanged(_localFiles);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (total > 0) ...[
          const SizedBox(height: 4),
          Text(
            '$total attachment${total > 1 ? 's' : ''}',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
        ],
      ],
    );
  }
}
