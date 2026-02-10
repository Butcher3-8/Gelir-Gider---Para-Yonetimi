import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Ortada açılan, bulanık arka planlı, yıl/ay seçimli tarih seçici dialog.
/// [showDayAndTime] true olduğunda gün ve saat/dakika seçimi de gösterilir.
class AppDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onCancel;
  final bool showDayAndTime;
  final bool showDayOnly;

  const AppDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.maxDate,
    required this.onSelect,
    required this.onCancel,
    this.showDayAndTime = false,
    this.showDayOnly = false,
  });

  @override
  State<AppDatePickerDialog> createState() => _AppDatePickerDialogState();
}

class _AppDatePickerDialogState extends State<AppDatePickerDialog> {
  static const List<String> _monthNames = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  late DateTime _focusedDay;
  late int _selectedDay;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    _selectedDay = widget.initialDate.day;
    _selectedHour = widget.initialDate.hour;
    _selectedMinute = widget.initialDate.minute;
  }

  int get _firstYear => 2000;
  int get _lastYear => widget.maxDate.year;

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  bool get _showDaySelector => widget.showDayAndTime || widget.showDayOnly;
  bool get _showTimeSelector => widget.showDayAndTime;

  void _goToYearMonth(int year, int month) {
    final maxDays = _daysInMonth(year, month);
    setState(() {
      _focusedDay = DateTime(year, month, 1);
      if (_focusedDay.isAfter(widget.maxDate)) {
        _focusedDay = widget.maxDate;
      }
      if (_selectedDay > maxDays) {
        _selectedDay = maxDays;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color ?? Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onCancel,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () {},
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                constraints: const BoxConstraints(maxWidth: 360),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tarih Seç',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            IconButton(
                              onPressed: widget.onCancel,
                              icon: const Icon(Icons.close_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _DropdownTile<int>(
                                value: _focusedDay.year,
                                items: List.generate(
                                  _lastYear - _firstYear + 1,
                                  (i) => _lastYear - i,
                                ),
                                valueLabel: (v) => '$v',
                                onChanged: (year) => _goToYearMonth(year!, _focusedDay.month),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DropdownTile<int>(
                                value: _focusedDay.month,
                                items: List.generate(12, (i) => i + 1),
                                valueLabel: (v) => _monthNames[v - 1],
                                onChanged: (month) => _goToYearMonth(_focusedDay.year, month!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_showDaySelector) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: _DropdownTile<int>(
                                  value: _selectedDay,
                                  items: List.generate(
                                    _daysInMonth(_focusedDay.year, _focusedDay.month),
                                    (i) => i + 1,
                                  ),
                                  valueLabel: (v) => '$v',
                                  onChanged: (day) => setState(() => _selectedDay = day!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (_showTimeSelector) ...[
                                Expanded(
                                  child: _DropdownTile<int>(
                                    value: _selectedHour,
                                    items: List.generate(24, (i) => i),
                                    valueLabel: (v) => v.toString().padLeft(2, '0'),
                                    onChanged: (h) => setState(() => _selectedHour = h!),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(':', style: Theme.of(context).textTheme.titleLarge),
                                ),
                                Expanded(
                                  child: _DropdownTile<int>(
                                    value: _selectedMinute,
                                    items: List.generate(60, (i) => i),
                                    valueLabel: (v) => v.toString().padLeft(2, '0'),
                                    onChanged: (m) => setState(() => _selectedMinute = m!),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  final now = DateTime.now();
                                  if (_showTimeSelector) {
                                    widget.onSelect(now);
                                  } else if (_showDaySelector) {
                                    widget.onSelect(DateTime(now.year, now.month, now.day));
                                  } else if (now.year < widget.maxDate.year ||
                                      (now.year == widget.maxDate.year && now.month <= widget.maxDate.month)) {
                                    widget.onSelect(DateTime(now.year, now.month, 1));
                                  }
                                },
                                icon: const Icon(Icons.today_rounded, size: 20),
                                label: const Text('Bugün'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.income,
                                  side: const BorderSide(color: AppColors.income),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: FilledButton.icon(
                                onPressed: () {
                                  if (_showTimeSelector) {
                                    widget.onSelect(DateTime(
                                      _focusedDay.year,
                                      _focusedDay.month,
                                      _selectedDay,
                                      _selectedHour,
                                      _selectedMinute,
                                    ));
                                  } else if (_showDaySelector) {
                                    widget.onSelect(DateTime(
                                      _focusedDay.year,
                                      _focusedDay.month,
                                      _selectedDay,
                                    ));
                                  } else {
                                    widget.onSelect(DateTime(_focusedDay.year, _focusedDay.month, 1));
                                  }
                                },
                                icon: const Icon(Icons.check_rounded, size: 20),
                                label: const Text('Seç'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.income,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class _DropdownTile<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) valueLabel;
  final ValueChanged<T?> onChanged;

  const _DropdownTile({
    required this.value,
    required this.items,
    required this.valueLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.income.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.income.withValues(alpha: 0.25)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.income),
          items: items.map((v) => DropdownMenuItem<T>(value: v, child: Text(valueLabel(v)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
