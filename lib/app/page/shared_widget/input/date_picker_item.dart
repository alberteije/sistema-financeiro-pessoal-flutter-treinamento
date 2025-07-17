import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_picker_item_controller.dart';

class DatePickerItem extends StatefulWidget {
  final DatePickerItemController? controller;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? mask;
  final ValueChanged<DateTime?> onChanged;
  final bool? readOnly;
  final String? Function(DateTime?)? validator;

  const DatePickerItem({
    Key? key,
    this.controller,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.mask,
    this.readOnly,
    this.validator,
  }) : super(key: key);

  @override
  State<DatePickerItem> createState() => DatePickerItemState();
}

class DatePickerItemState extends State<DatePickerItem> {
  late final DatePickerItemController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DatePickerItemController(null);
    _controller.addListener(_onDateChanged);
    _validateDate(_controller.date);
  }

  @override
  void dispose() {
    _controller.removeListener(_onDateChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onDateChanged() {
    setState(() {}); // Atualiza o widget quando o controller muda
  }

  void _validateDate(DateTime? date) {
    if (widget.validator != null) {
      _errorText = widget.validator!(date);
    }
  }

  void _updateDate(DateTime? newDate) {
    _controller.date = newDate;
    widget.onChanged(newDate);
    _validateDate(newDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: theme.textTheme.titleMedium!,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _errorText != null ? theme.colorScheme.error : theme.dividerColor,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onDoubleTap: () => _updateDate(null),
                    onTap: () {
                      if (widget.readOnly != true) {
                        showDatePicker(
                          context: context,
                          initialDate: _controller.date ?? today,
                          firstDate: widget.firstDate!,
                          lastDate: widget.lastDate!,
                        ).then((value) {
                          if (value != null) {
                            _updateDate(DateTime(value.year, value.month, value.day));
                          }
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            _controller.date != null
                                ? DateFormat(widget.mask ?? 'dd/MM/yyyy').format(_controller.date!)
                                : '',
                          ),
                        ),
                        const Expanded(
                          flex: 0,
                          child: Icon(Icons.arrow_drop_down, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _errorText!,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
            ),
          ),
      ],
    );
  }
}
