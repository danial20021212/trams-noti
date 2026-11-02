import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/model/shared/loader_state_model.dart'; // Make sure to import your LoaderState

Widget button(String title, Future<void> Function() onPressed, {Color? color, Rx<LoaderState>? state}) {
  // Fallback boolean just in case you use this button somewhere without a LoaderState
  final RxBool localLoading = false.obs;

  return Obx(() {
    // Check if the Controller's state is 'loading', or fallback to local loading state
    final bool isLoading = state != null
        ? state.value == LoaderState.loading
        : localLoading.value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: NeumorphicButton(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          style: NeumorphicStyle(
            color: color ?? const Color(0xFFE0C158),
            depth: isLoading ? 1 : 5,
            boxShape: NeumorphicBoxShape.stadium(),
          ),
          onPressed: isLoading
              ? null
              : () async {
            // If no state is provided, handle the loading animation locally
            if (state == null) localLoading.value = true;

            try {
              await onPressed();
            } finally {
              if (state == null) localLoading.value = false;
            }
          },
          child: isLoading
              ? const Center(
            child: SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.black54,
              ),
            ),
          )
              : Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  });
}
