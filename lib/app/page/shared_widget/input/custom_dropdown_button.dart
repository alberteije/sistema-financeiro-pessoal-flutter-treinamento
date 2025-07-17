import 'package:flutter/material.dart';

import 'custom_dropdown_button_controller.dart';

class CustomDropdownButton extends StatefulWidget {
  final CustomDropdownButtonController? controller;
  final String labelText;
  final String hintText;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  const CustomDropdownButton({
    Key? key,
    this.controller,
    required this.labelText,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  late CustomDropdownButtonController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? CustomDropdownButtonController(widget.items.first);
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    setState(() {}); // Atualiza o dropdown quando o valor mudar
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose(); // Só dispose se foi criado internamente
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: _controller.selected,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const UnderlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          _controller.selected = newValue;
          widget.onChanged(newValue);
        }
      },
      validator: widget.validator,
    );
  }
}
