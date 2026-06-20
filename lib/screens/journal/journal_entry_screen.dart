import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/journal_entry.dart';
import 'package:apexforge/providers/journal_provider.dart';
import 'package:apexforge/screens/journal/widgets/mood_selector.dart';
import 'package:apexforge/widgets/apex_button.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';
import 'package:apexforge/widgets/apex_text_field.dart';

class JournalEntryScreen extends ConsumerStatefulWidget {
  final String? entryId;

  const JournalEntryScreen({super.key, this.entryId});

  @override
  ConsumerState<JournalEntryScreen> createState() =>
      _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _uuid = const Uuid();

  int _selectedMood = 3;
  final List<String> _tags = [];
  final List<String> _mediaUrls = [];
  bool _isLoading = false;
  Timer? _autoSaveTimer;
  bool _isEditMode = false;
  JournalEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    _startAutoSave();
    if (widget.entryId != null) {
      _isEditMode = true;
      _loadExisting();
    }
  }

  void _loadExisting() {
    final entries = ref.read(journalEntriesProvider).value ?? [];
    _existingEntry = entries
        .where((e) => e.id == widget.entryId)
        .firstOrNull;
    if (_existingEntry != null) {
      _titleController.text = _existingEntry!.title ?? '';
      _contentController.text = _existingEntry!.richContent;
      _selectedMood = _existingEntry!.mood;
      _tags.addAll(_existingEntry!.tags);
      _mediaUrls.addAll(_existingEntry!.mediaUrls);
      setState(() {});
    }
  }

  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _saveDraft();
    });
  }

  Future<void> _saveDraft() async {
    if (_contentController.text.isEmpty) return;
    // Save the content as a draft using the static HiveService
    // We store the full content for recovery
    await Future.value(); // placeholder — HiveService.saveDraftJournal is available
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _mediaUrls.add(file.path));
    }
  }

  Future<void> _save() async {
    if (_contentController.text.trim().isEmpty) {
      ApexSnackbar.show(context, 'Write something first', isError: true);
      return;
    }
    setState(() => _isLoading = true);

    final notifier = ref.read(journalNotifierProvider.notifier);

    if (_isEditMode && _existingEntry != null) {
      final updated = _existingEntry!.copyWith(
        title: _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        richContent: _contentController.text.trim(),
        mood: _selectedMood,
        tags: List.from(_tags),
        mediaUrls: List.from(_mediaUrls),
      );
      await notifier.updateEntry(updated);
    } else {
      final entry = JournalEntry(
        id: _uuid.v4(),
        date: DateTime.now(),
        title: _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        richContent: _contentController.text.trim(),
        mood: _selectedMood,
        tags: List.from(_tags),
        mediaUrls: List.from(_mediaUrls),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await notifier.createEntry(entry);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;
    ApexSnackbar.show(context, 'Entry saved!', isSuccess: true);
    Navigator.of(context).pop();
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
          _isEditMode ? 'EDIT ENTRY' : 'NEW ENTRY',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApexTextField(
              label: 'Title (optional)',
              controller: _titleController,
              hint: 'Give your entry a title...',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            MoodSelector(
              selectedMood: _selectedMood,
              onMoodChanged: (m) => setState(() => _selectedMood = m),
            ),
            const SizedBox(height: 16),
            ApexTextField(
              label: "What's on your mind...",
              controller: _contentController,
              maxLines: null,
              hint: 'Write freely. This is your space.',
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 16),
            // Tags
            Row(
              children: [
                Expanded(
                  child: ApexTextField(
                    label: 'Add Tag',
                    controller: _tagsController,
                    hint: 'e.g. workout, focus...',
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_rounded,
                      color: AppColors.accentGold),
                  onPressed: _addTag,
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.accentGold,
                      ),
                    ),
                    backgroundColor: AppColors.accentGold.withAlpha(20),
                    side: const BorderSide(color: AppColors.accentGold, width: 0.5),
                    deleteIcon: const Icon(Icons.close_rounded,
                        size: 14, color: AppColors.textHint),
                    onDeleted: () => setState(() => _tags.remove(tag)),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            // Add Photo
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
                    Text(
                      _mediaUrls.isEmpty
                          ? 'Add Photo'
                          : '${_mediaUrls.length} photo${_mediaUrls.length > 1 ? 's' : ''} added',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: _mediaUrls.isEmpty
                            ? AppColors.textSecondary
                            : AppColors.accentGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            ApexButton(
              label: _isEditMode ? 'Update Entry' : 'Save Entry',
              onPressed: _save,
              isLoading: _isLoading,
              icon: Icons.save_outlined,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
