import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A custom calendar widget that uses Material UI components.
class CustomCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;
  final bool showTodayButton;
  final bool showNavigationArrows;
  final Color? selectedDateColor;
  final Color? todayColor;

  const CustomCalendar({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.showTodayButton = true,
    this.showNavigationArrows = true,
    this.selectedDateColor,
    this.todayColor,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  late DateTime _today;
  late DateTime _firstDate;
  late DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _selectedDate = widget.initialDate ?? _today;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _firstDate = widget.firstDate ?? DateTime(_today.year - 5, 1, 1);
    _lastDate = widget.lastDate ?? DateTime(_today.year + 5, 12, 31);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildCalendarGrid(),
        if (widget.showTodayButton) ...[
          const SizedBox(height: 16),
          _buildTodayButton(),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.showNavigationArrows)
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
            color: AppTheme.primaryColor,
          )
        else
          const SizedBox(width: 48),
        Text(
          '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
          style: AppTheme.titleStyle,
        ),
        if (widget.showNavigationArrows)
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
            color: AppTheme.primaryColor,
          )
        else
          const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        _buildWeekdayHeader(),
        const SizedBox(height: 8),
        ..._buildCalendarDays(),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
            (day) => SizedBox(
              width: 40,
              child: Text(
                day,
                style: AppTheme.subtitleStyle.copyWith(
                  color: AppTheme.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
          .toList(),
    );
  }

  List<Widget> _buildCalendarDays() {
    final List<Widget> calendarRows = [];
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    
    // 0 = Monday, 6 = Sunday in DateTime.weekday
    int firstWeekdayOfMonth = firstDayOfMonth.weekday - 1;
    if (firstWeekdayOfMonth == 0) firstWeekdayOfMonth = 7; // Adjust for Sunday
    
    int dayCount = 1;
    
    for (int i = 0; i < 6; i++) {
      final List<Widget> weekRow = [];
      
      for (int j = 0; j < 7; j++) {
        if ((i == 0 && j < firstWeekdayOfMonth) || dayCount > daysInMonth) {
          weekRow.add(const SizedBox(width: 40, height: 40));
        } else {
          final date = DateTime(_currentMonth.year, _currentMonth.month, dayCount);
          final isSelected = _isSameDay(date, _selectedDate);
          final isToday = _isSameDay(date, _today);
          final isEnabled = !date.isBefore(_firstDate) && !date.isAfter(_lastDate);
          
          weekRow.add(
            GestureDetector(
              onTap: isEnabled
                  ? () {
                      setState(() {
                        _selectedDate = date;
                      });
                      widget.onDateSelected?.call(date);
                    }
                  : null,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? widget.selectedDateColor ?? AppTheme.primaryColor
                      : isToday
                          ? widget.todayColor ?? AppTheme.secondaryColor.withOpacity(0.3)
                          : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    dayCount.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isEnabled
                              ? isToday
                                  ? AppTheme.primaryColor
                                  : AppTheme.primaryTextColor
                              : AppTheme.tertiaryTextColor,
                      fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
          
          dayCount++;
        }
      }
      
      if (dayCount <= daysInMonth) {
        calendarRows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekRow,
            ),
          ),
        );
      } else {
        break;
      }
    }
    
    return calendarRows;
  }

  Widget _buildTodayButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _currentMonth = DateTime(_today.year, _today.month, 1);
          _selectedDate = _today;
        });
        widget.onDateSelected?.call(_today);
      },
      child: const Text('Today'),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}

/// A date picker dialog that uses the CustomCalendar.
class DatePickerDialog extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;

  const DatePickerDialog({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Date',
                  style: AppTheme.titleStyle,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  color: AppTheme.secondaryTextColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCalendar(
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateSelected: (date) {
                onDateSelected?.call(date);
                Navigator.of(context).pop(date);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.secondaryTextColor,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onDateSelected?.call(initialDate ?? DateTime.now());
                    Navigator.of(context).pop(initialDate ?? DateTime.now());
                  },
                  child: const Text('OK'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a date picker dialog.
Future<DateTime?> showDatePickerDialog({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return DatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    },
  );
}