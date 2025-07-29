import 'package:flutter/material.dart';
import '../models/medication_model.dart';
import '../pages/medication_detail_page.dart';
import '../theme/app_theme.dart';

class MedicationItem extends StatefulWidget {
  final Medication medication;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDataChanged;
  final bool showCompletedStyling;

  const MedicationItem({
    super.key,
    required this.medication,
    this.onDataChanged,
    this.trailingWidget,
    this.onTap,
    this.onToggle,
    this.showCompletedStyling = true,
  });

  @override
  State<MedicationItem> createState() => _MedicationItemState();
}

class _MedicationItemState extends State<MedicationItem> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.medication.isCompleted;
  }

  @override
  void didUpdateWidget(covariant MedicationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.medication.isCompleted != _isCompleted) {
      setState(() {
        _isCompleted = widget.medication.isCompleted;
      });
    }
  }

  String _formatDaysOfWeek(List<int> days) {
    if (days.length == 7) return 'Täglich';
    if (days.isEmpty) return 'Keine Tage';

    const dayMap = {1: 'Mo', 2: 'Di', 3: 'Mi', 4: 'Do', 5: 'Fr', 6: 'Sa', 7: 'So'};
    days.sort();
    return days.map((d) => dayMap[d] ?? '').join(', ');
  }

  Future<void> _navigateToDetailPage() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationDetailPage(
          medication: widget.medication,
          onToggle: (bool newValue) {},
        ),
      ),
    );

    if (result == true) {
      widget.onDataChanged!();
    }
  }


  @override
  Widget build(BuildContext context) {
    final effectiveOnTap = widget.onTap ?? _navigateToDetailPage;

    return GestureDetector(
      onTap: effectiveOnTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                  color: AppTheme.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medication,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medication.name, // <--- Hier angepasst
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: (widget.showCompletedStyling && _isCompleted) ? AppTheme.completedTextColor : AppTheme.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.medication.dosage} · ${widget.medication.time.format(context)} · ${_formatDaysOfWeek(widget.medication.daysOfWeek)}', // <--- Hier angepasst
                    style: TextStyle(
                      fontSize: 14,
                      color: (widget.showCompletedStyling && _isCompleted) ? AppTheme.completedTextColor : AppTheme.secondaryTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Show trailingWidget if provided, otherwise show checkbox
            widget.trailingWidget ?? GestureDetector(
              onTap: widget.onToggle,
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.06,
                    height: MediaQuery.of(context).size.width * 0.06,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (widget.showCompletedStyling && _isCompleted) ? AppTheme.completedColor : AppTheme.checkboxInactiveColor,
                        width: 2,
                      ),
                      color: (widget.showCompletedStyling && _isCompleted) ? AppTheme.completedColor : Colors.transparent,
                    ),
                    child: (widget.showCompletedStyling && _isCompleted)
                        ? const Icon(
                      Icons.check,
                      color: AppTheme.cardBackgroundColor,
                      size: 16,
                    )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}