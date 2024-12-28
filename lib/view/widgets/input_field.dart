import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hint,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.errorText,
    this.readOnly = false,
    this.myKeyboardType = TextInputType.multiline,
    this.onTap,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
  });

  final String hint;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? errorText;
  final bool readOnly;
  final TextInputType myKeyboardType;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction textInputAction;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      readOnly: readOnly,
      controller: controller,
      focusNode: focusNode,
      keyboardType: myKeyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(color: AppColors.textColor, fontSize: 16),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppColors.hintTextColor, fontSize: 14),
        errorText: errorText,
        filled: true,
        fillColor: AppColors.backgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      onTap: onTap,
    );
  }
}
