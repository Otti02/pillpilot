import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    final dayMap = AppTheme.weekdays;
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

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GestureDetector(
          onTap: effectiveOnTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding, vertical: AppTheme.smallPadding),
            padding: EdgeInsets.all(AppTheme.defaultPadding),
            decoration: BoxDecoration(
              color: themeProvider.cardBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: AppTheme.defaultShadowOffset,
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
                SizedBox(width: AppTheme.defaultPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.medication.name, // <--- Hier angepasst
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: (widget.showCompletedStyling && _isCompleted) 
                              ? AppTheme.completedTextColor 
                              : themeProvider.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: AppTheme.smallPadding / 2),
                      Text(
                        '${widget.medication.dosage} · ${widget.medication.time.format(context)} · ${_formatDaysOfWeek(widget.medication.daysOfWeek)}', // <--- Hier angepasst
                        style: TextStyle(
                          fontSize: 14,
                          color: (widget.showCompletedStyling && _isCompleted) 
                              ? AppTheme.completedTextColor 
                              : themeProvider.secondaryTextColor,
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
                            color: (widget.showCompletedStyling && _isCompleted) 
                                ? AppTheme.completedColor 
                                : AppTheme.checkboxInactiveColor,
                            width: 2,
                          ),
                          color: (widget.showCompletedStyling && _isCompleted) 
                              ? AppTheme.completedColor 
                              : Colors.transparent,
                        ),
                        child: (widget.showCompletedStyling && _isCompleted)
                            ? Icon(
                          Icons.check,
                          color: themeProvider.cardBackgroundColor,
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
      },
    );
  }
}