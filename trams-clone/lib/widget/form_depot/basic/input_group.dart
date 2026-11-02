import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget textField({
  required String labelText,
  required String getter,
  required void Function(String) setter,
  bool isNumberInput = false,
  bool readOnly = false,
  String hintText = "",
  String suffixText = "",
  int maxLines = 1,
  bool isMandatory = false,
}) {
  final TextEditingController controller = TextEditingController(text: getter);

  controller.text = getter;
  controller.selection = TextSelection.fromPosition(
    TextPosition(offset: controller.text.length),
  );

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      width: Get.width,
      child: TextField(
        maxLines: maxLines,
        keyboardType: TextInputType.text,
        inputFormatters: isNumberInput
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
            : [],
        readOnly: readOnly,
        controller: controller,
        onChanged: setter,
        decoration: InputDecoration(
          enabled: !readOnly,
          hintText: hintText,
          suffixText: suffixText,
          suffixStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          // <-- Swapped labelText for label with RichText
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: labelText),
                if (isMandatory)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget richTextField({
  required String title,
  required String getter,
  required Function(String) onChanged,
  bool isEnable = true,
  bool isMandatory = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // <-- Swapped standard Text for Text.rich
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: title),
              if (isMandatory)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          style: TextStyle(
            fontSize: 18,
            color: isEnable ? Colors.black : Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          enabled: isEnable,
          controller: TextEditingController(text: getter),
          onChanged: onChanged,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isEnable ? Colors.black : Colors.grey,
              ),
            ),
          ),
          style: TextStyle(
            color: isEnable ? Colors.black : Colors.grey,
          ),
        ),
      ],
    ),
  );
}

class DatePickerTextField extends StatefulWidget {
  final String getter;
  final Function(String) setter;
  final String labelText;
  final bool isEnable;

  const DatePickerTextField(
      {super.key,
      required this.getter,
      required this.setter,
      this.labelText = "Date",
      this.isEnable = true});

  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  final _currentDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.getter.isEmpty) {
      // If getter is empty, use current date
      _dateController.text = _currentDateTime;
      widget.setter(_currentDateTime);
    } else {
      // If getter has a value, use the existing logic to parse and format
      _formatAndSetDate(widget.getter);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.getter.isNotEmpty
          ? DateTime.tryParse(widget.getter) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
      _dateController.text = formattedDate;
      widget.setter(formattedDate);
    }
  }

  DateTime _parseDate(String dateString) {
    print('Input Date String: $dateString');

    // Predefined parsing formats with explicit handling
    final formats = [
      // Prioritize most specific to least specific parsing
      'dd-MM-yyyy', // Prioritize day-month-year format
      'yyyy-MM-dd', // Standard ISO format
      'MM/dd/yyyy',
      'dd/MM/yyyy',
    ];

    for (var format in formats) {
      try {
        // Use lenient parsing
        DateTime parsedDate = DateFormat(format).parseLoose(dateString);
        print('Parsed Date using $format: $parsedDate');

        // Additional validation for parsed date
        if (_isValidDate(parsedDate)) {
          return parsedDate;
        }
      } catch (e) {
        print('Failed to parse with format $format: $e');
        continue;
      }
    }

    // Explicit manual parsing for day-month-year format
    try {
      List<String> parts = dateString.split('-');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);

        DateTime manualParsedDate = DateTime(year, month, day);
        print('Manually Parsed Date: $manualParsedDate');

        return manualParsedDate;
      }
    } catch (e) {
      print('Manual parsing failed: $e');
    }

    // Fallback to current date with warning
    print('Defaulting to current date due to parsing failure');
    return DateTime.now();
  }

  bool _isValidDate(DateTime date) {
    // Strict date validation
    return date.year >= 1900 &&
        date.year <= 2100 &&
        date.month >= 1 &&
        date.month <= 12;
  }

  void _formatAndSetDate(String dateString) {
    if (dateString.isEmpty) {
      _dateController.text = '';
      widget.setter('');
      return;
    }

    try {
      DateTime parsedDate = _parseDate(dateString);

      // Always format to 'yyyy-MM-dd'
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      print('Final Formatted Date: $formattedDate');

      setState(() {
        _dateController.text = formattedDate;
      });
      widget.setter(formattedDate);
    } catch (e) {
      print('Date Formatting Error: $e');
      setState(() {
        _dateController.text = '';
      });
      widget.setter('');
    }
  }

  @override
  void didUpdateWidget(DatePickerTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reformat date if getter changes
    if (oldWidget.getter != widget.getter) {
      _formatAndSetDate(widget.getter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: Get.width,
        child: TextField(
          controller: _dateController,
          readOnly: true, // Prevent manual input
          onTap: () => widget.isEnable ? _selectDate(context) : null,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              borderSide: const BorderSide(
                  color: Colors.grey), // Optional: Border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10), // Rounded corners when inactive
              borderSide: const BorderSide(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class CustomRadioListTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final bool isReadOnly;

  const CustomRadioListTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = groupValue == value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Colors.blue[900]! : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: isReadOnly
                ? null
                : () {
                    onChanged(isSelected ? null : value);
                  },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue[900]!
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: Colors.white,
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.blue[900] : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCheckboxListTile extends StatelessWidget {
  final String id;
  final String title;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const CustomCheckboxListTile({
    super.key,
    required this.id,
    required this.title,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          onChanged(!isSelected);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? Colors.blue[800]! : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              if (id != "")
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.center,
                    //width: 80,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: isSelected ? Colors.blue[900]! : Colors.grey[700],
                      shape: BoxShape.rectangle,
                    ),
                    child: Text(
                      id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue[800]! : Colors.grey[700],
                    ),
                  ),
                ),
              ),
              // Checkbox on the right
              Checkbox(
                value: isSelected,
                onChanged: (bool? newValue) {
                  // Call the onChanged callback with the new value
                  onChanged(newValue);
                },
                activeColor: Colors.blue[800],
              ),
              // CheckboxListTile(
              //   value: isSelected,
              //   onChanged: onChanged,
              //   title: Text(
              //     title,
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: isSelected ? Colors.blue[800]! : Colors.grey[700],
              //     ),
              //   ),
              //   activeColor: Colors.blue[800],
              //   contentPadding:
              //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
