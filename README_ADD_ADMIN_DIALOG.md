# Add Admin Dialog

## Overview
The Add Admin Dialog (`MbxAddAdminDialog`) provides a modern, intuitive form interface for creating new administrator accounts in the mbanking back office application.

## ✨ Key Features

### 🎨 Modern Form Design
- **Clean, card-based layout** with rounded corners
- **Glass-morphism modal** with backdrop blur
- **Progressive disclosure** with organized sections
- **Visual feedback** for all interactions
- **Responsive design** for all screen sizes

### 📝 Comprehensive Form Fields
- **Full Name** - Text input with validation
- **Email Address** - Email input with format validation
- **Password** - Secure input with visibility toggle
- **Confirm Password** - Matching validation
- **Role Selection** - Radio-style role picker
- **Status Selection** - Active/Inactive status picker

### 🔒 Advanced Validation
- **Real-time validation** with error messages
- **Email format validation** with regex
- **Strong password requirements** (8+ chars, uppercase, lowercase, number)
- **Password confirmation** matching
- **Required field validation** for all inputs

### 🎯 User Experience
- **Tab navigation** between fields
- **Enter key submission** on last field
- **Loading states** during submission
- **Form disable** during processing
- **Success/error feedback** with toasts

## 🔧 Technical Implementation

### Form Structure
```dart
// Key components
final _formKey = GlobalKey<FormState>();
List<TextEditingController> controllers;
List<FocusNode> focusNodes;
String selectedRole/Status;
bool isSubmitting;
```

### Field Validation
```dart
// Email validation
final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

// Password validation  
RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value);

// Confirm password
value == _passwordController.text;
```

### Usage Pattern
```dart
// Static method for easy invocation
MbxAddAdminDialog.show(context);

// From controller
void showCreateAdminDialog() {
  MbxAddAdminDialog.show(Get.context!);
}
```

## 📱 Responsive Design

### Desktop (> 600px)
- Fixed width: 500px
- Full feature set
- Optimal spacing
- Keyboard navigation

### Mobile/Tablet (< 600px)
- Width: 90% of screen
- Touch-friendly inputs
- Scrollable content
- Optimized button sizes

## 🎨 Visual Design Elements

### Header Section
- **Icon indicator** with brand color background
- **Title and subtitle** for context
- **Close button** with loading state handling
- **Subtle border** separation

### Form Fields
- **Label above input** for clarity
- **Icon prefixes** for visual hierarchy
- **Placeholder text** for guidance
- **Error states** with red borders
- **Focus states** with brand color
- **Disabled states** during submission

### Selection Areas
- **Radio-style selection** with custom styling
- **Icon indicators** for each option
- **Visual feedback** for selected state
- **Color coding** for different roles/statuses

### Action Buttons
- **Cancel button** (outlined style)
- **Submit button** with loading spinner
- **Disabled states** during processing
- **Consistent spacing** and sizing

## 📋 Form Fields Details

### 1. Full Name
- **Required field** with minimum 2 characters
- **Text input** with person icon
- **Validation**: Non-empty, minimum length
- **Focus**: First field in tab order

### 2. Email Address
- **Required field** with email format validation
- **Email keyboard** on mobile
- **Validation**: Required, valid email format
- **Icon**: Email outline

### 3. Password
- **Required field** with strong password rules
- **Visibility toggle** for security/usability
- **Validation**: 8+ chars, mixed case, numbers
- **Icon**: Lock outline with eye toggle

### 4. Confirm Password
- **Required field** with matching validation
- **Separate visibility** toggle
- **Validation**: Must match password field
- **Submit**: Enter key triggers form submission

### 5. Role Selection
- **Admin** - Standard administrator access
- **Super Admin** - Full system access
- **Visual indicators** with icons
- **Default**: Admin role selected

### 6. Status Selection
- **Active** - Account enabled and functional
- **Inactive** - Account disabled
- **Visual indicators** with icons
- **Default**: Active status selected

## 🔄 Form Submission Process

### 1. Validation Phase
```dart
if (!_formKey.currentState!.validate()) {
  return; // Show validation errors
}
```

### 2. Loading State
```dart
setState(() => _isSubmitting = true);
// Disable form, show spinner
```

### 3. Data Collection
```dart
final adminData = {
  'name': _nameController.text.trim(),
  'email': _emailController.text.trim(),
  'password': _passwordController.text,
  'role': _selectedRole,
  'status': _selectedStatus,
};
```

### 4. API Integration (Placeholder)
```dart
// TODO: Implement actual API call
await adminApiService.createAdmin(adminData);
```

### 5. Success/Error Handling
```dart
// Success
Get.back();
ToastX.showSuccess(msg: 'Admin created successfully');

// Error
ToastX.showError(msg: 'Failed to create admin');
```

## 🎯 Validation Rules

### Name Validation
- ✅ **Required**: Must not be empty
- ✅ **Minimum length**: At least 2 characters
- ✅ **Trimming**: Automatic whitespace removal

### Email Validation
- ✅ **Required**: Must not be empty
- ✅ **Format**: Must match email regex pattern
- ✅ **Trimming**: Automatic whitespace removal

### Password Validation
- ✅ **Required**: Must not be empty
- ✅ **Length**: Minimum 8 characters
- ✅ **Complexity**: Must contain:
  - At least one uppercase letter
  - At least one lowercase letter
  - At least one number

### Confirm Password Validation
- ✅ **Required**: Must not be empty
- ✅ **Matching**: Must exactly match password field

## 🎨 Dark Mode Support

### Color Scheme
- **Background**: Card color with theme awareness
- **Text**: High contrast text colors
- **Borders**: Subtle borders with theme colors
- **Inputs**: Theme-aware background colors
- **Buttons**: Consistent brand colors

### Visual Elements
- **Shadows**: Adjusted opacity for dark theme
- **Icons**: Theme-aware color schemes
- **Selection states**: Consistent across themes

## 🔗 Integration Points

### Admin Management Screen
```dart
// Add button triggers dialog
onAddPressed: controller.showCreateAdminDialog,
```

### Admin Controller
```dart
void showCreateAdminDialog() {
  MbxAddAdminDialog.show(Get.context!);
}
```

### Toast Notifications
```dart
// Success message
ToastX.showSuccess(msg: 'Admin "Name" berhasil dibuat!');

// Error message  
ToastX.showError(msg: 'Gagal membuat admin: $error');
```

## 🚀 Future Enhancements

### API Integration
- Replace placeholder with actual admin creation API
- Add proper error handling for different scenarios
- Implement form data validation on backend

### Advanced Features
- **Avatar upload** for admin profile picture
- **Permission settings** for granular access control
- **Department assignment** for organizational structure
- **Temporary access** with expiration dates

### UX Improvements
- **Form auto-save** for draft functionality
- **Field suggestions** for common inputs
- **Batch creation** for multiple admins
- **Import from CSV** for bulk operations

## 📊 Technical Specifications

### Dependencies
- Flutter Material Design
- GetX for state management
- Form validation framework
- Toast notifications

### Performance
- **Lightweight rendering** with efficient widgets
- **Minimal rebuilds** with proper state management
- **Fast validation** with immediate feedback
- **Smooth animations** for state transitions

### Accessibility
- **Screen reader support** with semantic labels
- **Keyboard navigation** with proper tab order
- **High contrast** support for visibility
- **Touch targets** meeting minimum size requirements
