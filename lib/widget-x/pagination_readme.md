# MBanking BackOffice - Pagination Components

This project includes comprehensive and reusable pagination components that can be used across all management screens.

## Components

### 1. MbxPaginationWidget
A complete, responsive pagination widget with the following features:
- Desktop: Full pagination with page numbers, navigation buttons, and item counts
- Mobile: Compact pagination with previous/next buttons and page info
- Dark mode support
- Accessibility features (tooltips, proper contrast)

### 2. MbxPaginationMixin
A mixin that provides standard pagination functionality for controllers, including:
- State management for current page, total pages, total items
- Navigation methods (next, previous, first, last, goToPage)
- Loading state management
- Helper methods for pagination calculations

## Usage

### Basic Implementation

1. **Controller with Pagination Mixin:**
```dart
class MyController extends GetxController with MbxPaginationMixin {
  
  @override
  void onPageChanged() {
    // Implement your data fetching logic here
    fetchData();
  }
  
  void fetchData() async {
    setLoading(true);
    
    // Your API call logic
    final response = await apiService.getData(
      page: currentPage,
      perPage: perPage,
    );
    
    // Update pagination state
    updatePaginationState(
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      totalItems: response.totalItems,
      perPage: response.perPage,
    );
    
    setLoading(false);
  }
}
```

2. **UI Implementation:**
```dart
// In your widget's build method
Column(
  children: [
    // Your content here (table, list, etc.)
    Expanded(
      child: YourContentWidget(),
    ),
    
    // Pagination - only show if needed
    if (controller.shouldShowPagination)
      Obx(
        () => MbxPaginationWidget(
          currentPage: controller.currentPage,
          totalPages: controller.totalPages,
          totalItems: controller.totalItems,
          itemsPerPage: controller.perPage,
          onPrevious: controller.previousPage,
          onNext: controller.nextPage,
          onFirst: controller.firstPage,
          onLast: controller.lastPage,
          onPageChanged: controller.goToPage,
        ),
      ),
  ],
)
```

### Advanced Features

#### Custom Items Per Page
```dart
// In your controller
void changeItemsPerPage(int newPerPage) {
  setPerPage(newPerPage); // Automatically resets to page 1 and calls onPageChanged
}
```

#### Pagination State Helpers
```dart
// Check if pagination should be shown
if (controller.shouldShowPagination) {
  // Show pagination widget
}

// Check if there are any items
if (controller.hasItems) {
  // Show content
} else {
  // Show empty state
}

// Get item range for current page
Text('Showing ${controller.startItem}-${controller.endItem} of ${controller.totalItems} items')
```

## Implementation Status

✅ **User Management Screen** - Already implemented with MbxPaginationWidget
✅ **Transaction Management Screen** - Already implemented with MbxPaginationWidget  
✅ **Admin Management Screen** - Already implemented with MbxPaginationWidget
✅ **Admin Management Screen (Old)** - Updated to use MbxPaginationWidget

## Benefits

1. **Consistency** - All screens use the same pagination UI and behavior
2. **Responsive** - Automatically adapts to mobile and desktop layouts
3. **Accessible** - Proper tooltips, contrast, and keyboard navigation
4. **Dark Mode** - Full dark mode support with proper theming
5. **Maintainable** - Single source of truth for pagination logic
6. **Flexible** - Easy to customize and extend for specific needs

## Customization

The components are designed to be easily customizable:
- Colors and themes automatically adapt to the app's color scheme
- Spacing and sizing can be adjusted via the widget parameters
- Additional functionality can be added by extending the mixin

## Performance

- Uses GetX reactive programming for efficient UI updates
- Only rebuilds necessary parts when pagination state changes
- Minimal memory footprint with proper state management
