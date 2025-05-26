import 'package:flutter/material.dart';
import '../pages/medication_detail_page.dart';

class MedicationItem extends StatefulWidget {
  final String medicationName;
  final String dosage;
  final String timeOfDay;
  final bool isCompleted;
  final VoidCallback? onToggle;

  const MedicationItem({
    Key? key,
    required this.medicationName,
    required this.dosage,
    required this.timeOfDay,
    this.isCompleted = false,
    this.onToggle,
  }) : super(key: key);

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.medication,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Medication Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medicationName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isCompleted ? Colors.grey : Colors.black87,
                      decoration: _isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.dosage}, ${widget.timeOfDay}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isCompleted ? Colors.grey : Colors.grey.shade600,
                      decoration: _isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),

            // Checkbox (display only, not clickable)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isCompleted ? Colors.green : Colors.grey.shade400,
                  width: 2,
                ),
                color: _isCompleted ? Colors.green : Colors.transparent,
              ),
              child: _isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
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
