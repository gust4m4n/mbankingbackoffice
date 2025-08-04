import 'package:flutter/material.dart';
import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';

/// Reusable action builders for admin table
class MbxAdminTableActionBuilders {
  /// Build standard admin actions: view, edit, delete
  static List<Widget> buildStandardActions(
    MbxAdminModel admin, {
    VoidCallback? onView,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return [
      // View Button
      if (onView != null)
        IconButton(
          onPressed: onView,
          icon: const Icon(Icons.visibility_outlined, size: 18),
          tooltip: 'View',
          splashRadius: 20,
        ),

      // Edit Button
      if (onEdit != null)
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, size: 18),
          tooltip: 'Edit',
          splashRadius: 20,
        ),

      // Delete Button
      if (onDelete != null)
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, size: 18),
          color: Colors.red,
          tooltip: 'Delete',
          splashRadius: 20,
        ),
    ];
  }

  /// Build view-only actions
  static List<Widget> buildViewOnlyActions(
    MbxAdminModel admin, {
    required VoidCallback onView,
  }) {
    return [
      IconButton(
        onPressed: onView,
        icon: const Icon(Icons.visibility_outlined, size: 18),
        tooltip: 'View',
        splashRadius: 20,
      ),
    ];
  }

  /// Build management actions: edit and delete only
  static List<Widget> buildManagementActions(
    MbxAdminModel admin, {
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return [
      if (onEdit != null)
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, size: 18),
          tooltip: 'Edit',
          splashRadius: 20,
        ),
      if (onDelete != null)
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, size: 18),
          color: Colors.red,
          tooltip: 'Delete',
          splashRadius: 20,
        ),
    ];
  }

  /// Build custom actions with provided action items
  static List<Widget> buildCustomActions(List<MbxAdminActionItem> actions) {
    return actions.map((action) {
      return IconButton(
        onPressed: action.onPressed,
        icon: Icon(action.icon, size: 18, color: action.color),
        tooltip: action.tooltip,
        splashRadius: 20,
      );
    }).toList();
  }
}

/// Action item configuration for admin table
class MbxAdminActionItem {
  final IconData icon;
  final Color? color;
  final String tooltip;
  final VoidCallback onPressed;

  const MbxAdminActionItem({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });
}
