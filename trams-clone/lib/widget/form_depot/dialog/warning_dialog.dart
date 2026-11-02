import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tram/widget/form_depot/form_depot_text_scope.dart';

// ignore: must_be_immutable
class WarningDialog extends StatefulWidget {
  String title;
  Function() onPressed;

  WarningDialog({super.key, required this.title, required this.onPressed});

  @override
  State<WarningDialog> createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return FormDepotTextScope(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: -8,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
            lightSource: LightSource.topLeft,
            color: Colors.grey.shade200,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicIcon(
                  Icons.warning_amber_rounded,
                  size: 80,
                  style: NeumorphicStyle(
                    color: Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NeumorphicButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: NeumorphicStyle(
                        color: Colors.green.shade200,
                        shape: NeumorphicShape.flat,
                        depth: 4,
                      ),
                      child: const Text('Cancel'),
                    ),
                    NeumorphicButton(
                      onPressed: widget.onPressed,
                      style: NeumorphicStyle(
                        color: Colors.red.shade300,
                        shape: NeumorphicShape.flat,
                        depth: 4,
                      ),
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
