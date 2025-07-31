import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

class LargeCheckboxListTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final double scale;

  const LargeCheckboxListTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.scale = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return InkWell(
          onTap: () {
            onChanged(!value);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: themeProvider.primaryTextColor,
                    ),
                  ),
                ),
                // Die vergrößerte Checkbox
                Transform.scale(
                  scale: scale,
                  child: Checkbox(
                    value: value,
                    onChanged: onChanged,
                    activeColor: AppTheme.primaryColor,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
