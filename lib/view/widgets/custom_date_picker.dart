import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;

  const CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00695C),
              onPrimary: Colors.white,
              surface: Color(0xFFECEFF1),
              onSurface: Color(0xFF263238),
            ),
            dialogTheme: const DialogTheme(backgroundColor: Color(0xFFECEFF1)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Due Date (optional)',
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Color(0xFF4DB6AC)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF6E40)),
          ),
        ),
        child: Text(
          selectedDate != null
              ? DateFormat('MMM d, yyyy').format(selectedDate!)
              : 'Select a date',
          style: const TextStyle(color: Color(0xFF263238)), 
        ),
      ),
    );
  }
}