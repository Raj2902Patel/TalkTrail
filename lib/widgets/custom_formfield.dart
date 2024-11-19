import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final RegExp validationRegEx;
  final void Function(String?) onSaved;
  final Widget? suffixIcon;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    required this.validationRegEx,
    required this.onSaved,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value != null && validationRegEx.hasMatch(value)) {
            return null;
          }
          return "Enter a valid ${labelText.toLowerCase()}";
        },
        onSaved: onSaved,
        obscuringCharacter: "*",
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
