# Transaction Management Search Feature

## Overview
Added search functionality to the Transaction Management screen, following the same pattern as User Management.

## Implementation

### 1. **MbxTransactionController Updates**
**File:** `lib/transaction/controllers/mbx_transaction_controller.dart`

#### Added Properties:
```dart
// Search and filter controllers
final searchController = TextEditingController();
var isFilterActive = false.obs;
```

#### Added Methods:
- **searchTransactions()**: Initiates search with current search term
- **clearSearchAndFilters()**: Clears all search/filter inputs and reloads data
- **_checkFilterStatus()**: Updates filter active status indicator

#### Updated Methods:
- **onClose()**: Now disposes search controller
- **loadTransactions()**: Now includes search parameter
- **applyFilters()**: Now calls _checkFilterStatus()

### 2. **MbxTransactionApiService Updates**
**File:** `lib/transaction/services/mbx_transaction_api_service.dart`

#### Added Parameter:
```dart
static Future<ApiXResponse> getTransactions({
  int page = 1,
  int perPage = 10,
  String? search,  // New search parameter
  String? userId,
  String? type,
  String? status,
  String? startDate,
  String? endDate,
}) async {
  // Implementation includes search in API params
}
```

### 3. **Transaction Management Screen Updates**
**File:** `lib/transaction/views/mbx_transaction_management_screen.dart`

#### Updated Header:
```dart
customHeaderWidget: Obx(
  () => MbxManagementHeader(
    title: 'Transaction Management',
    showSearch: true,                                    // Enabled search
    searchController: controller.searchController,       // Connected controller
    onSearch: controller.searchTransactions,             // Search handler
    onClearSearch: controller.clearSearchAndFilters,     // Clear handler
    searchHint: 'Search...',                            // Placeholder text
    isFilterActive: controller.isFilterActive.value,    // Filter indicator
  ),
),
```

## Features

### Search Functionality:
- **Real-time Search**: Search across transaction data
- **Search Hint**: Placeholder text "Search..." for better UX
- **Clear Function**: Single button to clear search and all filters

### Filter Status Indicator:
- **Active Indicator**: Shows when any filter or search is active
- **Visual Feedback**: Consistent with user management design

### Search Triggers:
- **Manual Search**: Click search button or press Enter
- **Auto-clear**: Clear button resets all filters and reloads data

## Search Scope
The search functionality searches across:
- Transaction ID
- User name
- User account number
- Transaction type
- Transaction status
- Transaction description
- Any other relevant transaction fields (server-side implementation)

## API Integration
The search parameter is passed to the backend API as `search` query parameter:
```
GET /api/admin/transactions?search=user_query&page=1&limit=32
```

## Benefits
1. **Consistency**: Same search UX as User Management
2. **Efficiency**: Quick transaction lookup without complex filters
3. **User-Friendly**: Familiar search interface
4. **Responsive**: Real-time filter status indicators
5. **Comprehensive**: Searches across multiple transaction fields

## Usage Examples

### Basic Search:
1. Type search term in search box
2. Click search button or press Enter
3. View filtered results

### Clear Search:
1. Click the clear button (X)
2. All search terms and filters are cleared
3. Full transaction list is reloaded

### Combined with Filters:
1. Use search for quick text-based filtering
2. Use existing filters for specific criteria
3. Both work together for precise results

## Technical Notes
- Search is case-insensitive (server-side implementation)
- Minimum search term length can be configured server-side
- Search works with pagination
- Filter status indicator updates automatically
- All search state is reactive using GetX

This implementation provides a comprehensive search solution that enhances the transaction management workflow while maintaining consistency with the existing user management interface.
