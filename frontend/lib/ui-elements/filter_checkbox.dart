import 'package:flutter/material.dart';

class FilterCheckbox extends StatefulWidget{
  final String label;
  final ValueChanged<bool?> onChanged;

  const FilterCheckbox({
    super.key,
    required this.label,
    required this.onChanged
  });

  @override
  State<FilterCheckbox> createState() => _FilterCheckboxState();
}

class _FilterCheckboxState extends State<FilterCheckbox> {
  bool? selected = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.label),
      value: selected,
      onChanged: (checked) {
        widget.onChanged(checked);
        setState(() {
          selected = checked;
        });
      },
    );
  }
}
