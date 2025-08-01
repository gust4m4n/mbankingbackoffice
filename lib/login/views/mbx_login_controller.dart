import 'package:mbankingbackoffice/language/views/mbx_language_controller.dart';
import 'package:mbankingbackoffice/language/views/mbx_language_sheet.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_admin_login_vm.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_login_otp_vm.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_login_pin_vm.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_onboarding_list_vm.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_profile_vm.dart';
import 'package:mbankingbackoffice/otp/views/mbx_otp_sheet.dart';
import 'package:mbankingbackoffice/pin/views/mbx_pin_sheet.dart';
import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:mbankingbackoffice/theme/viewmodels/mbx_theme_vm.dart';
import 'package:mbankingbackoffice/utils/logger_x.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'mbx_login_screen.dart';

class MbxLoginController extends GetxController {
  final PageController pageController = PageController();
  var onboardingVM = MbxOnboardingListVM();

  // Email and Password controllers for web admin
  final txtEmailController = TextEditingController();
  final txtEmailNode = FocusNode();
  final txtPasswordController = TextEditingController();
  final txtPasswordNode = FocusNode();

  // Phone controller (keeping for backward compatibility)
  final txtPhoneController = TextEditingController();
  final txtPhoneNode = FocusNode();

  // Form validation errors
  var emailError = '';
  var passwordError = '';
  var phoneError = '';

  // UI state
  var loginEnabled = false;
  var isPasswordVisible = false;
  var isLoading = false;
  var version = '';
  var onboardingIndex = 0;

  MbxLanguageController get languageController =>
      Get.find<MbxLanguageController>();
  @override
  void onReady() {
    super.onReady();
    PackageInfo.fromPlatform().then((info) {
      version = 'Version ${info.version}';
      update();
    });

    onboardingVM.nextPage().then((resp) {
      if (resp.status == 200) {
        update();
      }
    });

    // Debug: Prefill login fields
    txtEmailController.text = 'super@mbankingcore.com';
    txtPasswordController.text = 'Super123?';
    loginEnabled = true;
    update();
  }

  btnThemeClicked() {
    MbxThemeVM.change().then((value) {
      if (value) {
        Get.offAllNamed('/login');
      }
    });
  }

  btnLanguageClicked() {
    MbxLanguageSheet.show();
  }

  String getCurrentLanguageFlag() {
    return languageController.getCurrentLanguageFlag();
  }

  String getCurrentLanguageName() {
    return languageController.getCurrentLanguageName();
  }

  txtPhoneOnChanged(String value) {
    loginEnabled = value.isNotEmpty;
    update();
  }

  // New methods for web admin login
  txtEmailOnChanged(String value) {
    emailError = '';
    loginEnabled = value.isNotEmpty && txtPasswordController.text.isNotEmpty;
    update();
  }

  txtPasswordOnChanged(String value) {
    passwordError = '';
    loginEnabled = txtEmailController.text.isNotEmpty && value.isNotEmpty;
    update();
  }

  togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  btnForgotPasswordClicked() {
    ToastX.showSuccess(msg: 'Fitur lupa password akan segera hadir');
  }

  btnStartClicked() {
    Get.to(MbxLoginScreen());
  }

  setOnboardingIndex(int index) {
    onboardingIndex = index;
    update();
  }

  btnLoginClicked() async {
    FocusManager.instance.primaryFocus?.unfocus();
    emailError = '';
    passwordError = '';
    update();

    // Validate email
    if (txtEmailController.text.trim().isEmpty) {
      emailError = 'Email tidak boleh kosong';
      FocusScope.of(Get.context!).requestFocus(txtEmailNode);
      update();
      return;
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(txtEmailController.text.trim())) {
      emailError = 'Format email tidak valid';
      FocusScope.of(Get.context!).requestFocus(txtEmailNode);
      update();
      return;
    }

    // Validate password
    if (txtPasswordController.text.isEmpty) {
      passwordError = 'Password tidak boleh kosong';
      FocusScope.of(Get.context!).requestFocus(txtPasswordNode);
      update();
      return;
    }

    if (txtPasswordController.text.length < 6) {
      passwordError = 'Password minimal 6 karakter';
      FocusScope.of(Get.context!).requestFocus(txtPasswordNode);
      update();
      return;
    }

    // Start loading
    isLoading = true;
    update();

    try {
      final response = await MbxAdminLoginVM.request(
        email: txtEmailController.text.trim(),
        password: txtPasswordController.text.trim(),
      );

      isLoading = false;
      update();

      if (response.status == 200 && response.data != null) {
        // Save admin token
        await MbxUserPreferencesVM.setToken(response.data!.accessToken);

        // Navigate immediately - no blocking toast
        Get.offAllNamed('/home');

        // Show welcome message after navigation (non-blocking)
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.snackbar(
            'Login Berhasil',
            'Selamat datang ${response.data!.admin.name}',
            backgroundColor:
                Theme.of(Get.context!).brightness == Brightness.dark
                ? const Color(0xFF2E7D32).withOpacity(0.9)
                : const Color(0xFF4CAF50).withOpacity(0.9),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            isDismissible: true,
            forwardAnimationCurve: Curves.easeOut,
            reverseAnimationCurve: Curves.easeIn,
          );
        });
      } else {
        ToastX.showError(msg: response.message);
      }
    } catch (e) {
      isLoading = false;
      update();
      ToastX.showError(msg: 'Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  askOtp(String phone) {
    final pinSheet = MbxOtpSheet();
    pinSheet
        .show(
          title: 'otp'.tr,
          message: 'enter_otp_message'.tr,
          secure: false,
          biometric: false,
          onSubmit: (code, biometric) async {
            LoggerX.log('[OTP] entered: $code');
            Get.loading();
            final resp = await MbxLoginOtpVM.request(phone: phone, otp: code);
            Get.back();
            if (resp.status == 200) {
              LoggerX.log('[OTP] verfied: $code');
              Get.back();
              Get.loading();
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.back();
                askPin(phone, code);
              });
            } else {}
          },
          optionTitle: 'resend'.tr,
          optionClicked: () {
            pinSheet.clear('');
            ToastX.showSuccess(msg: 'otp_resent_success'.tr);
          },
        )
        .then((code) {
          if (code != null && (code as String).isNotEmpty) {
            LoggerX.log('[OTP] verfied: $code');
            askPin(phone, code);
          }
        });
  }

  askPin(String phone, String otp) {
    final pinSheet = MbxPinSheet();
    pinSheet.show(
      title: 'pin'.tr,
      message: 'enter_pin_message'.tr,
      secure: true,
      biometric: false,
      onSubmit: (code, biometric) async {
        LoggerX.log('[PIN] entered: $code');
        Get.loading();
        final resp = await MbxLoginPinVM.request(phone: '', otp: '', pin: code);
        if (resp.status == 200) {
          LoggerX.log('[PIN] verfied: $code');
          MbxProfileVM.request().then((resp) {
            Get.offAllNamed('/home');
          });
        } else {
          Get.back();
        }
      },
      optionTitle: 'forgot_pin'.tr,
      optionClicked: () {
        pinSheet.clear('');
        ToastX.showSuccess(msg: 'pin_reset_message'.tr);
      },
    );
  }
}
