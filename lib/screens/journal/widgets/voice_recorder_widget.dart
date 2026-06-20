import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final ValueChanged<String?> onRecordingComplete;

  const VoiceRecorderWidget({
    super.key,
    required this.onRecordingComplete,
  });

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _hasRecording = false;
  Duration _elapsed = Duration.zero;
  late AnimationController _pulseController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    // Placeholder implementation (requires device permissions at runtime)
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _hasRecording = true;
        widget.onRecordingComplete('local_recording.m4a');
      } else {
        _isRecording = true;
        _hasRecording = false;
        _elapsed = Duration.zero;
        widget.onRecordingComplete(null);
      }
    });
  }

  String get _timeLabel {
    final m = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isRecording
              ? AppColors.error.withAlpha(120)
              : AppColors.surfaceBright,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Record button
          GestureDetector(
            onTap: _toggleRecording,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Transform.scale(
                scale: _isRecording ? _pulse.value : 1.0,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isRecording
                        ? AppColors.error
                        : AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: _isRecording
                        ? [
                            BoxShadow(
                              color: AppColors.error.withAlpha(80),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isRecording
                      ? 'Recording...'
                      : _hasRecording
                          ? 'Recording saved'
                          : 'Tap to record voice note',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: _isRecording
                        ? AppColors.error
                        : AppColors.textSecondary,
                    fontWeight: _isRecording ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (_isRecording || _hasRecording) ...[
                  const SizedBox(height: 4),
                  Text(
                    _isRecording ? _timeLabel : 'Tap mic to re-record',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_hasRecording)
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded,
                  color: AppColors.accentGold),
              onPressed: () {
                // Play recording placeholder
              },
            ),
        ],
      ),
    );
  }
}
