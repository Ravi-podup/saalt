import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Rounded search input shared by the screens that filter a list.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 0),
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: color),
    );

    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 13.5, color: AppColors.ink),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.surface,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkFaint),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 19,
            color: AppColors.inkFaint,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded, size: 17),
                  color: AppColors.inkFaint,
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
          border: border(AppColors.hairline),
          enabledBorder: border(AppColors.hairline),
          focusedBorder: border(AppColors.inkMuted),
        ),
      ),
    );
  }
}
