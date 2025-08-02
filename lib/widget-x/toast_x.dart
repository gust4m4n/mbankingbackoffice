import 'all_widgets.dart';

class ToastX {
  static FlashController? controller;

  static showSuccess({required String msg}) {
    final isDarkMode = Get.context != null
        ? Theme.of(Get.context!).brightness == Brightness.dark
        : false;

    ToastX.snackBarCustom(
      widget: BasicToast(
        backgroundColor: isDarkMode
            ? const Color(0xFF2E7D32).withOpacity(0.9) // Soft dark green
            : const Color(0xFF4CAF50).withOpacity(0.9), // Soft light green
        textColor: Colors.white,
        msg: msg,
      ),
      duration: 2500,
    );
  }

  static showError({required String msg}) {
    final isDarkMode = Get.context != null
        ? Theme.of(Get.context!).brightness == Brightness.dark
        : false;

    ToastX.snackBarCustom(
      widget: BasicToast(
        backgroundColor: isDarkMode
            ? const Color(0xFFD32F2F).withOpacity(0.9) // Soft dark red
            : const Color(0xFFE57373).withOpacity(0.9), // Soft light red
        textColor: Colors.white,
        msg: msg,
      ),
      duration: 3000,
    );
  }

  static snackBar({required String msg}) {
    ToastX.snackBarCustom(widget: BasicSnackBar(msg: msg), duration: 4000);
  }

  static snackBarCustom({
    required Widget widget,
    required int duration,
    bool force = true,
  }) async {
    if (ToastX.controller != null) {
      if (force == true) {
        await ToastX.dismissCustom();
      } else {
        return;
      }
    }
    ToastX.controller = await showFlash(
      context: Get.context!,
      duration: duration == 0 ? null : Duration(milliseconds: duration),
      barrierDismissible: true,
      barrierColor: Colors.transparent, // Tidak ada barrier yang menghalangi
      builder: (context, controller) {
        ToastX.controller = controller;
        return FlashBar(
          shadowColor: ColorX.transparent,
          backgroundColor: ColorX.transparent,
          controller: controller,
          elevation: 0.0,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom, // Pindah kembali ke bottom
          padding: const EdgeInsets.all(0.0),
          dismissDirections: const [FlashDismissDirection.vertical],
          content: widget,
        );
      },
    );
    ToastX.controller = null;
  }

  static dismissCustom() async {
    await ToastX.controller?.dismiss();
    ToastX.controller = null;
  }
}

class BasicToast extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String msg;
  const BasicToast({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    screenWidth - 32, // Screen width minus horizontal padding
                minWidth: 120, // Minimal width untuk toast yang sangat pendek
              ),
              child: ContainerX(
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                cornerRadius: 16.0,
                child: TextX(
                  msg,
                  color: textColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  maxLines: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BasicSnackBar extends StatelessWidget {
  final String msg;
  const BasicSnackBar({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    screenWidth - 32, // Screen width minus horizontal padding
                minWidth: 120, // Minimal width untuk toast yang sangat pendek
              ),
              child: ContainerX(
                backgroundColor: ColorX.theme,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                cornerRadius: 16.0,
                child: TextX(
                  msg,
                  color: ColorX.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  maxLines: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
