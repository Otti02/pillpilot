import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;

  const CustomCalendar({super.key, this.initialDate, this.onDateSelected});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [SizedBox(height: 16), _buildCalendarGrid()],
    );
  }

  Widget _buildCalendarGrid() {
    return CalendarDatePicker(
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      onDateChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
        widget.onDateSelected?.call(date);
      },
    );
  }

  Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    DateTime? initialDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
  }
}
