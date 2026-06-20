import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/tracker_entry.dart';
import 'package:apexforge/models/tracker_field_schema.dart';

class TrackerChartPanel extends StatefulWidget {
  final List<TrackerEntry> entries;
  final List<TrackerFieldSchema> fields;
  final Color color;

  const TrackerChartPanel({
    super.key,
    required this.entries,
    required this.fields,
    this.color = AppColors.primaryGreen,
  });

  @override
  State<TrackerChartPanel> createState() => _TrackerChartPanelState();
}

class _TrackerChartPanelState extends State<TrackerChartPanel> {
  String? _selectedFieldId;

  @override
  void initState() {
    super.initState();
    final numericFields = widget.fields
        .where((f) => f.type == 'number' || f.type == 'scale')
        .toList();
    if (numericFields.isNotEmpty) {
      _selectedFieldId = numericFields.first.id;
    }
  }

  List<FlSpot> get _spots {
    if (_selectedFieldId == null) return [];
    final sorted = [...widget.entries]
      ..sort((a, b) => a.date.compareTo(b.date));
    final spots = <FlSpot>[];
    for (int i = 0; i < sorted.length; i++) {
      final val = sorted[i].values[_selectedFieldId!];
      final num = double.tryParse(val?.toString() ?? '');
      if (num != null) {
        spots.add(FlSpot(i.toDouble(), num));
      }
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final numericFields = widget.fields
        .where((f) => f.type == 'number' || f.type == 'scale')
        .toList();

    if (numericFields.isEmpty) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'No numeric fields to chart',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            color: AppColors.textHint,
          ),
        ),
      );
    }

    final spots = _spots;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field selector chips
        if (numericFields.length > 1)
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: numericFields.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = numericFields[i];
                final selected = f.id == _selectedFieldId;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFieldId = f.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? widget.color.withOpacity(0.2)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: selected
                              ? widget.color
                              : AppColors.surfaceBright,
                          width: 1),
                    ),
                    child: Text(
                      f.label,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 12),
        // Chart
        Container(
          height: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceBright, width: 0.5),
          ),
          child: spots.length < 2
              ? const Center(
                  child: Text(
                    'Log more entries to see a chart',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                  ),
                )
              : LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: AppColors.surfaceBright,
                        strokeWidth: 0.5,
                      ),
                      drawVerticalLine: false,
                    ),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: widget.color,
                        barWidth: 2,
                        belowBarData: BarAreaData(
                          show: true,
                          color: widget.color.withOpacity(0.1),
                        ),
                        dotData: FlDotData(
                          show: spots.length <= 14,
                          getDotPainter: (_, __, ___, ____) =>
                              FlDotCirclePainter(
                            radius: 3,
                            color: widget.color,
                            strokeWidth: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
