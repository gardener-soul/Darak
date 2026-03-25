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
          filled: false, // Container가 배경 처리 (테마의 filled: true 덮어씀)
        ),
      ),
    );
  }
}
