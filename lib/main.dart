import 'dart:io';

import 'package:mbankingbackoffice/apis/mbx_device_info_vm.dart';
import 'package:mbankingbackoffice/biller-pln/prepaid/views/mbx_electricity_prepaid_screen.dart';
import 'package:mbankingbackoffice/biller-pulsa/dataplan/views/mbx_pulsa_dataplan_screen.dart';
import 'package:mbankingbackoffice/cardless/views/mbx_cardless_payment_screen.dart';
import 'package:mbankingbackoffice/cardless/views/mbx_cardless_screen.dart';
import 'package:mbankingbackoffice/home/views/mbx_home_screen.dart';
import 'package:mbankingbackoffice/language/viewmodels/mbx_translation_service.dart';
import 'package:mbankingbackoffice/language/views/mbx_language_controller.dart';
import 'package:mbankingbackoffice/language/views/mbx_language_selection_screen.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_profile_vm.dart';
import 'package:mbankingbackoffice/login/views/mbx_login_screen.dart';
import 'package:mbankingbackoffice/preferences/mbx_preferences_vm.dart';
import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:mbankingbackoffice/privacy-policy/views/mbx_privacy_policy_screen.dart';
import 'package:mbankingbackoffice/qris/views/mbx_qris_screen.dart';
import 'package:mbankingbackoffice/receipt/views/mbx_receipt_screen.dart';
import 'package:mbankingbackoffice/relogin/views/mbx_relogin_screen.dart';
import 'package:mbankingbackoffice/security/mbx_anti_jailbreak_vm.dart';
import 'package:mbankingbackoffice/theme/app_themes.dart';
import 'package:mbankingbackoffice/theme/controllers/mbx_theme_controller.dart';
import 'package:mbankingbackoffice/theme/viewmodels/mbx_theme_vm.dart';
import 'package:mbankingbackoffice/utils/mbx_reachability_vm.dart';

import 'biller-pbb/views/mbx_pbb_screen.dart';
import 'biller-pdam/views/mbx_pdam_screen.dart';
import 'biller-pln/nontaglis/views/mbx_electricity_nontaglis_screen.dart';
import 'biller-pln/postpaid/views/mbx_electricity_postpaid_screen.dart';
import 'biller-pulsa/postpaid/views/mbx_pulsa_postpaid_screen.dart';
import 'biller-pulsa/prepaid/views/mbx_pulsa_prepaid_screen.dart';
import 'bottom-navbar/views/mbx_bottom_navbar_screen.dart';
// Old camera-dependent files (commented out for web compatibility)
// import 'ekyc/views/mbx_ekyc_confirmation_screen.dart';
// import 'ekyc/views/mbx_ekyc_ktp_photo_screen.dart';
// import 'ekyc/views/mbx_ekyc_selfie_ktp_screen.dart';
// import 'ekyc/views/mbx_ekyc_selfie_screen.dart';
import 'faq/views/mbx_faq_screen.dart';
import 'news/views/mbx_news_screen.dart';
import 'tnc/views/mbx_tnc_screen.dart';
import 'transfer/main/views/mbx_transfer_screen.dart';
import 'transfer/p2bank/views/mbx_transfer_p2bank_screen.dart';
import 'transfer/p2p/views/mbx_transfer_p2p_screen.dart';
import 'upgrade/services/universal_camera_service.dart';
import 'upgrade/services/upgrade_data_service.dart';
import 'upgrade/views/mbx_upgrade_confirmation_screen.dart';
import 'upgrade/views/mbx_upgrade_data_entry_screen.dart';
import 'upgrade/views/mbx_upgrade_ktp_photo_screen.dart';
import 'upgrade/views/mbx_upgrade_selfie_ktp_screen.dart';
import 'upgrade/views/mbx_upgrade_selfie_screen.dart';
import 'upgrade/views/mbx_upgrade_success_screen.dart';
import 'widget-x/all_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MbxAntiJailbreakVM.check();
  await MbxDeviceInfoVM.request();
  MbxReachabilityVM.startListening();

  // Initialize language controller with lazy loading
  Get.lazyPut<MbxLanguageController>(
    () => MbxLanguageController(),
    fenix: true,
  );

  // Initialize theme controller
  Get.put(MbxThemeController(), permanent: true);

  // Initialize eKYC services
  print('Initializing eKYC services...');
  Get.put(UpgradeDataService(), permanent: true);
  Get.put(UniversalCameraService(), permanent: true);
  print('eKYC services initialized successfully');

  final freshInstall = await MbxPreferencesVM.getFreshInstall();
  if (freshInstall == true) {
    await MbxPreferencesVM.setFreshInstall(false);
    await MbxUserPreferencesVM.resetAll();
  }

  final theme = await MbxUserPreferencesVM.getTheme();
  if (theme.isNotEmpty) {
    ColorX.theme = hexToColor(await MbxUserPreferencesVM.getTheme());
  } else {
    ColorX.theme = MbxThemeVM.colors[0];
    final hex = '#${ColorX.theme.toARGB32().toRadixString(16).padLeft(8, '0')}';
    MbxUserPreferencesVM.setTheme(hex);
  }
  await MbxProfileVM.load();

  String initialRoute = '/login';
  final token = await MbxUserPreferencesVM.getToken();
  // Temporarily force login screen for desktop debugging
  if (Platform.isMacOS) {
    await MbxUserPreferencesVM.setToken(''); // Clear token for macOS
  }
  if (token.isNotEmpty && !Platform.isMacOS) {
    initialRoute = '/relogin';
  }

  print('🚀 Starting app with route: $initialRoute');
  print('🖥️  Platform: ${Platform.operatingSystem}');
  print(
    '🔑 Token length: ${token.length}',
  ); // Set orientation based on platform
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    print('🖥️  Desktop platform detected - allowing all orientations');
    // Desktop platforms - allow all orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).then((value) {
      print('🖥️  Running desktop app directly');
      runApp(MyApp(initialRoute)); // Direct app for desktop
    });
  } else {
    print('📱 Mobile platform detected - portrait only');
    // Mobile platforms - portrait only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
      value,
    ) {
      runApp(
        ContainerX(
          gradientColorBegin: ColorX.black,
          gradientColorEnd: ColorX.gray,
          child: Center(
            child: ClipRRect(
              child: SizedBox(
                width: double.infinity,
                child: MyApp(initialRoute),
              ),
            ),
          ),
        ),
      );
    });
  }
  /*
  if (MbxSessionVM.token.isNotEmpty) {
    MbxSessionVM.checkPinAndBiometric();
  } */

  /*
  final inquiryVM = MbxQRISInquiryVM();
  inquiryVM.request(qr_code: '').then((resp) {
    if (resp.status == 200) {
      Get.to(MbxQRISAmountScreen(inquiry: inquiryVM.inqury))?.then((value) {});
    }
  }); */
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    print('🏗️  Building MyApp with route: $initialRoute');
    final languageController = Get.find<MbxLanguageController>();

    return GetBuilder<MbxThemeController>(
      init: Get.find<MbxThemeController>(),
      builder: (themeController) {
        print(
          '🎨 Building GetMaterialApp with theme: ${themeController.themeMode}',
        );
        return GetMaterialApp(
          popGesture: true,
          defaultTransition: Transition.cupertino,
          debugShowCheckedModeBanner: false,
          locale: languageController.currentLocale,
          translations: MbxTranslationService(),
          fallbackLocale: const Locale('id', ''),
          scrollBehavior: AppScrollBehavior(),
          title: 'MBanking BackOffice',
          theme: MbxAppThemes.lightTheme.copyWith(
            // Add bright background for desktop debugging
            scaffoldBackgroundColor: Platform.isMacOS
                ? Colors.blue.shade100
                : null,
          ),
          darkTheme: MbxAppThemes.darkTheme,
          themeMode: themeController.themeMode,
          initialRoute: initialRoute,
          getPages: [
            GetPage(
              name: '/ekyc-selfie-ktp-universal',
              page: () => const MbxUpgradeSelfieKtpScreen(),
            ),
            GetPage(
              name: '/login',
              page: () => const MbxLoginScreen(),
              transition: Transition.noTransition,
            ),
            GetPage(
              name: '/home',
              page: () => const MbxHomeScreen(),
              transition: Transition.noTransition,
            ),
            GetPage(
              name: '/relogin',
              page: () => const MbxReloginScreen(),
              transition: Transition.noTransition,
            ),
            GetPage(
              name: '/home',
              page: () => const MbxBottomNavBarScreen(),
              transition: Transition.noTransition,
            ),
            GetPage(name: '/tnc', page: () => MbxTncScreen()),
            GetPage(name: '/privacy', page: () => MbxPrivacyPolicyScreen()),
            GetPage(name: '/faq', page: () => const MbxFaqScreen()),
            GetPage(name: '/news', page: () => MbxNewsScreen()),
            GetPage(name: '/receipt', page: () => MbxReceiptScreen()),
            GetPage(name: '/transfer', page: () => const MbxTransferScreen()),
            GetPage(
              name: '/transfer/p2p',
              page: () => const MbxTransferP2PScreen(),
            ),
            GetPage(
              name: '/transfer/p2bank',
              page: () => const MbxTransferP2BankScreen(),
            ),
            GetPage(
              name: '/qris',
              page: () => const MbxQRISScreen(),
              transition: Transition.noTransition,
            ),
            GetPage(name: '/cardless', page: () => const MbxCardlessScreen()),
            GetPage(
              name: '/cardless/payment',
              page: () => MbxCardlessPaymentScreen(),
            ),
            GetPage(
              name: '/electricity/prepaid',
              page: () => const MbxElectricityPrepaidScreen(),
            ),
            GetPage(
              name: '/electricity/postpaid',
              page: () => const MbxElectricityPostpaidScreen(),
            ),
            GetPage(
              name: '/electricity/nontaglis',
              page: () => const MbxElectricityNonTagLisScreen(),
            ),
            GetPage(
              name: '/pulsa/prepaid',
              page: () => const MbxPulsaPrepaidScreen(),
            ),
            GetPage(
              name: '/pulsa/postpaid',
              page: () => const MbxPulsaPostpaidScreen(),
            ),
            GetPage(
              name: '/pulsa/dataplan',
              page: () => const MbxPulsaDataPlanScreen(),
            ),
            GetPage(name: '/pbb', page: () => const MbxPBBScreen()),
            GetPage(name: '/pdam', page: () => const MbxPDAMScreen()),
            GetPage(
              name: '/language',
              page: () => const MbxLanguageSelectionScreen(),
            ),
            // eKYC Universal Routes (cross-platform compatible)
            GetPage(
              name: '/ekyc-selfie-universal',
              page: () => const MbxUpgradeSelfieScreen(),
            ),
            GetPage(
              name: '/ekyc-ktp-photo-universal',
              page: () => const MbxUpgradeKtpPhotoScreen(),
            ),
            GetPage(
              name: '/ekyc-confirmation-universal',
              page: () => const MbxUpgradeConfirmationScreen(),
            ),

            // Legacy eKYC routes (commented out - use universal versions instead)
            // GetPage(name: '/ekyc/selfie', page: () => const MbxUpgradeSelfieScreen()),
            // GetPage(name: '/ekyc/selfie-ktp', page: () => const MbxUpgradeSelfieKtpScreen()),
            // GetPage(name: '/ekyc/ktp-photo', page: () => const MbxUpgradeKtpPhotoScreen()),
            GetPage(
              name: '/ekyc/data-entry',
              page: () => const MbxUpgradeDataEntryScreen(),
            ),
            GetPage(
              name: '/ekyc/confirmation',
              page: () => const MbxUpgradeConfirmationScreen(),
            ),
            GetPage(
              name: '/ekyc/success',
              page: () => const MbxUpgradeSuccessScreen(),
            ),
          ],
        );
      },
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
