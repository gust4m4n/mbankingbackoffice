# User Management Search & Filter Feature

## Overview
Fitur search dan filter untuk user management telah berhasil ditambahkan ke aplikasi MBanking BackOffice. Fitur ini memungkinkan admin untuk mencari dan memfilter user berdasarkan berbagai kriteria.

## Features Added

### 1. Updated API Service (`MbxUserApiService`)
- **Endpoint**: Updated from `/api/users` to `/api/admin/users`
- **New Parameters**:
  - `search`: Search across name and phone
  - `name`: Filter by user name
  - `phone`: Filter by phone number  
  - `status`: Filter by user status

### 2. Enhanced User Controller (`MbxUserController`)
- **New Properties**:
  - `searchController`: TextEditingController for search input
  - `nameFilterController`: TextEditingController for name filter
  - `phoneFilterController`: TextEditingController for phone filter
  - `selectedStatus`: Observable for status filter
  - `isFilterActive`: Observable to track if any filter is applied
  - `statusOptions`: List of available status options

- **New Methods**:
  - `searchUsers()`: Execute search with current search term
  - `clearSearchAndFilters()`: Clear all search and filter inputs
  - `applyFilters()`: Apply current filter settings
  - `_checkFilterStatus()`: Check if any filter is currently active

### 3. Search Filter Widget (`MbxUserSearchFilterWidget`)
- **Components**:
  - Search input field with real-time search capability
  - Search button for manual search trigger
  - Clear button (shown only when filters are active)
  - Responsive design for dark/light themes

### 4. Updated User Management Screen
- Integrated search filter widget at the top of the user table
- Maintains existing functionality while adding search capability

## API Integration

The feature uses the admin API endpoint with the following parameters as documented in Postman:

```
GET /api/admin/users?page={{user_page}}&per_page={{user_per_page}}&search={{user_search}}&name={{user_name_filter}}&phone={{user_phone_filter}}&status={{user_status_filter}}
```

### Parameters:
- `page`: Page number (default: 1)
- `per_page`: Items per page (default: 10, max: 100)
- `search`: Search across name and phone
- `name`: Filter by user name
- `phone`: Filter by phone number
- `status`: Filter by user status

## Usage

### For Users:
1. Navigate to User Management screen
2. Use the search bar to search by name or phone
3. Click "Search" button or press Enter to execute search
4. Use "Clear" button to reset search and return to full user list

### For Developers:
```dart
// Initialize the controller (automatically done in User Management screen)
final controller = Get.put(MbxUserController());

// Programmatically search
controller.searchController.text = "john";
controller.searchUsers();

// Clear all filters
controller.clearSearchAndFilters();

// Check if filters are active
if (controller.isFilterActive.value) {
  // Filters are currently applied
}
```

## Technical Implementation

### Service Layer
```dart
// Updated API call with search parameters
static Future<ApiXResponse> getUsers({
  int page = 1,
  int perPage = 10,
  String? search,
  String? name,
  String? phone,
  String? status,
}) async {
  // Implementation includes all filter parameters
}
```

### Controller Layer
```dart
// Enhanced loadUsers method
Future<void> loadUsers({
  int page = 1,
  String? search,
  String? name,
  String? phone,
  String? status,
}) async {
  // Loads users with search and filter parameters
}
```

### UI Layer
```dart
// Search widget integration
MbxUserSearchFilterWidget(controller: controller)
```

## Future Enhancements

The current implementation provides a solid foundation for additional filter features:

1. **Advanced Filters** (can be added later):
   - Date range filters (registration date, last login)
   - Balance range filters
   - Account type filters
   - Multiple status selection

2. **Search Improvements**:
   - Search by account number
   - Search by email
   - Fuzzy search capabilities

3. **UI Enhancements**:
   - Expandable advanced filter panel
   - Filter chips showing active filters
   - Save/load filter presets

## Files Modified/Created

### Modified Files:
1. `/lib/user/services/mbx_user_api_service.dart`
   - Updated `getUsers()` method with search parameters
   - Changed endpoint to admin API

2. `/lib/user/controllers/mbx_user_controller.dart`
   - Added search and filter controllers
   - Added filter state management
   - Enhanced `loadUsers()` method
   - Added search/filter methods

3. `/lib/user/views/mbx_user_management_screen.dart`
   - Integrated search filter widget
   - Updated layout structure

### New Files:
1. `/lib/user/views/widgets/mbx_user_search_filter_widget.dart`
   - Complete search and filter UI component
   - Responsive design for dark/light themes
   - Real-time search capability

## Testing

The feature should be tested with:
1. Search functionality with various terms
2. Empty search (should return all users)
3. Special characters in search
4. Large datasets (pagination with search)
5. API error handling
6. Dark/light theme compatibility

## Notes

- The implementation follows the existing code patterns in the project
- All search parameters are optional and backward compatible
- The UI is responsive and supports both dark and light themes
- Error handling is implemented following the existing patterns
- The feature integrates seamlessly with existing pagination
