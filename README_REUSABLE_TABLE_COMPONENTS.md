# Reusable Data Table Components

This document describes the reusable data table components created for the MBanking BackOffice application. These components make it easy to create consistent, feature-rich data tables across different management screens.

## Overview

The reusable table system consists of:

1. **Core Table Components** - Base data table infrastructure
2. **User Table Components** - Specialized components for user management
3. **Admin Table Components** - Specialized components for admin management
4. **Column Header Components** - Reusable header management

## Core Components

### MbxDataTableWidget
The base reusable data table widget with sticky headers and pagination support.

**Location:** `lib/widget-x/mbx_data_table_widget.dart`

**Features:**
- Sticky headers
- Sortable columns
- Row highlighting
- Loading states
- Empty states
- Action columns
- Responsive design

### MbxTableHeader
Reusable table header component with sorting capabilities.

**Location:** `lib/widget-x/mbx_table_header.dart`

### MbxTableBody
Reusable table body component for data rows.

**Location:** `lib/widget-x/mbx_table_body.dart`

## User Management Components

### MbxUserTableWidget
A specialized table widget for displaying user data with predefined columns and formatting.

**Location:** `lib/widget-x/mbx_user_table_widget.dart`

**Features:**
- Predefined user columns (name, phone, balance, status, etc.)
- Configurable column visibility
- Built-in cell formatters
- Action button integration

**Usage:**
```dart
MbxUserTableWidget(
  users: controller.users,
  isLoading: controller.isLoading.value,
  visibleColumns: [
    MbxUserColumnType.name,
    MbxUserColumnType.phone,
    MbxUserColumnType.balance,
    MbxUserColumnType.status,
  ],
  actionBuilder: (user) => MbxUserTableActionBuilders.buildStandardActions(
    user,
    onTopup: () => _topupUser(user),
    onAdjust: () => _adjustUser(user),
    onHistory: () => _viewBalanceHistory(user),
    onView: () => _viewUser(user),
  ),
  onRowTap: (user) => () => _viewUser(user),
)
```

**Available Column Types:**
- `MbxUserColumnType.name` - User name with styling
- `MbxUserColumnType.phone` - Phone number
- `MbxUserColumnType.accountNumber` - Masked account number
- `MbxUserColumnType.balance` - Formatted balance with currency
- `MbxUserColumnType.status` - Status with colored chip
- `MbxUserColumnType.createdAt` - Creation date
- `MbxUserColumnType.updatedAt` - Last update date

### MbxUserTableActionBuilders
Predefined action button builders for user tables.

**Location:** `lib/widget-x/mbx_user_table_actions.dart`

**Available Action Sets:**
```dart
// Standard actions: topup, adjust, history, view
MbxUserTableActionBuilders.buildStandardActions(user, ...)

// View only
MbxUserTableActionBuilders.buildViewOnlyActions(user, ...)

// Financial actions only: topup and adjust
MbxUserTableActionBuilders.buildFinancialActions(user, ...)

// Custom actions
MbxUserTableActionBuilders.buildCustomActions([...])
```

### MbxUserTableCellBuilders
Reusable cell builders for consistent formatting.

**Available Builders:**
- `buildNameCell()` - Styled name display
- `buildBalanceCell()` - Currency formatted balance
- `buildStatusCell()` - Colored status chip
- `buildDateCell()` - Formatted date display
- `buildAccountNumberCell()` - Masked account number

## Admin Management Components

### MbxAdminTableWidget
A specialized table widget for displaying admin data.

**Location:** `lib/widget-x/mbx_admin_table_widget.dart`

**Usage:**
```dart
MbxAdminTableWidget(
  admins: controller.admins,
  isLoading: controller.isLoading.value,
  actionBuilder: (admin) => MbxAdminTableActionBuilders.buildStandardActions(
    admin,
    onView: () => controller.viewAdmin(admin),
    onEdit: () => controller.showEditAdminDialog(admin),
    onDelete: () => controller.deleteAdmin(admin),
  ),
  onRowTap: (admin) => () => controller.viewAdmin(admin),
)
```

**Available Column Types:**
- `MbxAdminColumnType.name` - Admin name with avatar
- `MbxAdminColumnType.email` - Email address
- `MbxAdminColumnType.role` - Role with colored chip
- `MbxAdminColumnType.status` - Status with colored chip
- `MbxAdminColumnType.createdAt` - Creation date
- `MbxAdminColumnType.lastLogin` - Last login date

### MbxAdminTableActionBuilders
Predefined action button builders for admin tables.

**Location:** `lib/widget-x/mbx_admin_table_actions.dart`

**Available Action Sets:**
```dart
// Standard actions: view, edit, delete
MbxAdminTableActionBuilders.buildStandardActions(admin, ...)

// View only
MbxAdminTableActionBuilders.buildViewOnlyActions(admin, ...)

// Management actions: edit and delete
MbxAdminTableActionBuilders.buildManagementActions(admin, ...)

// Custom actions
MbxAdminTableActionBuilders.buildCustomActions([...])
```

### MbxAdminTableCellBuilders
Reusable cell builders for admin data.

**Available Builders:**
- `buildNameCell()` - Name with avatar
- `buildRoleCell()` - Colored role chip
- `buildStatusCell()` - Colored status chip
- `buildDateCell()` - Formatted date display

## Usage Examples

### Basic User Table
```dart
class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        return Scaffold(
          body: MbxUserTableWidget(
            users: controller.users,
            isLoading: controller.isLoading.value,
            actionBuilder: (user) => [
              IconButton(
                onPressed: () => _viewUser(user),
                icon: Icon(Icons.visibility),
                tooltip: 'View',
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Custom Column Configuration
```dart
MbxUserTableWidget(
  users: users,
  visibleColumns: [
    MbxUserColumnType.name,
    MbxUserColumnType.accountNumber,
    MbxUserColumnType.balance,
    MbxUserColumnType.createdAt,
  ],
  // ... other properties
)
```

### Admin Table with Custom Actions
```dart
MbxAdminTableWidget(
  admins: admins,
  actionBuilder: (admin) => [
    IconButton(
      onPressed: () => _activateAdmin(admin),
      icon: Icon(admin.isActive ? Icons.pause : Icons.play_arrow),
      tooltip: admin.isActive ? 'Deactivate' : 'Activate',
    ),
    IconButton(
      onPressed: () => _resetPassword(admin),
      icon: Icon(Icons.lock_reset),
      tooltip: 'Reset Password',
    ),
  ],
)
```

## Migration Guide

### Migrating Existing Tables

**Before (Manual Implementation):**
```dart
MbxDataTableWidget(
  columns: [
    MbxDataColumn(
      key: 'name',
      label: 'Name',
      customWidget: (data) => _buildNameCell(data),
    ),
    // ... more columns
  ],
  rows: users.map((user) => MbxDataRow(
    // ... manual row building
  )).toList(),
)
```

**After (Reusable Component):**
```dart
MbxUserTableWidget(
  users: users,
  visibleColumns: [MbxUserColumnType.name, ...],
  actionBuilder: (user) => MbxUserTableActionBuilders.buildStandardActions(user, ...),
)
```

### Benefits of Migration

1. **Consistency** - All tables use the same styling and behavior
2. **Maintainability** - Changes to table appearance only need to be made in one place
3. **Reusability** - Easy to create new management screens
4. **Type Safety** - Compile-time checking for column types and data
5. **Feature Rich** - Built-in sorting, filtering, pagination, and actions

## Extending the Components

### Adding New Column Types

1. Add new enum value to `MbxUserColumnType` or `MbxAdminColumnType`
2. Implement column configuration in `_buildColumns()`
3. Add cell data mapping in `_buildCells()`
4. Create cell builder if custom formatting is needed

### Adding New Action Sets

1. Create new static method in the appropriate action builder class
2. Return list of configured widgets
3. Follow consistent styling patterns

### Creating New Specialized Tables

1. Create new table widget extending the base pattern
2. Define column enum for the data type
3. Implement cell builders for custom formatting
4. Create action builders for common operations
5. Add exports to `all_widgets.dart`

## File Structure

```
lib/widget-x/
├── mbx_data_table_widget.dart       # Core table widget
├── mbx_table_header.dart            # Table header component
├── mbx_table_body.dart              # Table body component
├── mbx_sticky_table.dart            # Sticky table implementation
├── mbx_user_table_widget.dart       # User table specialization
├── mbx_user_table_actions.dart      # User action builders
├── mbx_admin_table_widget.dart      # Admin table specialization
├── mbx_admin_table_actions.dart     # Admin action builders
└── all_widgets.dart                 # Export file
```

## Future Enhancements

- **Search Integration** - Built-in search functionality
- **Filter Components** - Reusable filter panels
- **Export Features** - CSV/Excel export capabilities
- **Bulk Actions** - Multi-select and bulk operations
- **Virtual Scrolling** - Performance optimization for large datasets
- **Column Resize** - User-configurable column widths
- **Column Reorder** - Drag-and-drop column reordering
