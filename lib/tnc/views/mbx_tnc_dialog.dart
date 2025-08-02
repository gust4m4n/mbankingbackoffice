import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mbankingbackoffice/tnc/viewmodels/mbx_tnc_vm.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxTncDialog extends StatefulWidget {
  const MbxTncDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const MbxTncDialog(),
    );
  }

  @override
  State<MbxTncDialog> createState() => _MbxTncDialogState();
}

class _MbxTncDialogState extends State<MbxTncDialog> {
  final tncVM = MbxTncVM();
  String html = '';

  @override
  void initState() {
    super.initState();
    _loadTnc();
  }

  void _loadTnc() async {
    tncVM.request().then((resp) {
      if (mounted) {
        setState(() {
          html =
              '''
          <span style="font-family: 'Roboto'; font-weight: bold; font-size: 24pt; color: #343a40">${tncVM.tnc.title}</span>
          <br><br>
          <span style="font-family: 'Roboto'; font-weight: normal; font-size: 15pt; color: #343a40">${tncVM.tnc.content}</span>
          ''';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width > 800 ? 700.0 : screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.85;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with close button
            _buildHeader(isDarkMode),

            // Content
            Expanded(
              child: tncVM.loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: html.isNotEmpty
                          ? HtmlWidget(
                              html,
                              textStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            )
                          : Center(
                              child: Text(
                                'Memuat syarat dan ketentuan...',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? const Color(0xFF808080)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1a1a1a) : const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? const Color(0xff2a2a2a)
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.article_outlined,
              color: Color(0xFF1976D2),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Syarat & Ketentuan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ketentuan penggunaan aplikasi',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode
                        ? const Color(0xFFB0B0B0)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close,
              color: isDarkMode
                  ? const Color(0xFFB0B0B0)
                  : const Color(0xFF6B7280),
            ),
            tooltip: 'Tutup',
          ),
        ],
      ),
    );
  }
}
