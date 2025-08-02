# MbxDialogController - Reusable Dialog System

## Overview

`MbxDialogController` adalah controller yang dapat direuse untuk semua popup/dialog di aplikasi MBanking BackOffice. Controller ini menyediakan berbagai jenis dialog yang konsisten dan mudah digunakan.

## Features

✅ **Confirmation Dialog** - Dialog konfirmasi dengan custom action  
✅ **Info Dialog** - Dialog informasi umum  
✅ **Success Dialog** - Dialog sukses dengan icon hijau  
✅ **Error Dialog** - Dialog error dengan icon merah  
✅ **Warning Dialog** - Dialog warning dengan icon orange  
✅ **Loading Dialog** - Dialog loading dengan spinner  
✅ **Custom Dialog** - Dialog dengan widget kustom  
✅ **Bottom Sheet** - Bottom sheet dialog  
✅ **Predefined Dialogs** - Logout, delete, feature not available  

## Setup

Controller sudah didaftarkan di `main.dart`:

```dart
// Initialize dialog controller
Get.put(MbxDialogController(), permanent: true);
```

## Usage Examples

### 1. Confirmation Dialog

```dart
final confirmed = await MbxDialogController.showConfirmationDialog(
  title: 'Konfirmasi Hapus',
  message: 'Apakah Anda yakin ingin menghapus data ini?',
  confirmText: 'Hapus',
  cancelText: 'Batal',
  confirmColor: Colors.red,
  icon: Icons.delete_forever,
);

if (confirmed == true) {
  // User confirmed
  print('User confirmed deletion');
}
```

### 2. Success Dialog

```dart
await MbxDialogController.showSuccessDialog(
  title: 'Berhasil',
  message: 'Data berhasil disimpan',
  onPressed: () {
    // Optional callback setelah user tap OK
    Get.back();
  },
);
```

### 3. Error Dialog

```dart
await MbxDialogController.showErrorDialog(
  title: 'Error',
  message: 'Terjadi kesalahan saat menyimpan data',
  onPressed: () {
    // Optional callback
  },
);
```

### 4. Loading Dialog

```dart
// Show loading
MbxDialogController.showLoadingDialog(
  message: 'Menyimpan data...',
);

// Simulate async operation
await Future.delayed(Duration(seconds: 2));

// Hide loading
MbxDialogController.hideLoadingDialog();
```

### 5. Custom Dialog

```dart
final result = await MbxDialogController.showCustomDialog<String>(
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Custom Dialog Content'),
      TextField(
        decoration: InputDecoration(labelText: 'Input'),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Get.back(result: 'cancel'),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: 'ok'),
            child: Text('OK'),
          ),
        ],
      ),
    ],
  ),
);

print('User result: $result');
```

### 6. Bottom Sheet Dialog

```dart
final result = await MbxDialogController.showBottomSheetDialog<String>(
  content: Container(
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Bottom Sheet Content'),
        // ... more widgets
      ],
    ),
  ),
);
```

### 7. Predefined Dialogs

#### Logout Confirmation
```dart
final confirmed = await MbxDialogController.showLogoutConfirmation();
if (confirmed == true) {
  // Proceed with logout
}
```

#### Delete Confirmation
```dart
final confirmed = await MbxDialogController.showDeleteConfirmation('user John Doe');
if (confirmed == true) {
  // Proceed with deletion
}
```

#### Feature Not Available
```dart
MbxDialogController.showFeatureNotAvailable('Reports');
```

## Dialog Types

### Information Types
- `showInfoDialog()` - General info with blue theme
- `showSuccessDialog()` - Success with green check icon
- `showErrorDialog()` - Error with red error icon  
- `showWarningDialog()` - Warning with orange warning icon

### Interactive Types
- `showConfirmationDialog()` - Returns true/false
- `showCustomDialog<T>()` - Returns custom type T
- `showBottomSheetDialog<T>()` - Returns custom type T

### Utility Types
- `showLoadingDialog()` / `hideLoadingDialog()` - Loading state
- `showLogoutConfirmation()` - Predefined logout
- `showDeleteConfirmation()` - Predefined delete
- `showFeatureNotAvailable()` - Predefined feature unavailable

## Implementation Examples

### In User Management
```dart
// Delete user
final confirmed = await MbxDialogController.showDeleteConfirmation('user ${user.name}');
if (confirmed == true) {
  MbxDialogController.showLoadingDialog(message: 'Deleting user...');
  
  try {
    await userController.deleteUser(user.id);
    MbxDialogController.hideLoadingDialog();
    
    await MbxDialogController.showSuccessDialog(
      title: 'Berhasil',
      message: 'User berhasil dihapus',
    );
  } catch (e) {
    MbxDialogController.hideLoadingDialog();
    
    await MbxDialogController.showErrorDialog(
      title: 'Error',
      message: 'Gagal menghapus user: $e',
    );
  }
}
```

### In Form Validation
```dart
void validateAndSave() async {
  if (!_formKey.currentState!.validate()) {
    await MbxDialogController.showWarningDialog(
      title: 'Validasi Gagal',
      message: 'Mohon lengkapi semua field yang wajib diisi',
    );
    return;
  }
  
  // Proceed with save
  _save();
}
```

## Benefits

✅ **Consistent UI** - Semua dialog menggunakan style yang sama  
✅ **Reusable** - Dapat digunakan di seluruh aplikasi  
✅ **Type Safe** - Generic return types untuk custom dialogs  
✅ **Easy to Use** - Static methods, tidak perlu instantiate  
✅ **Customizable** - Support custom colors, icons, actions  
✅ **Responsive** - Otomatis adapt dengan theme (dark/light mode)  
✅ **Loading State** - Built-in loading dialog management  
✅ **Predefined** - Common dialogs sudah tersedia (logout, delete, etc)  

## Migration from Old Dialogs

### Before (Old Way)
```dart
Get.dialog(
  AlertDialog(
    title: Text('Konfirmasi'),
    content: Text('Apakah Anda yakin?'),
    actions: [
      TextButton(onPressed: () => Get.back(), child: Text('Batal')),
      ElevatedButton(onPressed: () => Get.back(result: true), child: Text('Ya')),
    ],
  ),
);
```

### After (New Way)
```dart
final confirmed = await MbxDialogController.showConfirmationDialog(
  title: 'Konfirmasi',
  message: 'Apakah Anda yakin?',
);
```

## Next Steps

1. **Migrate existing dialogs** - Replace manual Get.dialog calls
2. **Add new dialog types** - Extend controller for specific needs
3. **Add animations** - Custom entrance/exit animations
4. **Add keyboard shortcuts** - ESC to close, Enter to confirm
5. **Add accessibility** - Screen reader support
