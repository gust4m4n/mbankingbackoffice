# Admin Detail Screen

## Overview
The Admin Detail Screen (`MbxAdminDetailScreen`) provides a comprehensive view of admin information in the mbanking back office application.

## Features

### 1. Profile Header
- Large avatar with admin initial
- Admin name and email
- Status and role chips  
- Admin ID badge

### 2. Information Cards
- **Basic Information**: Name, email, and ID
- **Role & Status**: Visual indicators for admin role and current status
- **Activity Information**: Creation date, last update, and last login

### 3. Action Buttons
- Edit Admin
- Activate/Suspend
- Reset Password  
- Delete Admin

### 4. Dark Mode Support
- Fully responsive to light/dark theme changes
- Theme-aware colors and shadows
- Consistent with app design system

## Navigation

### From Admin Management Screen
The detail screen is accessed by clicking the "View" button (eye icon) in the admin management table.

```dart
// In MbxSimpleAdminController
void viewAdmin(MbxAdminModel admin) {
  Get.to(() => MbxAdminDetailScreen(admin: admin));
}
```

### Back Navigation
The screen includes a back button in the top bar that returns to the previous screen.

## File Structure

- **Screen**: `lib/admin/views/mbx_admin_detail_screen.dart`
- **Model**: `lib/admin/models/mbx_admin_model.dart`
- **Controller**: `lib/admin/controllers/mbx_simple_admin_controller.dart`

## Key Components

### MbxAdminModel Properties
- `id`: Admin ID
- `name`: Full name
- `email`: Email address
- `role`: Admin role (admin/super_admin)
- `status`: Current status (active/inactive/suspended)
- `createdAt`: Account creation timestamp
- `updatedAt`: Last update timestamp
- `lastLoginAt`: Last login timestamp

### Helper Methods
- `isActive`: Boolean for active status
- `isSuperAdmin`: Boolean for super admin role
- `displayRole`: Formatted role name
- `displayStatus`: Formatted status name

## Action Buttons (Placeholder)
Currently, all action buttons show "feature akan segera tersedia" (feature coming soon) messages. These can be implemented by:

1. Adding corresponding methods to the controller
2. Implementing API calls for each action
3. Adding proper confirmation dialogs
4. Updating the UI based on action results

## Usage Example

```dart
// Navigate to admin detail
final admin = MbxAdminModel(
  id: 1,
  name: "John Doe",
  email: "john@example.com",
  role: "admin",
  status: "active",
);

Get.to(() => MbxAdminDetailScreen(admin: admin));
```

## Styling
The screen follows the app's design system with:
- Consistent card layouts
- Proper spacing and typography
- Theme-aware colors
- Material Design principles
- Responsive design for different screen sizes
