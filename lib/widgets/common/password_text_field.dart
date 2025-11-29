import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool showStrengthIndicator;
  final bool enabled;

  const PasswordTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction,
    this.showStrengthIndicator = false,
    this.enabled = true,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  PasswordStrength _strength = PasswordStrength.none;

  @override
  void initState() {
    super.initState();
    if (widget.showStrengthIndicator) {
      widget.controller?.addListener(_updateStrength);
    }
  }

  @override
  void dispose() {
    if (widget.showStrengthIndicator) {
      widget.controller?.removeListener(_updateStrength);
    }
    super.dispose();
  }

  void _updateStrength() {
    final password = widget.controller?.text ?? '';
    setState(() {
      _strength = _calculatePasswordStrength(password);
    });
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 6) return PasswordStrength.weak;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText 
                    ? Icons.visibility_outlined 
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
        if (widget.showStrengthIndicator && _strength != PasswordStrength.none) ...[
          const SizedBox(height: 8),
          _PasswordStrengthIndicator(strength: _strength),
        ],
      ],
    );
  }
}

enum PasswordStrength { none, weak, medium, strong }

class _PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const _PasswordStrengthIndicator({required this.strength});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength == PasswordStrength.weak ||
                          strength == PasswordStrength.medium ||
                          strength == PasswordStrength.strong
                      ? _getColor()
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength == PasswordStrength.medium ||
                          strength == PasswordStrength.strong
                      ? _getColor()
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength == PasswordStrength.strong
                      ? _getColor()
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _getLabel(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: _getColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getColor() {
    switch (strength) {
      case PasswordStrength.weak:
        return AppColors.error;
      case PasswordStrength.medium:
        return AppColors.warning;
      case PasswordStrength.strong:
        return AppColors.success;
      case PasswordStrength.none:
        return AppColors.gray400;
    }
  }

  String _getLabel() {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak password';
      case PasswordStrength.medium:
        return 'Medium password';
      case PasswordStrength.strong:
        return 'Strong password';
      case PasswordStrength.none:
        return '';
    }
  }
}
