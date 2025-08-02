import 'package:mbankingbackoffice/privacy-policy/views/mbx_privacy_policy_dialog.dart';
import 'package:mbankingbackoffice/theme/widgets/mbx_dark_mode_switch.dart';
import 'package:mbankingbackoffice/tnc/views/mbx_tnc_dialog.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

import 'mbx_login_controller.dart';

class MbxLoginScreen extends StatelessWidget {
  const MbxLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isMobile = screenSize.width < 768;

    return GetBuilder<MbxLoginController>(
      init: MbxLoginController(),
      builder: (controller) => MbxScreen(
        navigationBarHidden: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [const Color(0xFF1A1A1A), const Color(0xFF0D1117)]
                  : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive breakpoints
              double horizontalPadding = isMobile
                  ? 16.0
                  : isTablet
                  ? 48.0
                  : 64.0;

              double verticalPadding = isMobile
                  ? 16.0
                  : isTablet
                  ? 32.0
                  : 48.0;

              double maxWidth = isMobile
                  ? constraints.maxWidth * 0.95
                  : isTablet
                  ? 480.0
                  : 420.0;

              double cardPadding = isMobile
                  ? 20.0
                  : isTablet
                  ? 32.0
                  : 40.0;

              double logoSize = isMobile
                  ? 70.0
                  : isTablet
                  ? 80.0
                  : 90.0;

              double titleFontSize = isMobile
                  ? 22.0
                  : isTablet
                  ? 24.0
                  : 26.0;

              return Center(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: maxWidth,
                        minHeight: isMobile ? 0 : constraints.maxHeight * 0.6,
                      ),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isDarkMode
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(cardPadding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Dark Mode Switch
                              Align(
                                alignment: Alignment.topRight,
                                child: MbxDarkModeSwitch(
                                  iconSize: isMobile ? 16 : 18,
                                  showLabel: false,
                                ),
                              ),
                              SizedBox(height: isMobile ? 12 : 16),

                              // Logo or App Icon
                              Container(
                                width: logoSize,
                                height: logoSize,
                                decoration: BoxDecoration(
                                  color: ColorX.theme,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.admin_panel_settings,
                                  color: Colors.white,
                                  size: logoSize * 0.5,
                                ),
                              ),
                              SizedBox(height: isMobile ? 20 : 24),

                              // Title
                              TextX(
                                'MBanking BackOffice',
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: ColorX.theme,
                              ),
                              SizedBox(height: isMobile ? 24 : 32),

                              // Email Field
                              ContainerError(
                                error: controller.emailError,
                                child: TextFieldX(
                                  hint: 'Email',
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  readOnly: false,
                                  controller: controller.txtEmailController,
                                  focusNode: controller.txtEmailNode,
                                  onChanged: (value) {
                                    controller.txtEmailOnChanged(value);
                                  },
                                  leftIcon: ImageX(
                                    faIcon: FontAwesomeIcons.envelope,
                                    color: ColorX.gray,
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                ),
                              ),
                              SizedBox(height: isMobile ? 12 : 16),

                              // Password Field
                              ContainerError(
                                error: controller.passwordError,
                                child: TextFieldX(
                                  hint: 'Password',
                                  obscureText: !controller.isPasswordVisible,
                                  keyboardType: TextInputType.text,
                                  readOnly: false,
                                  controller: controller.txtPasswordController,
                                  focusNode: controller.txtPasswordNode,
                                  onChanged: (value) {
                                    controller.txtPasswordOnChanged(value);
                                  },
                                  leftIcon: ImageX(
                                    faIcon: FontAwesomeIcons.lock,
                                    color: ColorX.gray,
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  rightIcon: ImageX(
                                    faIcon: controller.isPasswordVisible
                                        ? FontAwesomeIcons.eyeSlash
                                        : FontAwesomeIcons.eye,
                                    color: ColorX.gray,
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  rightAction: () {
                                    controller.togglePasswordVisibility();
                                  },
                                ),
                              ),
                              SizedBox(height: isMobile ? 20 : 24),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: isMobile ? 44 : 48,
                                child: controller.isLoading
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: ColorX.theme,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : ButtonX(
                                        title: 'Login',
                                        backgroundColor: ColorX.theme,
                                        titleColor: Colors.white,
                                        cornerRadius: 12.0,
                                        enabled: !controller.isLoading,
                                        clicked: () {
                                          controller.btnLoginClicked();
                                        },
                                      ),
                              ),
                              SizedBox(height: isMobile ? 12 : 16),

                              // Forgot Password Link
                              InkWellX(
                                clicked: () {
                                  controller.btnForgotPasswordClicked();
                                },
                                child: TextX(
                                  'Lupa Password?',
                                  fontSize: isMobile ? 13.0 : 14.0,
                                  color: ColorX.theme,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: isMobile ? 20 : 24),

                              // Terms & Conditions and Privacy Policy Links
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  InkWellX(
                                    clicked: () {
                                      MbxTncDialog.show(context);
                                    },
                                    child: TextX(
                                      'Syarat & Ketentuan',
                                      fontSize: isMobile ? 11.0 : 12.0,
                                      color: isDarkMode
                                          ? Colors.blue.shade300
                                          : const Color(0xFF1976D2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextX(
                                    ' • ',
                                    fontSize: isMobile ? 11.0 : 12.0,
                                    color: isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                                  ),
                                  InkWellX(
                                    clicked: () {
                                      MbxPrivacyPolicyDialog.show(context);
                                    },
                                    child: TextX(
                                      'Kebijakan Privasi',
                                      fontSize: isMobile ? 11.0 : 12.0,
                                      color: isDarkMode
                                          ? Colors.blue.shade300
                                          : const Color(0xFF1976D2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextX(
                                    ' • ',
                                    fontSize: isMobile ? 11.0 : 12.0,
                                    color: isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                                  ),
                                  TextX(
                                    controller.version,
                                    fontSize: isMobile ? 11.0 : 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
