import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicDateInput extends StatefulWidget {
  final String placeholder;
  final String? title;
  final TextEditingController? controller;
  final bool enabled;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Color? enabledColor;
  final Color? disabledColor;
  final Color? enabledTextColor;
  final Color? disabledTextColor;
  final NeumorphicShape? nShape;
  final TextStyle enabledHintStyle;
  final TextStyle disabledHintStyle;

  const NeumorphicDateInput({
    super.key,
    this.controller,
    required this.placeholder,
    this.title,
    this.enabled = true,
    this.onChanged,
    this.onTap,
    this.enabledColor,
    this.disabledColor,
    this.enabledTextColor,
    this.disabledTextColor,
    this.nShape,
    this.enabledHintStyle = const TextStyle(
      color: Color.fromARGB(133, 9, 76, 132),
      fontWeight: FontWeight.w400,
    ),
    this.disabledHintStyle = const TextStyle(
      color: Color.fromARGB(133, 9, 76, 132),
      fontWeight: FontWeight.w400,
    ),
  });

  @override
  State<NeumorphicDateInput> createState() => _InputFormState();
}

class _InputFormState extends State<NeumorphicDateInput> {
  late TextEditingController controller;
  @override
  void initState() {
    controller = widget.controller ?? TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            widget.title ?? widget.placeholder,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.enabled ? onTap : null,
          child: Neumorphic(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
            style: NeumorphicStyle(
              color: widget.enabled
                  ? widget.enabledColor ??
                      const Color.fromARGB(255, 221, 231, 239)
                  : widget.disabledColor,
              boxShape: const NeumorphicBoxShape.stadium(),
              depth: -5,
              shape: widget.nShape ?? NeumorphicShape.flat,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: widget.enabled
                    ? widget.enabledTextColor
                    : widget.disabledTextColor,
              ),
              decoration: InputDecoration.collapsed(
                hintText: widget.placeholder,
                hintStyle: widget.enabled
                    ? widget.enabledHintStyle
                    : widget.disabledHintStyle,
              ),
              enabled: widget.enabled,
              readOnly: true,
              onChanged: widget.onChanged,
              onTap: widget.enabled ? widget.onTap : null,
            ),
          ),
        ),
      ],
    );
  }

  onTap() {
    if (widget.onTap != null) widget.onTap!();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
