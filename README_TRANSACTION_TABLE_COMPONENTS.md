# Transaction Table Components Documentation

## Overview
This document describes the reusable transaction table components created for the MBanking BackOffice application. These components follow the same design pattern as the user table components and provide a consistent, maintainable approach to displaying transaction data.

## Components

### 1. MbxTransactionTableWidget
**File:** `lib/widget-x/mbx_transaction_table_widget.dart`

A reusable transaction table widget that displays transaction data with predefined columns and formatting.

#### Key Features:
- **Predefined Column Types**: Enum-based column configuration for type safety
- **Custom Cell Builders**: Specialized rendering for different data types
- **Flexible Column Selection**: Choose which columns to display
- **Action Integration**: Support for row actions via action builders
- **Consistent Styling**: Follows the same design patterns as user tables
- **Loading States**: Built-in loading indicator support
- **Empty States**: Customizable empty state messages and icons

#### Available Column Types:
```dart
enum MbxTransactionColumnType {
  id,              // Transaction ID
  type,            // Transaction type with colored chip
  userName,        // User name with masked account number
  amount,          // Formatted amount with currency
  status,          // Status with colored chip
  date,            // Formatted creation date
  description,     // Transaction description
  balanceBefore,   // Balance before transaction
  balanceAfter,    // Balance after transaction
}
```

#### Usage Example:
```dart
MbxTransactionTableWidget(
  transactions: controller.transactions,
  isLoading: controller.isLoading.value,
  enableSorting: false,
  visibleColumns: [
    MbxTransactionColumnType.id,
    MbxTransactionColumnType.type,
    MbxTransactionColumnType.userName,
    MbxTransactionColumnType.amount,
    MbxTransactionColumnType.status,
    MbxTransactionColumnType.date,
  ],
  actionBuilder: (transaction) =>
      MbxTransactionTableActionBuilders.buildStandardActions(
        transaction,
        onView: () => _viewTransaction(transaction),
        onDownload: () => _downloadReceipt(transaction),
      ),
  onRowTap: (transaction) => () => _viewTransaction(transaction),
)
```

### 2. MbxTransactionTableCellBuilders
**File:** `lib/widget-x/mbx_transaction_table_widget.dart` (included in same file)

Static class containing specialized cell builders for transaction data.

#### Available Builders:
- **buildTypeCell()**: Renders transaction type with colored background chip
- **buildUserCell()**: Displays user name and masked account number in two lines
- **buildAmountCell()**: Formats and displays currency amounts with consistent styling
- **buildStatusCell()**: Shows transaction status with appropriate color coding
- **buildBalanceCell()**: Formats balance amounts for before/after columns

#### Styling Features:
- **Color Coding**: Different colors for transaction types and statuses
- **Typography**: Consistent font weights and sizes
- **Alignment**: Proper text alignment for different data types
- **Overflow Handling**: Ellipsis for long text content

### 3. MbxTransactionTableActionBuilders
**File:** `lib/widget-x/mbx_transaction_table_action_builders.dart`

Provides pre-configured action button combinations for different transaction management scenarios.

#### Available Action Sets:

##### buildStandardActions()
Standard actions for most transaction scenarios:
- View transaction details
- Download receipt
- Refund (for completed transactions)
- Reverse (for completed, non-reversed transactions)

##### buildViewOnlyActions()
Read-only actions for restricted scenarios:
- View transaction details
- Download receipt

##### buildMinimalActions()
Minimal action set for compact displays:
- View transaction details only

##### buildCustomActions()
Dynamic actions based on transaction status:
- **Pending**: Approve, Reject, View
- **Failed**: Retry, View, Download
- **Completed**: Download, View
- **Others**: View, Download (if available)

#### Usage Examples:
```dart
// Standard actions
actionBuilder: (transaction) =>
    MbxTransactionTableActionBuilders.buildStandardActions(
      transaction,
      onView: () => _viewTransaction(transaction),
      onDownload: () => _downloadReceipt(transaction),
      onRefund: () => _refundTransaction(transaction),
    ),

// Custom actions based on status
actionBuilder: (transaction) =>
    MbxTransactionTableActionBuilders.buildCustomActions(
      transaction,
      onView: () => _viewTransaction(transaction),
      onApprove: () => _approveTransaction(transaction),
      onReject: () => _rejectTransaction(transaction),
      onRetry: () => _retryTransaction(transaction),
    ),
```

## Integration Pattern

### Transaction Management Screen Structure
The transaction management screen now follows the same structure as user management:

1. **MbxManagementScaffold**: Consistent scaffold with navigation
2. **MbxManagementHeader**: Standard header with optional search
3. **Container Layout**: Card-based container with rounded corners
4. **MbxTransactionTableWidget**: Reusable table component
5. **MbxPaginationWidget**: Consistent pagination controls

### Migration Benefits
- **Code Reusability**: Shared table logic across different screens
- **Consistent UI**: Same look and feel as user management
- **Maintainability**: Centralized table logic and styling
- **Type Safety**: Enum-based column configuration prevents runtime errors
- **Extensibility**: Easy to add new column types and cell builders

## Color Scheme

### Transaction Types:
- **Transfer**: Blue (`Colors.blue`)
- **Topup**: Green (`Colors.green`)
- **Withdraw**: Orange (`Colors.orange`)
- **Reversal**: Purple (`Colors.purple`)
- **Default**: Grey (`Colors.grey`)

### Transaction Status:
- **Completed**: Green (`Colors.green`)
- **Pending**: Orange (`Colors.orange`)
- **Failed/Cancelled**: Red (`Colors.red`)
- **Reversed**: Purple (`Colors.purple`)
- **Default**: Grey (`Colors.grey`)

## Best Practices

### When to Use:
- ✅ All transaction listing screens
- ✅ Transaction search results
- ✅ Transaction history displays
- ✅ Transaction management interfaces

### Configuration Tips:
- Use `enableSorting: false` for read-only displays
- Select appropriate `visibleColumns` based on screen space
- Choose action builders based on user permissions
- Customize empty states for better user experience

### Performance Considerations:
- The widget uses Obx for reactive updates
- Large transaction lists are handled efficiently
- Action builders are called only when needed
- Cell builders cache formatting when possible

## Future Enhancements

Potential improvements for the transaction table components:
1. **Advanced Filtering**: Built-in filter controls for transaction types and status
2. **Export Functionality**: Built-in export to CSV/Excel capabilities
3. **Bulk Actions**: Support for selecting and acting on multiple transactions
4. **Real-time Updates**: WebSocket integration for live transaction updates
5. **Advanced Search**: Full-text search within transaction data
6. **Custom Column Widths**: User-configurable column sizing
7. **Column Reordering**: Drag-and-drop column reordering functionality
