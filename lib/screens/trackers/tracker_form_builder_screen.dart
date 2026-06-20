import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/models/custom_tracker.dart';
import 'package:apexforge/models/tracker_field_schema.dart';
import 'package:apexforge/providers/tracker_provider.dart';
import 'package:apexforge/widgets/apex_button.dart';
import 'package:apexforge/widgets/apex_text_field.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';

class TrackerFormBuilderScreen extends ConsumerStatefulWidget {
  final String? trackerId;

  const TrackerFormBuilderScreen({super.key, this.trackerId});

  @override
  ConsumerState<TrackerFormBuilderScreen> createState() =>
      _TrackerFormBuilderScreenState();
}

class _TrackerFormBuilderScreenState
    extends ConsumerState<TrackerFormBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _uuid = const Uuid();

  String _selectedEmoji = '📊';
  String _selectedColor = '#1B5E20';
  String _selectedDomain = AppConstants.domainDiscipline;
  double _xpPerEntry = 5;
  List<TrackerFieldSchema> _fields = [];
  bool _isLoading = false;

  static const List<String> _commonEmojis = [
    '📊', '💪', '🧠', '💰', '🏃', '📚', '🧘', '💼', '🎯', '⚡',
    '🔥', '🌟', '📈', '🎮', '🍎', '💤', '🚿', '📖', '✍️', '🎵',
  ];

  static const List<String> _colors = [
    '#1B5E20', '#1565C0', '#7B1FA2', '#E65100',
    '#00695C', '#C62828', '#F57F17', '#006064',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addField() {
    setState(() {
      _fields.add(TrackerFieldSchema(
        id: _uuid.v4(),
        label: 'Field ${_fields.length + 1}',
        type: AppConstants.fieldTypeNumber,
      ));
    });
  }

  void _removeField(int index) {
    setState(() => _fields.removeAt(index));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final tracker = CustomTracker(
      id: widget.trackerId ?? _uuid.v4(),
      name: _nameController.text.trim(),
      emoji: _selectedEmoji,
      colorHex: _selectedColor,
      fieldSchema: _fields,
      xpPerEntry: _xpPerEntry.round(),
      domain: _selectedDomain,
      createdAt: DateTime.now(),
    );

    final notifier = ref.read(trackerNotifierProvider.notifier);
    String? result;
    if (widget.trackerId != null) {
      await notifier.updateTracker(tracker);
      result = widget.trackerId;
    } else {
      result = await notifier.createTracker(tracker);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;
    if (result != null) {
      ApexSnackbar.show(context, 'Tracker saved!', isSuccess: true);
      Navigator.of(context).pop();
    } else {
      ApexSnackbar.show(context, 'Failed to save tracker', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.trackerId != null ? 'EDIT TRACKER' : 'CREATE TRACKER',
          style: const TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.surfaceBright),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApexTextField(
                label: 'Tracker Name',
                controller: _nameController,
                hint: 'e.g. Morning Workout',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              const SizedBox(height: 20),
              const _SectionLabel('EMOJI'),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _commonEmojis.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final emoji = _commonEmojis[index];
                    final isSelected = _selectedEmoji == emoji;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedEmoji = emoji),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accentGold.withAlpha(30)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accentGold
                                : AppColors.surfaceBright,
                          ),
                        ),
                        child: Center(
                          child: Text(emoji,
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const _SectionLabel('COLOR'),
              const SizedBox(height: 8),
              Row(
                children: _colors.map((hex) {
                  final color =
                      Color(int.parse(hex.replaceFirst('#', '0xFF')));
                  final isSelected = _selectedColor == hex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = hex),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: color.withAlpha(120), blurRadius: 6)]
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const _SectionLabel('DOMAIN'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDomain,
                dropdownColor: AppColors.surfaceVariant,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: AppConstants.allDomains.map((d) {
                  final emoji = AppConstants.domainEmojis[d] ?? '';
                  final label = AppConstants.domainLabels[d] ?? d;
                  return DropdownMenuItem(
                    value: d,
                    child: Text('$emoji $label'),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedDomain = v);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel('XP PER ENTRY'),
                  Text(
                    '${_xpPerEntry.round()} XP',
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
                value: _xpPerEntry,
                min: 1,
                max: 20,
                divisions: 19,
                activeColor: AppColors.accentGold,
                inactiveColor: AppColors.surfaceVariant,
                onChanged: (v) => setState(() => _xpPerEntry = v),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const _SectionLabel('FORM FIELDS'),
                  const Spacer(),
                  Text(
                    '${_fields.length}/${AppConstants.maxTrackerFields}',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_fields.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No fields yet. Add a field to track data.',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                  ),
                )
              else
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = _fields.removeAt(oldIndex);
                      _fields.insert(newIndex, item);
                    });
                  },
                  children: _fields.asMap().entries.map((entry) {
                    final index = entry.key;
                    final field = entry.value;
                    return _FieldItem(
                      key: ValueKey(field.id),
                      field: field,
                      onDelete: () => _removeField(index),
                      onTypeChange: (type) {
                        setState(() {
                          _fields[index] = field.copyWith(type: type);
                        });
                      },
                      onLabelChange: (label) {
                        setState(() {
                          _fields[index] = field.copyWith(label: label);
                        });
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 10),
              if (_fields.length < AppConstants.maxTrackerFields)
                TextButton.icon(
                  onPressed: _addField,
                  icon: const Icon(Icons.add_circle_outline_rounded,
                      color: AppColors.accentGold, size: 18),
                  label: const Text(
                    'Add Field',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 15,
                      color: AppColors.accentGold,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              ApexButton(
                label: widget.trackerId != null
                    ? 'Update Tracker'
                    : 'Create Tracker',
                onPressed: _save,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Rajdhani',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.accentGold,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _FieldItem extends StatefulWidget {
  final TrackerFieldSchema field;
  final VoidCallback onDelete;
  final ValueChanged<String> onTypeChange;
  final ValueChanged<String> onLabelChange;

  const _FieldItem({
    required super.key,
    required this.field,
    required this.onDelete,
    required this.onTypeChange,
    required this.onLabelChange,
  });

  @override
  State<_FieldItem> createState() => _FieldItemState();
}

class _FieldItemState extends State<_FieldItem> {
  late TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.field.label);
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  static const List<String> _fieldTypes = [
    AppConstants.fieldTypeNumber,
    AppConstants.fieldTypeBoolean,
    AppConstants.fieldTypeText,
    AppConstants.fieldTypeScale,
    AppConstants.fieldTypeSelect,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_handle_rounded,
              color: AppColors.textHint, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _labelController,
              onChanged: widget.onLabelChange,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Field label',
                hintStyle:
                    TextStyle(color: AppColors.textHint, fontSize: 13),
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.field.type,
            dropdownColor: AppColors.surfaceVariant,
            underline: const SizedBox(),
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 12,
              color: AppColors.accentGold,
            ),
            items: _fieldTypes
                .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(
                          TrackerFieldSchema(id: '', label: '', type: t)
                              .typeLabel),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) widget.onTypeChange(v);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.error, size: 18),
            onPressed: widget.onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
