import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';

class CopingToolsPanel extends StatefulWidget {
  const CopingToolsPanel({super.key});

  @override
  State<CopingToolsPanel> createState() => _CopingToolsPanelState();
}

class _CopingToolsPanelState extends State<CopingToolsPanel> {
  bool _expanded = false;

  void _showToolDialog(
      BuildContext context, Map<String, String> tool) {
    final id = tool['id'] ?? '';
    switch (id) {
      case 'breathe':
        showDialog(
          context: context,
          builder: (_) => const _BoxBreathingDialog(),
        );
        break;
      case 'grounding':
        showDialog(
          context: context,
          builder: (_) => const _GroundingDialog(),
        );
        break;
      case 'cold_shower':
        showDialog(
          context: context,
          builder: (_) => const _ColdShowerDialog(),
        );
        break;
      default:
        _showSimpleDialog(context, tool);
    }
  }

  void _showSimpleDialog(BuildContext context, Map<String, String> tool) {
    final descriptions = {
      'read': 'Pick up a book — even 5 pages can shift your state. '
          'Reading engages a different part of your brain and breaks the urge cycle.',
      'call': 'Call a friend, family member, or accountability partner. '
          'Connection breaks isolation — one of the biggest urge triggers.',
      'exercise': 'Do 20 push-ups, a sprint, or any movement. '
          'Physical exertion burns the restless energy driving the urge.',
      'meditate': 'Close your eyes. Breathe slowly for 5 minutes. '
          'Observe the urge like a wave — it rises and falls without you acting on it.',
      'journal': 'Write what you\'re feeling right now. '
          'Externalizing thoughts reduces their power over you.',
    };
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '${tool['emoji']} ${tool['label']}',
          style: const TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          descriptions[tool['id']] ??
              'Use this technique to overcome the urge. '
                  'You are stronger than any temporary feeling.',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Got it',
              style: TextStyle(color: AppColors.accentGold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: ExpansionTile(
        initiallyExpanded: _expanded,
        onExpansionChanged: (v) => setState(() => _expanded = v),
        title: const Text(
          '🛡️ COPING TOOLS',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 1,
          ),
        ),
        iconColor: AppColors.accentGold,
        collapsedIconColor: AppColors.textSecondary,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.copingTools.map((tool) {
                return GestureDetector(
                  onTap: () => _showToolDialog(context, tool),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.surfaceBright, width: 0.5),
                    ),
                    child: Text(
                      '${tool['emoji']} ${tool['label']}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxBreathingDialog extends StatefulWidget {
  const _BoxBreathingDialog();

  @override
  State<_BoxBreathingDialog> createState() => _BoxBreathingDialogState();
}

class _BoxBreathingDialogState extends State<_BoxBreathingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const List<String> _phases = ['Inhale', 'Hold', 'Exhale', 'Hold'];
  int _phaseIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _phaseIndex = (_phaseIndex + 1) % _phases.length);
        if (_phaseIndex % 2 == 0) {
          _controller.reverse();
        } else {
          _controller.forward(from: _controller.value);
        }
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _phaseIndex = (_phaseIndex + 1) % _phases.length);
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        '🌬️ Box Breathing',
        style: TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (_, __) => Container(
              width: 100 * _animation.value,
              height: 100 * _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withAlpha(80),
                border: Border.all(
                    color: AppColors.primaryGreenBright, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _phases[_phaseIndex],
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.accentGold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '4 seconds each phase',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done',
              style: TextStyle(color: AppColors.accentGold)),
        ),
      ],
    );
  }
}

class _GroundingDialog extends StatefulWidget {
  const _GroundingDialog();

  @override
  State<_GroundingDialog> createState() => _GroundingDialogState();
}

class _GroundingDialogState extends State<_GroundingDialog> {
  int _step = 0;
  static const List<Map<String, String>> _steps = [
    {'count': '5', 'sense': 'things you can SEE', 'emoji': '👁️'},
    {'count': '4', 'sense': 'things you can TOUCH', 'emoji': '✋'},
    {'count': '3', 'sense': 'things you can HEAR', 'emoji': '👂'},
    {'count': '2', 'sense': 'things you can SMELL', 'emoji': '👃'},
    {'count': '1', 'sense': 'thing you can TASTE', 'emoji': '👅'},
  ];

  @override
  Widget build(BuildContext context) {
    final current = _steps[_step];
    return AlertDialog(
      backgroundColor: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        '🌿 5-4-3-2-1 Grounding',
        style: TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(current['emoji']!,
              style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'Name ${current['count']}',
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.accentGold,
            ),
          ),
          Text(
            current['sense']!,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Step ${_step + 1} of ${_steps.length}',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
      actions: [
        if (_step > 0)
          TextButton(
            onPressed: () => setState(() => _step--),
            child: const Text('Back',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
        if (_step < _steps.length - 1)
          ElevatedButton(
            onPressed: () => setState(() => _step++),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen, elevation: 0),
            child: const Text('Next',
                style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          )
        else
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done ✓',
                style: TextStyle(color: AppColors.accentGold)),
          ),
      ],
    );
  }
}

class _ColdShowerDialog extends StatefulWidget {
  const _ColdShowerDialog();

  @override
  State<_ColdShowerDialog> createState() => _ColdShowerDialogState();
}

class _ColdShowerDialogState extends State<_ColdShowerDialog> {
  static const int _totalSeconds = 120;
  int _secondsLeft = _totalSeconds;
  bool _running = false;

  @override
  void dispose() {
    super.dispose();
  }

  String _format(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        '🚿 Cold Shower Timer',
        style: TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '2-minute cold shower. Kills the urge instantly.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _format(_secondsLeft),
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppColors.info,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (!_running) {
                setState(() => _running = true);
                _tick(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              _running ? 'Running...' : 'Start Timer',
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  void _tick(BuildContext ctx) {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft > 0 && _running) {
        _tick(ctx);
      }
    });
  }
}
