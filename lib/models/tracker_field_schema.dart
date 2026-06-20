import '../core/constants/app_constants.dart';

class TrackerFieldSchema {
  final String id;
  final String label;
  final String type;
  final String? unit;
  final List<String>? options;
  final double? min;
  final double? max;
  final bool required;

  const TrackerFieldSchema({
    required this.id,
    required this.label,
    required this.type,
    this.unit,
    this.options,
    this.min,
    this.max,
    this.required = false,
  });

  String get typeLabel {
    switch (type) {
      case AppConstants.fieldTypeNumber:
        return 'Number';
      case AppConstants.fieldTypeBoolean:
        return 'Yes / No';
      case AppConstants.fieldTypeText:
        return 'Text';
      case AppConstants.fieldTypeScale:
        return 'Scale';
      case AppConstants.fieldTypeDuration:
        return 'Duration';
      case AppConstants.fieldTypeSelect:
        return 'Select';
      default:
        return 'Unknown';
    }
  }

  factory TrackerFieldSchema.fromMap(Map<String, dynamic> map) {
    return TrackerFieldSchema(
      id: map['id'] as String,
      label: map['label'] as String,
      type: map['type'] as String,
      unit: map['unit'] as String?,
      options: (map['options'] as List?)?.cast<String>(),
      min: (map['min'] as num?)?.toDouble(),
      max: (map['max'] as num?)?.toDouble(),
      required: map['required'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'type': type,
        'unit': unit,
        'options': options,
        'min': min,
        'max': max,
        'required': required,
      };

  TrackerFieldSchema copyWith({
    String? label,
    String? type,
    String? unit,
    List<String>? options,
    double? min,
    double? max,
    bool? required,
  }) {
    return TrackerFieldSchema(
      id: id,
      label: label ?? this.label,
      type: type ?? this.type,
      unit: unit ?? this.unit,
      options: options ?? this.options,
      min: min ?? this.min,
      max: max ?? this.max,
      required: required ?? this.required,
    );
  }
}
