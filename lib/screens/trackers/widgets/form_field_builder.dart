import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/models/tracker_field_schema.dart';

class FormFieldBuilder extends StatelessWidget {
  final TrackerFieldSchema field;
  final VoidCallback onDelete;
  final ValueChanged<TrackerFieldSchema> onChanged;

  const FormFieldBuilder({
    super.key,
    required this.field,
    required this.onDelete,
    required this.onChanged,
  });

  static const _types = [
    AppConstants.fieldTypeNumber,
    AppConstants.fieldTypeBoolean,
    AppConstants.fieldTypeScale,
    AppConstants.fieldTypeText,
    AppConstants.fieldTypeDuration,
    AppConstants.fieldTypeSelect,
  ];

  static const _typeLabels = {
    AppConstants.fieldTypeNumber: '123',
    AppConstants.fieldTypeBoolean: 'Y/N',
    AppConstants.fieldTypeScale: '1-10',
    AppConstants.fieldTypeText: 'Abc',
    AppConstants.fieldTypeDuration: '⏱',
    AppConstants.fieldTypeSelect: '⊙',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_handle_rounded,
              color: AppColors.textHint, size: 18),
          const SizedBox(width: 10),

          // Label
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: field.label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Field name',
                hintStyle: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: AppColors.textHint,
                ),
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) =>
                  onChanged(field.copyWith(label: val)),
            ),
          ),

          const SizedBox(width: 8),

          // Type selector
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: field.type,
              dropdownColor: AppColors.surface,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGold,
              ),
              items: _types
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(_typeLabels[t] ?? t),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) onChanged(field.copyWith(type: val));
              },
            ),
          ),

          const SizedBox(width: 8),

          // Delete
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close_rounded,
                color: AppColors.error, size: 18),
          ),
        ],
      ),
    );
  }
}
