import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/routine_block.dart';
import 'package:apexforge/providers/routine_provider.dart';
import 'package:apexforge/widgets/apex_button.dart';
import 'package:apexforge/widgets/apex_empty_state.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';

class RoutineBuilderScreen extends ConsumerStatefulWidget {
  const RoutineBuilderScreen({super.key});

  @override
  ConsumerState<RoutineBuilderScreen> createState() =>
      _RoutineBuilderScreenState();
}

class _RoutineBuilderScreenState extends ConsumerState<RoutineBuilderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _startRoutine(String type) async {
    ApexSnackbar.show(
      context,
      '${type == 'morning' ? '🌅' : '🌙'} ${type.capitalize()} routine started!',
    );
  }

  void _showAddBlockSheet(String routineType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddBlockSheet(
        routineType: routineType,
        onAdd: (block) async {
          await ref.read(routineNotifierProvider.notifier).addBlock(block);
        },
      ),
    );
  }

  Future<void> _reorder(List<RoutineBlock> blocks, int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final item = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, item);
    final reordered = blocks.asMap().entries.map((e) {
      return RoutineBlock(
        id: e.value.id,
        routineType: e.value.routineType,
        title: e.value.title,
        description: e.value.description,
        durationMinutes: e.value.durationMinutes,
        iconEmoji: e.value.iconEmoji,
        sortOrder: e.key,
        isActive: e.value.isActive,
      );
    }).toList();
    await ref.read(routineNotifierProvider.notifier).reorderBlocks(reordered);
  }

  @override
  Widget build(BuildContext context) {
    final morningAsync = ref.watch(morningRoutineProvider);
    final nightAsync = ref.watch(nightRoutineProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'ROUTINE',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accentGold,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accentGold,
          labelStyle: const TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: '🌅 Morning'),
            Tab(text: '🌙 Night'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final type =
              _tabController.index == 0 ? 'morning' : 'night';
          _showAddBlockSheet(type);
        },
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.add_rounded),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Morning tab
          morningAsync.when(
            data: (blocks) => _RoutineTabView(
              blocks: blocks,
              routineType: 'morning',
              onStartRoutine: () => _startRoutine('morning'),
              onReorder: (o, n) => _reorder(List.from(blocks), o, n),
              onDelete: (id) =>
                  ref.read(routineNotifierProvider.notifier).removeBlock(id),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            ),
            error: (_, __) => const Center(
              child: Text('Error', style: TextStyle(color: AppColors.error)),
            ),
          ),
          // Night tab
          nightAsync.when(
            data: (blocks) => _RoutineTabView(
              blocks: blocks,
              routineType: 'night',
              onStartRoutine: () => _startRoutine('night'),
              onReorder: (o, n) => _reorder(List.from(blocks), o, n),
              onDelete: (id) =>
                  ref.read(routineNotifierProvider.notifier).removeBlock(id),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            ),
            error: (_, __) => const Center(
              child: Text('Error', style: TextStyle(color: AppColors.error)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineTabView extends StatelessWidget {
  final List<RoutineBlock> blocks;
  final String routineType;
  final VoidCallback onStartRoutine;
  final Function(int, int) onReorder;
  final Function(String) onDelete;

  const _RoutineTabView({
    required this.blocks,
    required this.routineType,
    required this.onStartRoutine,
    required this.onReorder,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ApexButton(
            label: 'Start ${routineType.capitalize()} Routine',
            onPressed: blocks.isEmpty ? null : onStartRoutine,
            icon: Icons.play_arrow_rounded,
          ),
        ),
        const SizedBox(height: 12),
        if (blocks.isEmpty)
          Expanded(
            child: ApexEmptyState(
              emoji: routineType == 'morning' ? '🌅' : '🌙',
              title: 'No blocks yet',
              subtitle: 'Tap + to add your first routine block',
            ),
          )
        else
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.all(16),
              onReorder: onReorder,
              children: blocks.map((block) {
                return _RoutineBlockTile(
                  key: ValueKey(block.id),
                  block: block,
                  onDelete: () => onDelete(block.id),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _RoutineBlockTile extends StatelessWidget {
  final RoutineBlock block;
  final VoidCallback onDelete;

  const _RoutineBlockTile({
    required super.key,
    required this.block,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: Row(
        children: [
          Text(block.iconEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.title,
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${block.durationMinutes} min',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.error, size: 20),
            onPressed: onDelete,
          ),
          const Icon(Icons.drag_handle_rounded,
              color: AppColors.textHint, size: 20),
        ],
      ),
    );
  }
}

class _AddBlockSheet extends ConsumerStatefulWidget {
  final String routineType;
  final Future<void> Function(RoutineBlock) onAdd;

  const _AddBlockSheet({
    required this.routineType,
    required this.onAdd,
  });

  @override
  ConsumerState<_AddBlockSheet> createState() => _AddBlockSheetState();
}

class _AddBlockSheetState extends ConsumerState<_AddBlockSheet> {
  final _titleController = TextEditingController();
  final _uuid = const Uuid();
  String _emoji = '⏱️';
  double _duration = 10;
  bool _isLoading = false;

  static const List<String> _emojis = [
    '⏱️', '🏃', '🧘', '💪', '📚', '✍️', '🚿', '☕', '🎯', '💤',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addBlock() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    final block = RoutineBlock(
      id: _uuid.v4(),
      routineType: widget.routineType,
      title: _titleController.text.trim(),
      durationMinutes: _duration.round(),
      iconEmoji: _emoji,
      sortOrder: 0,
    );

    await widget.onAdd(block);
    setState(() => _isLoading = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.surfaceBright)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ADD BLOCK',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            autofocus: true,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Block Title',
              labelStyle: const TextStyle(
                  fontFamily: 'Nunito', color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.accentGold, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Emoji picker
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _emojis.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final emoji = _emojis[index];
                final isSelected = _emoji == emoji;
                return GestureDetector(
                  onTap: () => setState(() => _emoji = emoji),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentGold.withAlpha(30)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accentGold
                            : AppColors.surfaceBright,
                      ),
                    ),
                    child: Center(
                      child: Text(emoji,
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DURATION',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${_duration.round()} min',
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 14,
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Slider(
            value: _duration,
            min: 1,
            max: 60,
            divisions: 59,
            activeColor: AppColors.accentGold,
            inactiveColor: AppColors.surfaceVariant,
            onChanged: (v) => setState(() => _duration = v),
          ),
          const SizedBox(height: 16),
          ApexButton(
            label: 'Add Block',
            onPressed: _addBlock,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}

extension _StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
