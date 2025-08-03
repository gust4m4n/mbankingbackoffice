import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';
import 'package:mbankingbackoffice/user/services/mbx_balance_service.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxTopupDialog extends StatefulWidget {
  final MbxUserModel user;

  const MbxTopupDialog({super.key, required this.user});

  static Future<bool?> show(BuildContext context, MbxUserModel user) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MbxTopupDialog(user: user),
    );
  }

  @override
  State<MbxTopupDialog> createState() => _MbxTopupDialogState();
}

class _MbxTopupDialogState extends State<MbxTopupDialog> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  bool _isSubmitting = false;
  String _amountError = '';
  String _descriptionError = '';

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _amountFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (amount > 100000000) {
      return 'Amount cannot exceed Rp 100,000,000';
    }

    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }

    if (value.trim().length < 5) {
      return 'Description must be at least 5 characters';
    }

    return null;
  }

  Future<void> _submitTopup() async {
    setState(() {
      _amountError = '';
      _descriptionError = '';
    });

    // Validate inputs
    final amountError = _validateAmount(_amountController.text);
    final descriptionError = _validateDescription(_descriptionController.text);

    if (amountError != null || descriptionError != null) {
      setState(() {
        _amountError = amountError ?? '';
        _descriptionError = descriptionError ?? '';
      });

      if (amountError != null) {
        _amountFocusNode.requestFocus();
      } else if (descriptionError != null) {
        _descriptionFocusNode.requestFocus();
      }
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final amount = double.parse(_amountController.text.trim());
      final description = _descriptionController.text.trim();

      final response = await MbxBalanceService.topupBalance(
        userId: widget.user.id,
        amount: amount,
        description: description,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
        ToastX.showSuccess(
          msg: 'Top up successful! Amount: ${_formatCurrency(amount)}',
        );
      } else {
        final errorMessage =
            response.jason.mapValue['message']?.toString() ??
            'Failed to process top up';
        ToastX.showError(msg: errorMessage);
      }
    } catch (e) {
      print('Error during topup: $e');
      ToastX.showError(msg: 'Failed to process top up: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: isSmallScreen ? screenSize.width * 0.9 : 500,
        constraints: BoxConstraints(maxHeight: screenSize.height * 0.8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(isDarkMode),

            // Content
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info
                    _buildUserInfo(isDarkMode),

                    const SizedBox(height: 24),

                    // Amount Field
                    _buildAmountField(isDarkMode),

                    const SizedBox(height: 16),

                    // Description Field
                    _buildDescriptionField(isDarkMode),

                    const SizedBox(height: 24),

                    // Action Buttons
                    _buildActionButtons(isDarkMode),
                  ],
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
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF1976D2),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Up Balance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Add funds to user balance',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _isSubmitting
                ? null
                : () => Navigator.of(context).pop(false),
            icon: Icon(
              Icons.close_rounded,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            style: IconButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF1976D2),
            child: Text(
              widget.user.name.isNotEmpty
                  ? widget.user.name[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Current Balance: ${widget.user.formattedBalance}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Up Amount',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          focusNode: _amountFocusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _descriptionFocusNode.requestFocus(),
          enabled: !_isSubmitting,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: 'Enter amount (e.g., 100000)',
            prefixIcon: Icon(
              Icons.money,
              color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
              size: 20,
            ),
            filled: true,
            fillColor: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _amountError.isNotEmpty
                    ? Colors.red
                    : (isDarkMode
                          ? const Color(0xff3a3a3a)
                          : const Color(0xFFE5E7EB)),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _amountError.isNotEmpty
                    ? Colors.red
                    : (isDarkMode
                          ? const Color(0xff3a3a3a)
                          : const Color(0xFFE5E7EB)),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _amountError.isNotEmpty
                    ? Colors.red
                    : const Color(0xFF1976D2),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        if (_amountError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _amountError,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionField(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          focusNode: _descriptionFocusNode,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submitTopup(),
          enabled: !_isSubmitting,
          maxLines: 3,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText:
                'Enter description for this top up (e.g., Monthly allowance)',
            prefixIcon: Icon(
              Icons.description_outlined,
              color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
              size: 20,
            ),
            filled: true,
            fillColor: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _descriptionError.isNotEmpty
                    ? Colors.red
                    : (isDarkMode
                          ? const Color(0xff3a3a3a)
                          : const Color(0xFFE5E7EB)),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _descriptionError.isNotEmpty
                    ? Colors.red
                    : (isDarkMode
                          ? const Color(0xff3a3a3a)
                          : const Color(0xFFE5E7EB)),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _descriptionError.isNotEmpty
                    ? Colors.red
                    : const Color(0xFF1976D2),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        if (_descriptionError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _descriptionError,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSubmitting
                ? null
                : () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: isDarkMode
                    ? const Color(0xff3a3a3a)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitTopup,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Top Up',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }
}
