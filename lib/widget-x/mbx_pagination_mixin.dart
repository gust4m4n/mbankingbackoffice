import 'package:get/get.dart';

/// Mixin that provides standard pagination functionality for controllers
mixin MbxPaginationMixin on GetxController {
  final RxInt _currentPage = 1.obs;
  final RxInt _totalPages = 1.obs;
  final RxInt _totalItems = 0.obs;
  final RxInt _perPage = 10.obs;
  final RxBool _isLoading = false.obs;

  // Getters
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  int get totalItems => _totalItems.value;
  int get perPage => _perPage.value;
  bool get isLoading => _isLoading.value;

  // Reactive getters for UI binding
  RxInt get currentPageRx => _currentPage;
  RxInt get totalPagesRx => _totalPages;
  RxInt get totalItemsRx => _totalItems;
  RxInt get perPageRx => _perPage;
  RxBool get isLoadingRx => _isLoading;

  // Navigation methods
  void nextPage() {
    if (_currentPage.value < _totalPages.value) {
      _currentPage.value++;
      onPageChanged();
    }
  }

  void previousPage() {
    if (_currentPage.value > 1) {
      _currentPage.value--;
      onPageChanged();
    }
  }

  void firstPage() {
    if (_currentPage.value != 1) {
      _currentPage.value = 1;
      onPageChanged();
    }
  }

  void lastPage() {
    if (_currentPage.value != _totalPages.value) {
      _currentPage.value = _totalPages.value;
      onPageChanged();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= _totalPages.value && page != _currentPage.value) {
      _currentPage.value = page;
      onPageChanged();
    }
  }

  // Setters for updating pagination state
  void updatePaginationState({
    required int currentPage,
    required int totalPages,
    required int totalItems,
    int? perPage,
  }) {
    _currentPage.value = currentPage;
    _totalPages.value = totalPages;
    _totalItems.value = totalItems;
    if (perPage != null) {
      _perPage.value = perPage;
    }
  }

  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void setPerPage(int itemsPerPage) {
    _perPage.value = itemsPerPage;
    _currentPage.value = 1; // Reset to first page when changing items per page
    onPageChanged();
  }

  // Calculate pagination info
  int get startItem => ((_currentPage.value - 1) * _perPage.value) + 1;
  int get endItem => (_currentPage.value * _perPage.value > _totalItems.value)
      ? _totalItems.value
      : _currentPage.value * _perPage.value;

  // Reset pagination to initial state
  void resetPagination() {
    _currentPage.value = 1;
    _totalPages.value = 1;
    _totalItems.value = 0;
    _isLoading.value = false;
  }

  // Abstract method that subclasses should implement
  void onPageChanged();

  // Helper method to check if pagination should be shown
  bool get shouldShowPagination => _totalPages.value > 1;

  // Helper method to check if there are items
  bool get hasItems => _totalItems.value > 0;
}
