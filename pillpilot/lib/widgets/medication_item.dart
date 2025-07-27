import 'package:flutter/material.dart';
import '../pages/medication_detail_page.dart';
import '../theme/app_theme.dart';

class MedicationItem extends StatefulWidget {
  final String medicationName;
  final String dosage;
  final String timeOfDay;
  final bool isCompleted;
  final Widget? trailingWidget; // Ein Widget für die rechte Seite
  final VoidCallback? onTap;
  final String notes;
  final VoidCallback? onToggle;
  final bool showStrikethrough;

  const MedicationItem({
    super.key,
    required this.medicationName,
    required this.dosage,
    required this.timeOfDay,
    this.trailingWidget,
    this.onTap,
    this.isCompleted = false,
    this.notes = '',
    this.onToggle,
    this.showStrikethrough = true,
  });

  @override
  State<MedicationItem> createState() => _MedicationItemState();
}

class _MedicationItemState extends State<MedicationItem> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }

  void _navigateToDetailPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationDetailPage(
          medicationName: widget.medicationName,
          dosage: widget.dosage,
          timeOfDay: widget.timeOfDay,
          isCompleted: _isCompleted,
          notes: widget.notes,
          onToggle: (bool newValue) {
            setState(() {
              _isCompleted = newValue;
            });
            if (widget.onToggle != null) {
              widget.onToggle!();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToDetailPage,
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
            // Medication Icon
            Container(
              width: 48,
              height: 48,
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
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medicationName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isCompleted ? AppTheme.completedTextColor : AppTheme.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.dosage}, ${widget.timeOfDay}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isCompleted ? AppTheme.completedTextColor : AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            if (widget.trailingWidget != null)
              widget.trailingWidget!
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isCompleted ? AppTheme.completedColor : AppTheme.checkboxInactiveColor,
                    width: 2,
                  ),
                  color: _isCompleted ? AppTheme.completedColor : Colors.transparent,
                ),
                child: _isCompleted
                    ? const Icon(
                  Icons.check,
                  color: AppTheme.cardBackgroundColor,
                  size: 16,
                )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
