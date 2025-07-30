import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

import 'mbx_login_controller.dart';

class MbxLoginScreen extends StatelessWidget {
  const MbxLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxLoginController>(
      init: MbxLoginController(),
      builder: (controller) => MbxScreen(
        navigationBarHidden: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo or App Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: ColorX.theme,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        TextX(
                          'MBanking BackOffice',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: ColorX.theme,
                        ),
                        const SizedBox(height: 8),
                        TextX(
                          'Web Admin Panel',
                          fontSize: 14.0,
                          color: ColorX.gray,
                        ),
                        const SizedBox(height: 32),

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
                        const SizedBox(height: 16),

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
                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: controller.isLoading
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: ColorX.theme,
                                    borderRadius: BorderRadius.circular(12.0),
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
                        const SizedBox(height: 16),

                        // Forgot Password Link
                        InkWellX(
                          clicked: () {
                            controller.btnForgotPasswordClicked();
                          },
                          child: TextX(
                            'Lupa Password?',
                            fontSize: 14.0,
                            color: ColorX.theme,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Version
                        TextX(
                          controller.version,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: ColorX.gray,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
