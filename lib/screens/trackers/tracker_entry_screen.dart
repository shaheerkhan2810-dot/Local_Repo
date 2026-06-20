import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/models/tracker_entry.dart';
import 'package:apexforge/models/tracker_field_schema.dart';
import 'package:apexforge/providers/tracker_provider.dart';
import 'package:apexforge/widgets/apex_button.dart';
import 'package:apexforge/widgets/apex_text_field.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';

class TrackerEntryScreen extends ConsumerStatefulWidget {
  final String trackerId;

  const TrackerEntryScreen({super.key, required this.trackerId});

  @override
  ConsumerState<TrackerEntryScreen> createState() =>
      _TrackerEntryScreenState();
}

class _TrackerEntryScreenState extends ConsumerState<TrackerEntryScreen> {
  final _uuid = const Uuid();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final Map<String, dynamic> _fieldValues = {};
  final Map<String, TextEditingController> _textControllers = {};
  final List<String> _mediaUrls = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate() async {
    final minDate = DateTime.now()
        .subtract(Duration(days: AppConstants.maxTrackerEntryBackfillDays));
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: minDate,
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentGold,
            surface: AppColors.surfaceVariant,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _mediaUrls.add(file.path));
    }
  }

  Future<void> _submit(List<TrackerFieldSchema> fields) async {
    setState(() => _isLoading = true);

    for (final field in fields) {
      if (field.type == AppConstants.fieldTypeNumber ||
          field.type == AppConstants.fieldTypeText) {
        final controller = _textControllers[field.id];
        if (controller != null) {
          final val = controller.text.trim();
          if (val.isNotEmpty) {
            _fieldValues[field.id] = field.type == AppConstants.fieldTypeNumber
                ? double.tryParse(val) ?? val
                : val;
          }
        }
      }
    }

    final entry = TrackerEntry(
      id: _uuid.v4(),
      trackerId: widget.trackerId,
      date: _selectedDate,
      values: Map.from(_fieldValues),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      mediaUrls: _mediaUrls,
      loggedAt: DateTime.now(),
      xpAwarded: 5,
    );

    final result = await ref
        .read(trackerEntryNotifierProvider.notifier)
        .logEntry(widget.trackerId, entry);

    setState(() => _isLoading = false);

    if (!mounted) return;
    if (result != null) {
      ApexSnackbar.show(context, 'Entry logged!', isSuccess: true);
      Navigator.of(context).pop();
    } else {
      ApexSnackbar.show(context, 'Failed to log entry', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackerAsync =
        ref.watch(trackerDetailProvider(widget.trackerId));

    return trackerAsync.when(
      data: (tracker) {
        if (tracker == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: Text('Tracker not found',
                  style: TextStyle(color: AppColors.textHint)),
            ),
          );
        }

        final fields = tracker.fieldSchema;
        for (final field in fields) {
          if ((field.type == AppConstants.fieldTypeNumber ||
                  field.type == AppConstants.fieldTypeText) &&
              !_textControllers.containsKey(field.id)) {
            _textControllers[field.id] = TextEditingController();
          }
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded,
                  color: AppColors.textSecondary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'LOG ENTRY',
              style: TextStyle(
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date selector
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.surfaceBright, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            color: AppColors.accentGold, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          AppDateUtils.formatDate(_selectedDate),
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down_rounded,
                            color: AppColors.textHint),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Dynamic fields
                ...fields.map((field) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildFieldWidget(field),
                  );
                }),
                // Notes
                ApexTextField(
                  label: 'Notes (optional)',
                  controller: _notesController,
                  maxLines: 3,
                  hint: 'Any additional notes...',
                ),
                const SizedBox(height: 16),
                // Add photo
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.surfaceBright, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_photo_alternate_outlined,
                            color: AppColors.accentGold, size: 20),
                        const SizedBox(width: 10),
                        const Text(
                          'Add Photo',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (_mediaUrls.isNotEmpty) ...[
                          const Spacer(),
                          Text(
                            '${_mediaUrls.length} selected',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                ApexButton(
                  label: 'Submit Entry',
                  onPressed: () => _submit(fields),
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.accentGold),
          ),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: Text('Error', style: TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }

  Widget _buildFieldWidget(TrackerFieldSchema field) {
    switch (field.type) {
      case AppConstants.fieldTypeNumber:
        return ApexTextField(
          label: field.label,
          controller: _textControllers[field.id],
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          hint: field.unit != null ? 'e.g. 100 ${field.unit}' : null,
          suffix: field.unit != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    field.unit!,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                  ),
                )
              : null,
        );
      case AppConstants.fieldTypeBoolean:
        return SwitchListTile(
          value: _fieldValues[field.id] as bool? ?? false,
          onChanged: (v) => setState(() => _fieldValues[field.id] = v),
          activeColor: AppColors.accentGold,
          title: Text(
            field.label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          tileColor: AppColors.surfaceVariant,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        );
      case AppConstants.fieldTypeScale:
        final min = field.min ?? 1;
        final max = field.max ?? 10;
        final current =
            (_fieldValues[field.id] as double?) ?? min;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  field.label,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${current.round()}',
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
            Slider(
              value: current,
              min: min,
              max: max,
              divisions: (max - min).round(),
              activeColor: AppColors.accentGold,
              inactiveColor: AppColors.surfaceVariant,
              onChanged: (v) =>
                  setState(() => _fieldValues[field.id] = v),
            ),
          ],
        );
      case AppConstants.fieldTypeText:
        return ApexTextField(
          label: field.label,
          controller: _textControllers[field.id],
          maxLines: 3,
          hint: 'Enter ${field.label.toLowerCase()}...',
        );
      case AppConstants.fieldTypeSelect:
        final options = field.options ?? [];
        final selected = _fieldValues[field.id] as String?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((opt) {
                final isSelected = selected == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor: AppColors.accentGold.withAlpha(40),
                  backgroundColor: AppColors.surfaceVariant,
                  labelStyle: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.accentGold
                        : AppColors.textSecondary,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.accentGold
                        : AppColors.surfaceBright,
                  ),
                  onSelected: (_) =>
                      setState(() => _fieldValues[field.id] = opt),
                );
              }).toList(),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
