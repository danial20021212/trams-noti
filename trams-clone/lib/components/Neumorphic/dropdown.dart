import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../model/shared/dropdown_model.dart';

class NeumorphicDropdown extends StatefulWidget {
  final String placeholder;
  final String title;
  final Widget? wtitle;
  final String? selected;
  final TextEditingController? controller;
  final List<DropdownModel> items;
  final Function(String)? onChanged;
  final bool enabled;
  final Color? enabledColor;
  final Color? disabledColor;
  final Color? enabledTextColor;
  final Color? disabledTextColor;
  final NeumorphicShape? nShape;
  final TextStyle enabledHintStyle;
  final TextStyle disabledHintStyle;

  const NeumorphicDropdown({
    super.key,
    this.title = "",
    this.placeholder = " - ",
    this.items = const [],
    this.controller,
    this.onChanged,
    this.wtitle,
    this.selected,
    this.enabled = true,
    this.enabledColor = const Color.fromARGB(255, 221, 231, 239),
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
  NeumorphicDropdownState createState() => NeumorphicDropdownState();
}

class NeumorphicDropdownState extends State<NeumorphicDropdown> {
  @override
  void initState() {
    super.initState();
  }

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.wtitle ??
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: NeumorphicTheme.defaultTextColor(context),
                  fontSize: 14,
                ),
              ),
            ),
        Neumorphic(
          margin: EdgeInsets.only(
            left: 6,
            right: 6,
            top: 2,
            bottom: 4,
          ),
          style: NeumorphicStyle(
            color: widget.enabled ? widget.enabledColor : widget.disabledColor,
            boxShape: const NeumorphicBoxShape.stadium(),
            depth: -5,
            shape: widget.nShape ?? NeumorphicShape.flat,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonFormField2(
            decoration: InputDecoration.collapsed(
              hintText: '',
              fillColor:
              widget.enabled ? widget.disabledColor : widget.enabledColor,
            ),
            isExpanded: true,
            hint: Text(
              widget.placeholder,
              style: widget.enabled
                  ? widget.enabledHintStyle
                  : widget.disabledHintStyle,
            ),
            items: widget.items
                .map(
                  (DropdownModel e) => DropdownMenuItem<String>(
                value: e.id,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    e.value,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.enabled
                          ? widget.enabledTextColor
                          : widget.disabledTextColor,
                    ),
                  ),
                ),
              ),
            )
                .toList(),
            value: widget.selected,
            onChanged: widget.enabled
                ? (value) {
              if (value == null) return;
              widget.controller?.text = value as String;
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(value as String);
              }
            }
                : null,
            buttonStyleData: const ButtonStyleData(
              height: 36,
              padding: EdgeInsets.symmetric(horizontal: 13),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color:
                widget.enabled ? widget.enabledColor : widget.disabledColor,
                borderRadius: BorderRadius.circular(8), // optional
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 36,
            ),
            dropdownSearchData: DropdownSearchData<String>(
              searchInnerWidgetHeight: 50,
              searchController: textEditingController,
              searchInnerWidget: Padding(
                padding:
                const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    hintText: 'Search for an item...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                final list = widget.items;
                final myItem = list.firstWhere((e) => e.id == item.value);
                return myItem.value.toLowerCase().contains(searchValue.toLowerCase());
              },

            ),






            // buttonHeight: 45,
            // dropdownOverButton: false,
            // dropdownMaxHeight: 200,
            // searchController: textEditingController,
            // searchInnerWidget: Padding(
            //   padding: const EdgeInsets.only(
            //     top: 8,
            //     bottom: 4,
            //     right: 8,
            //     left: 8,
            //   ),
            // searchMatchFn: (item, searchValue) {
            //   final myItem = widget.items
            //       .firstWhere((element) => element.id == item.value);
            //   searchValue = searchValue.toLowerCase();
            //   return myItem.value.toString().toLowerCase().contains(searchValue);
            //   // return (item.value.toString().contains(searchValue));
            // },
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        ),
      ],
    );
  }
}
