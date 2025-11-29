import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final Color? confirmColor;
  final VoidCallback? onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    this.confirmColor,
    this.onConfirm,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
            onConfirm?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: confirmColor ?? (isDestructive ? AppColors.error : null),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

class InputDialog extends StatefulWidget {
  final String title;
  final String? hint;
  final String? initialValue;
  final String confirmText;
  final String cancelText;
  final String? Function(String?)? validator;
  final int maxLines;

  const InputDialog({
    super.key,
    required this.title,
    this.hint,
    this.initialValue,
    this.confirmText = 'Submit',
    this.cancelText = 'Cancel',
    this.validator,
    this.maxLines = 1,
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? hint,
    String? initialValue,
    String confirmText = 'Submit',
    String cancelText = 'Cancel',
    String? Function(String?)? validator,
    int maxLines = 1,
  }) async {
    return showDialog<String>(
      context: context,
      builder: (context) => InputDialog(
        title: title,
        hint: hint,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          validator: widget.validator,
          maxLines: widget.maxLines,
          decoration: InputDecoration(hintText: widget.hint),
          autofocus: true,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.cancelText),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }
}
