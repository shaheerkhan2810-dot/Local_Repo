import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class ApexLoading extends StatelessWidget {
  const ApexLoading({super.key});

  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    if (_entry != null) return;
    _entry = OverlayEntry(
      builder: (_) => const ApexLoading(),
    );
    Overlay.of(context).insert(_entry!);
  }

  static void hide(BuildContext context) {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black.withAlpha(180),
          dismissible: false,
        ),
        const Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.accentGold),
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }
}
