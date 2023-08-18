import 'package:elredlivetest/providers/screens_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    this.initialValue,
    this.onChanged,
    this.onValid,
  });

  final String hintText;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(bool)? onValid;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {

  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.initialValue != null) {
      _textController.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      validator: (value) {
        if (value == null || value.length < 2 || value.length > 60) {
          widget.onValid?.call(false);
          return "Value should be of length greater than 2 and less than 60";
        }
        widget.onValid?.call(true);
        return null;
      },
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      style: TextStyle(
        fontSize: 18,
      ),
      autovalidateMode: AutovalidateMode.disabled,
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: Color(0xFFF4F6F9),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFDADADA),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFDADADA),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFDADADA),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
