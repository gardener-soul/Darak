import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class SoftTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  /// 최대 줄 수. 기본값 1 (단일 라인). null이면 무제한.
  final int? maxLines;
  /// 최소 줄 수. null이면 자동 조절하지 않음.
  final int? minLines;

  const SoftTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: AppDecorations.defaultRadius,
        boxShadow: AppDecorations.innerInputShadow,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        maxLines: obscureText ? 1 : maxLines,
        minLines: minLines,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          // The borders are handled by the Container decoration implicitly for the "Soft" look
          // We keep the InputDecoration clean to avoid double borders
          border: OutlineInputBorder(
            borderRadius: AppDecorations.defaultRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDecorations.defaultRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDecorations.defaultRadius,
            borderSide: const BorderSide(color: AppColors.softCoral, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          filled: false, // Handled by Container
        ),
      ),
    );
  }
}
