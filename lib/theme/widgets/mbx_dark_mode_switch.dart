import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbankingbackoffice/theme/controllers/mbx_theme_controller.dart';

class MbxDarkModeSwitch extends StatelessWidget {
  final double? iconSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showLabel;

  const MbxDarkModeSwitch({
    super.key,
    this.iconSize = 20,
    this.activeColor,
    this.inactiveColor,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<MbxThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkModeRx.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor.withOpacity(0.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel) ...[
              Text(
                isDark ? 'Dark' : 'Light',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(width: 8),
            ],
            GestureDetector(
              onTap: () {
                themeController.toggleTheme();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? (activeColor ?? Colors.amber.withOpacity(0.2))
                      : (inactiveColor ?? Colors.blue.withOpacity(0.1)),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(turns: animation, child: child);
                  },
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    key: ValueKey(isDark),
                    size: iconSize,
                    color: isDark
                        ? (activeColor ?? Colors.amber)
                        : (inactiveColor ?? Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class MbxDarkModeToggleSwitch extends StatelessWidget {
  final double? width;
  final double? height;

  const MbxDarkModeToggleSwitch({super.key, this.width = 60, this.height = 30});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxThemeController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            controller.toggleTheme();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height! / 2),
              color: controller.isDarkMode
                  ? Colors.grey[800]
                  : Colors.grey[300],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: controller.isDarkMode ? width! - height! + 2 : 2,
                  top: 2,
                  child: Container(
                    width: height! - 4,
                    height: height! - 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.isDarkMode
                          ? Colors.amber
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      controller.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      size: (height! - 4) * 0.6,
                      color: controller.isDarkMode
                          ? Colors.grey[800]
                          : Colors.amber[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
