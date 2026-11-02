import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicInput extends StatefulWidget {
  final String placeholder;
  final String? title;
  final TextEditingController? controller;
  final TextInputType inputType;
  final bool enabled;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function()? onTap;
  final FocusNode? fNode;
  final Color? enabledColor;
  final Color? disabledColor;
  final Color? enabledTextColor;
  final Color? disabledTextColor;
  final NeumorphicShape? nShape;
  final TextStyle enabledHintStyle;
  final TextStyle disabledHintStyle;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;

  const NeumorphicInput({
    super.key,
    this.controller,
    required this.placeholder,
    this.title,
    this.inputType = TextInputType.text,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.fNode,
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
    this.autovalidateMode,
    this.inputFormatters,
  });

  @override
  InputFormState createState() => InputFormState();
}

class InputFormState extends State<NeumorphicInput> {
  late FocusNode fNode;
  @override
  void initState() {
    fNode = widget.fNode ?? FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            widget.title ?? widget.placeholder,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
              fontSize: 14,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Neumorphic(
            margin: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 2,
              bottom: 4,
            ),
            style: NeumorphicStyle(
              color: widget.readOnly
                  ? widget.disabledColor
                  : widget.enabledColor ??
                      const Color.fromARGB(255, 221, 231, 239),
              boxShape: const NeumorphicBoxShape.stadium(),
              depth: -5,
              shape: widget.nShape ?? NeumorphicShape.flat,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            child: Container(
              height: 25,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5),
              child: TextFormField(
                focusNode: fNode,
                keyboardType: widget.inputType,
                controller: widget.controller,
                style: TextStyle(
                  color: widget.readOnly
                      ? widget.disabledTextColor
                      : widget.enabledTextColor,
                  fontSize: 14,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: widget.placeholder,
                  hintStyle: widget.readOnly
                      ? widget.disabledHintStyle
                      : widget.enabledHintStyle,
                ),
                autovalidateMode: widget.autovalidateMode,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                validator: widget.validator,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                inputFormatters: widget.inputFormatters,
              ),
            ),
          ),
        ),
      ],
    );
  }

  onTap() {
    FocusScope.of(context).requestFocus(fNode);
    if (widget.onTap != null) widget.onTap!();
  }

  @override
  void dispose() {
    fNode.dispose();
    super.dispose();
  }
}
