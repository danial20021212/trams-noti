import 'package:flutter/material.dart';

class SeveritySlider extends StatelessWidget {
  const SeveritySlider(
      {super.key,
        required this.defaultValue,
        required this.onChanged,
        required this.t1,
        required this.t2,
        this.max = "10",
        this.detailsButton = const SizedBox()});

  final String defaultValue;
  final Function(String) onChanged;
  final String t1;
  final String t2;
  final String max;
  final Widget detailsButton;

  @override
  Widget build(BuildContext context) {
    double currentValue = defaultValue != "" ? double.parse(defaultValue) : 1.0;
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Severity", style: const TextStyle(fontWeight: FontWeight.bold)),
              detailsButton
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(int.parse(max), (index) {
              return Text(
                (index + 1).toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                  (index + 1) <= currentValue ? Colors.blue[900] : Colors.grey,
                ),
              );
            }),
          ),
          Slider(
            activeColor: Colors.blue[900],
            value: currentValue,
            min: 1,
            max: double.parse(max),
            divisions: int.parse(max) - 1,
            onChanged: (value) {
              onChanged(value.toInt().toString());
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t1, style: TextStyle(color: Colors.grey[500])),
              Text(t2, style: TextStyle(color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }
}
