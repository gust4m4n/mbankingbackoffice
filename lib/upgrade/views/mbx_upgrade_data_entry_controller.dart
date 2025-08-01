import '../../widget-x/all_widgets.dart';
import '../services/upgrade_data_service.dart';

class MbxUpgradeDataEntryController extends GetxController {
  final fullNameController = TextEditingController();
  final fullNameNode = FocusNode();

  final idNumberController = TextEditingController();
  final idNumberNode = FocusNode();

  final addressController = TextEditingController();
  final addressNode = FocusNode();

  var dateOfBirth = '';
  var gender = '';

  btnBackClicked() {
    Get.back();
  }

  fullNameChanged(String value) {
    print('Full name changed: $value');
    update();
  }

  idNumberChanged(String value) {
    print('ID number changed: $value');
    update();
  }

  addressChanged(String value) {
    print('Address changed: $value');
    update();
  }

  btnDateOfBirthClicked() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateOfBirth =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      update();
    }
  }

  selectGender(String selectedGender) {
    gender = selectedGender;
    update();
  }

  bool isFormValid() {
    print('Form validation check:');
    print('Full name: ${fullNameController.text}');
    print('ID number: ${idNumberController.text}');
    print('Date of birth: $dateOfBirth');
    print('Gender: $gender');
    print('Address: ${addressController.text}');

    bool isValid =
        fullNameController.text.isNotEmpty &&
        idNumberController.text.isNotEmpty &&
        dateOfBirth.isNotEmpty &&
        gender.isNotEmpty &&
        addressController.text.isNotEmpty;

    print('Form is valid: $isValid');
    return isValid;
  }

  btnContinueClicked() {
    print('Continue button clicked');
    if (!isFormValid()) {
      print('Form is not valid');
      return;
    }

    print('Saving personal data...');
    // Save personal data to service
    UpgradeDataService.instance.savePersonalData(
      fullName: fullNameController.text,
      idNumber: idNumberController.text,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: addressController.text,
    );
    print('Navigating to confirmation screen...');
    Get.toNamed('/ekyc-confirmation-universal');
  }

  @override
  void onClose() {
    fullNameController.dispose();
    fullNameNode.dispose();
    idNumberController.dispose();
    idNumberNode.dispose();
    addressController.dispose();
    addressNode.dispose();
    super.onClose();
  }
}
