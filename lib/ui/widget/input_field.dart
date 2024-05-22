import 'package:chat_wave/extension/widget_extension.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.controller,
    required this.label,
    required this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.onFieldSubmitted,
    super.key,
  });

  const InputField.api({
    required TextEditingController controller,
    String label = 'Gemini API Key',
    TextInputAction textInputAction = TextInputAction.done,
    Key? key,
  }) : this(
    key: key,
    controller: controller,
    label: label,
    textInputAction: textInputAction,
    keyboardType: TextInputType.url,
    autofillHints: const [AutofillHints.url],
  );

  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;
  late bool _isPassword;

  @override
  void initState() {
    _isPassword = widget.keyboardType == TextInputType.visiblePassword;
    _obscureText = _isPassword;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InputField oldWidget) {
    if (oldWidget.keyboardType != widget.keyboardType) {
      _isPassword = widget.keyboardType == TextInputType.visiblePassword;
      _obscureText = _isPassword;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: _isPassword
            ? IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: _obscureText
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility_sharp),
        )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}