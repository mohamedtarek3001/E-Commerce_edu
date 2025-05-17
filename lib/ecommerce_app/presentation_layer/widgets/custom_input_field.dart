import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({super.key, this.title, this.hint, this.icon, this.controller, required this.isPassword, this.suffixIcon, this.onPressed, required this.isVisible, this.validator});

  final String? title;
  final String? hint;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isVisible;
  final void Function()? onPressed;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          validator: validator,
          obscureText: isVisible,
          controller: controller,
          decoration: InputDecoration(
            label: Text(
              '$title',
              style: const TextStyle(fontSize: 20),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: icon == null
                ? null
                : Icon(
                    icon,
                    color: Colors.grey[800],
                  ),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onPressed,
                    icon: Icon(suffixIcon),
                  )
                : null,
            hintText: '$hint',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: Color(0x66000000))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        )
      ],
    );
  }
}

class ProductInputField extends StatelessWidget {
  const ProductInputField({super.key, this.title, this.hint, this.icon, this.controller, required this.isPassword, this.suffixIcon, this.onPressed, required this.isVisible, this.validator, this.maxLines});

  final String? title;
  final String? hint;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isVisible;
  final void Function()? onPressed;
  final String? Function(String?)? validator;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title ?? '',
          style: const TextStyle(color: Color(0xff576A69), fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: validator,
          controller: controller,
          maxLines: maxLines??1,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: icon == null
                ? null
                : Icon(
                    icon,
                    color: Colors.grey[800],
                  ),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onPressed,
                    icon: Icon(suffixIcon),
                  )
                : null,
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: Color(0xCCD9E1E7))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: Color(0xff22C7B6))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: Color(0xCCD9E1E7))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        )
      ],
    );
  }
}
