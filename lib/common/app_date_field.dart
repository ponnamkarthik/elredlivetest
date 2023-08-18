import 'package:elredlivetest/providers/screens_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatefulWidget {
  const AppDateField({
    super.key,
    required this.hintText,
    this.currentDate,
    this.onChanged,
    this.onValid,
  });

  final String hintText;
  final String? currentDate;
  final Function(String)? onChanged;
  final Function(bool)? onValid;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  final _controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

   if(widget.currentDate != null) {
     _controller.text = widget.currentDate!;
     setState(() {
       try {
         selectedDate = DateFormat("dd/MM/yyyy").parse(widget.currentDate!);
       } catch (e) {
         selectedDate = DateTime.now();
       }
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
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
      readOnly: true,
      autovalidateMode: AutovalidateMode.disabled,
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: Colors.grey[200],
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onTap: () async {
        final firstDate = DateTime(1800);
        final lastDate = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if(date != null) {
          selectedDate = date;
          String formattedDate = DateFormat("dd/MM/yyyy").format(date);
          _controller.text = formattedDate;
          widget.onChanged?.call(formattedDate);
        }
      },
    );
  }
}
