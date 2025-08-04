import 'package:flutter/material.dart';
import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';

/// Reusable action builders for user table
class MbxUserTableActionBuilders {
  /// Build standard user actions: topup, adjust, history, view
  static List<Widget> buildStandardActions(
    MbxUserModel user, {
    VoidCallback? onTopup,
    VoidCallback? onAdjust,
    VoidCallback? onHistory,
    VoidCallback? onView,
  }) {
    return [
      // Top Up Button
      if (onTopup != null)
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: onTopup,
            icon: const Icon(
              Icons.add_circle_outline,
              size: 11,
              color: Color(0xFF1976D2),
            ),
            tooltip: 'Top Up',
            padding: EdgeInsets.zero,
            splashRadius: 10,
          ),
        ),

      // Adjust Button
      if (onAdjust != null)
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: onAdjust,
            icon: const Icon(
              Icons.tune_rounded,
              size: 11,
              color: Color(0xFFFF9800),
            ),
            tooltip: 'Adjust',
            padding: EdgeInsets.zero,
            splashRadius: 10,
          ),
        ),

      // History Button
      if (onHistory != null)
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: onHistory,
            icon: const Icon(
              Icons.history_rounded,
              size: 11,
              color: Color(0xFF673AB7),
            ),
            tooltip: 'History',
            padding: EdgeInsets.zero,
            splashRadius: 10,
          ),
        ),

      // View Button
      if (onView != null)
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: onView,
            icon: const Icon(Icons.visibility_outlined, size: 11),
            tooltip: 'View',
            padding: EdgeInsets.zero,
            splashRadius: 10,
          ),
        ),
    ];
  }

  /// Build minimal actions: view only
  static List<Widget> buildViewOnlyActions(
    MbxUserModel user, {
    required VoidCallback onView,
  }) {
    return [
      SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          onPressed: onView,
          icon: const Icon(Icons.visibility_outlined, size: 11),
          tooltip: 'View',
          padding: EdgeInsets.zero,
          splashRadius: 10,
        ),
      ),
    ];
  }

  /// Build financial actions: topup and adjust only
  static List<Widget> buildFinancialActions(
    MbxUserModel user, {
    VoidCallback? onTopup,
    VoidCallback? onAdjust,
  }) {
    return [
      if (onTopup != null)
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: onTopup,
            icon: const Icon(
              Icons.add_circle_outline,
              size: 11,
              color: Color(0xFF1976D2),
            ),
            tooltip: 'Top Up',
            padding: EdgeInsets.zero,
            splashRadius: 10,
          ),
        ),
      if (onAdjust != null)
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: onAdjust,
            icon: const Icon(
              Icons.tune_rounded,
              size: 11,
              color: Color(0xFFFF9800),
            ),
            tooltip: 'Adjust',
            padding: EdgeInsets.zero,
            splashRadius: 10,
          ),
        ),
    ];
  }

  /// Build custom actions with provided action items
  static List<Widget> buildCustomActions(List<MbxUserActionItem> actions) {
    return actions.map((action) {
      return SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          onPressed: action.onPressed,
          icon: Icon(action.icon, size: 11, color: action.color),
          tooltip: action.tooltip,
          padding: EdgeInsets.zero,
          splashRadius: 10,
        ),
      );
    }).toList();
  }
}

/// Action item configuration for user table
class MbxUserActionItem {
  final IconData icon;
  final Color? color;
  final String tooltip;
  final VoidCallback onPressed;

  const MbxUserActionItem({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });
}
