import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  const CustomTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: leading ??
                const SizedBox(
                  width: 10,
                  height: 10,
                ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title ??
                    const SizedBox(
                      width: 10,
                      height: 10,
                    ),
                subtitle ??
                    const SizedBox(
                      width: 10,
                      height: 10,
                    ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing ??
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
