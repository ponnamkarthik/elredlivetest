import 'package:elredlivetest/models/screens_model.dart';
import 'package:flutter/material.dart';

class AppRadioField extends StatelessWidget {
  const AppRadioField(
      {super.key, required this.options, required this.group, this.onChanged});

  final List<Option> options;
  final String group;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (Option op in options)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio(
                value: op.value,
                groupValue: group,
                onChanged: (value) {
                  print(value);
                  onChanged?.call(value!);
                },
              ),
              GestureDetector(
                onTap: () {
                  onChanged?.call(op.value!);
                },
                child: Text(
                  op.text ?? "",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )
            ],
          )
      ],
    );
  }
}
