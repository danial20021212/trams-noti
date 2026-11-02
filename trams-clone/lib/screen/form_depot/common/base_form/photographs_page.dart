import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/model/form/form_depot/common/form_photo_listing_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/widget/form_depot/dialog/pick_photo_dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class PhotographsPage extends StatefulWidget {
  const PhotographsPage({super.key});

  @override
  State<PhotographsPage> createState() => _PhotographsPageState();
}

class _PhotographsPageState extends State<PhotographsPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<BaseFormController>();

  bool get _supportsPhotoRemarks => controller.supportsPhotoRemarks;

  List<String> get _standardPhotoLabels {
    switch (controller.formType.toLowerCase()) {
      case 'b':
        return const [
          'P1: Bridge Approaches (inclusive road furniture)',
          'P2: Carriageways & Parapet Wall Condition @ 20 m intervals',
          'P3: Waterway (Upstream & Downstream)',
          'P4: Underneath the bridge (Abutments, Piers, Girders, Bearings if any)',
        ];
      case 'c':
        return const [
          'P1: Culvert Marker (LHS or RHS)',
          'P2: Waterway & Embankment (Upstream)',
          'P3: Waterway & Embankment (Downstream)',
          'P4: Headwall Wingwall (Inlet)',
          'P5: Headwall Wingwall (Outlet)',
          'P6: Barrel(s) (Culvert Unit(s))',
          'P7: Culvert Approach (Pavement)',
        ];
      default:
        return List<String>.generate(8, (index) => 'Photo ${index + 1}');
    }
  }

  String _photoTitle(int photoNumber) {
    if (photoNumber <= _standardPhotoLabels.length) {
      return _standardPhotoLabels[photoNumber - 1];
    }
    return 'Additional Photo ${photoNumber - _standardPhotoLabels.length} '
        '(Photo $photoNumber)';
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickPhoto({required int photoNo}) async {
    final ImagePicker picker = ImagePicker();

    await Get.dialog(
      PhotoPickerDialog(
        onSourceSelected: (ImageSource source) async {
          try {
            final XFile? image = await picker.pickImage(
              source: source,
              imageQuality: 80,
            );
            if (image != null) {
              final added = controller.addPhoto(
                image,
                photoNumber: photoNo,
              );
              if (!added) {
                SmartDialog.showToast(
                  'A maximum of ${controller.limitToUpload.value} photos is allowed.',
                );
              }
            }
          } catch (e) {
            debugPrint('Error picking image: $e');
            SmartDialog.showToast('Failed to pick image. Please try again.');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      body: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
          left: 5,
          right: 5,
        ),
        width: Get.width,
        height: Get.height -
            Scaffold.of(context).appBarMaxHeight!.toDouble() -
            (Get.size.shortestSide >= 600 ? 80 : 60) -
            50,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(5),
          children: [
            const SizedBox(height: 35),
            const Text.rich(
              TextSpan(
                text: "Photographs of Site",
                children: [
                  TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '(Refer to attachment)',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              switch (controller.state.value) {
                case LoaderState.initial:
                case LoaderState.loading:
                  return const SizedBox(height: 100);
                case LoaderState.loaded:
                  // If we have existing photos from server
                  if (controller.isReviewMode.value) {
                    return _buildRemotePhotosGrid();
                  }
                  // ELSE: Show local upload logic
                  else {
                    return _buildLocalUploadGrid();
                  }
                case LoaderState.failure:
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("No data available"),
                    ),
                  );
              }
            }),
            const SizedBox(height: 20),
            const Text(
              style: TextStyle(color: Colors.grey),
              "*Note: In the event of probable distress is developing, the additional photo of such distress shall be taken for future monitoring purpose.",
            ),
          ],
        ),
      ),
    );
  }


  Widget _remoteImage(
    String url, {
    double? width,
    double? height,
    BoxFit? fit,
    Color errorColor = Colors.grey,
  }) {
    Widget errorBox(Object error) {
      debugPrint('Photo failed to load: $url -> $error');
      return Container(
        width: width,
        height: height ?? 155,
        color: Colors.grey[300],
        child: Icon(Icons.broken_image, color: errorColor, size: 50),
      );
    }

    if (kIsWeb) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : const Center(child: CircularProgressIndicator()),
        errorBuilder: (context, error, stackTrace) => errorBox(error),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => errorBox(error),
    );
  }


  // Displays every remote photo in its actual numbered position, including
  // gaps such as P1 + P3 with no P2.
  Widget _buildRemotePhotosGrid() {
    if (controller.photoLinks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text("No photo available"),
        ),
      );
    }

    final photosByNumber = <int, FormPhotoListingModel>{
      for (final photo in controller.photoLinks)
        if (photo.photoNumber != 0x7fffffff) photo.photoNumber: photo,
    };
    final highestPhotoNumber = photosByNumber.keys.fold<int>(
      _standardPhotoLabels.length,
      (highest, number) => number > highest ? number : highest,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(highestPhotoNumber, (index) {
        final photoNumber = index + 1;
        final photo = photosByNumber[photoNumber];

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _photoTitle(photoNumber),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              if (photo != null) ...[
                _buildRemotePhotoPreview(photo),
                if (_supportsPhotoRemarks) ...[
                  const SizedBox(height: 6),
                  _buildRemarksField(
                    index: index,
                    photoNumber: photoNumber,
                    fieldKey: 'remote-${photo.image}',
                    initialValue: photo.remarks,
                    readOnly: true,
                  ),
                ],
              ] else
                Container(
                  height: 77,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "No file chosen",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }



  Widget _buildRemotePhotoPreview(FormPhotoListingModel photoModel) {
    final imageUrl = photoModel.image;

    return GestureDetector(
      onTap: () {
        if (imageUrl.isNotEmpty) {
          Get.to(
            () => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(
                //fix for web
                child: _remoteImage(imageUrl, errorColor: Colors.white),
                // child: CachedNetworkImage(
                //   imageUrl: imageUrl,
                //   placeholder: (context, url) =>
                //       const CircularProgressIndicator(),
                //   errorWidget: (context, url, error) =>
                //       const Icon(Icons.error, color: Colors.white),
                // ),
              ),
            ),
            transition: Transition.fadeIn,
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        //fix for web
        child: _remoteImage(
          imageUrl,
          width: double.infinity,
          height: 155,
          fit: BoxFit.cover,
        ),
        // child: CachedNetworkImage(
        //   imageUrl: imageUrl,
        //   width: double.infinity,
        //   height: 155,
        //   fit: BoxFit.cover,
        //   placeholder: (context, url) =>
        //       const Center(child: CircularProgressIndicator()),
        //   errorWidget: (context, url, error) => Container(
        //     height: 155,
        //     color: Colors.grey[300],
        //     child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
        //   ),
        // ),
      ),
    );
  }

  // Standard photo positions are independent: P1 and P3 can be selected
  // without filling P2. Additional photos use the first free number after
  // the form's reference positions.
  Widget _buildLocalUploadGrid() {
    final hasReachedPhotoLimit =
        controller.photoToUpload.length >= controller.limitToUpload.value;
    final standardPhotos = List.generate(_standardPhotoLabels.length, (index) {
      final photoNumber = index + 1;
      final uploadIndex = controller.uploadIndexForPhotoNumber(photoNumber);

      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _photoTitle(photoNumber),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            if (uploadIndex != null) ...[
              _buildLocalPhotoPreview(uploadIndex),
              if (_supportsPhotoRemarks) ...[
                const SizedBox(height: 6),
                _buildRemarksField(
                  index: uploadIndex,
                  photoNumber: photoNumber,
                  fieldKey:
                      'local-${controller.photoToUpload[uploadIndex].path}',
                  initialValue: controller.photoRemarks[uploadIndex],
                ),
              ],
            ] else
              _buildUploadButton(
                photoNo: photoNumber,
                enabled: !hasReachedPhotoLimit,
              ),
          ],
        ),
      );
    });

    final additionalUploadIndexes = List<int>.generate(
      controller.photoToUpload.length,
      (index) => index,
    ).where((index) {
      return controller.photoNumberForUploadIndex(index) >
          _standardPhotoLabels.length;
    }).toList()
      ..sort((left, right) => controller
          .photoNumberForUploadIndex(left)
          .compareTo(controller.photoNumberForUploadIndex(right)));

    final additionalPhotos = additionalUploadIndexes.map((index) {
      final photoNumber = controller.photoNumberForUploadIndex(index);
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _photoTitle(photoNumber),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            _buildLocalPhotoPreview(index),
            if (_supportsPhotoRemarks) ...[
              const SizedBox(height: 6),
              _buildRemarksField(
                index: index,
                photoNumber: photoNumber,
                fieldKey: 'local-${controller.photoToUpload[index].path}',
                initialValue: controller.photoRemarks[index],
              ),
            ],
          ],
        ),
      );
    }).toList();

    final nextAdditionalPhotoNumber = controller.nextAvailablePhotoNumber(
      startAt: _standardPhotoLabels.length + 1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...standardPhotos,
        if (_supportsPhotoRemarks) ...[
          const SizedBox(height: 4),
          const Text(
            "Additional Photos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Text(
            "Maximum ${controller.limitToUpload.value} photos",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ...additionalPhotos,
          _buildUploadButton(
            photoNo: nextAdditionalPhotoNumber,
            enabled: !hasReachedPhotoLimit &&
                nextAdditionalPhotoNumber <= controller.limitToUpload.value,
            label: hasReachedPhotoLimit
                ? "Maximum ${controller.limitToUpload.value} photos reached"
                : "Add additional photo",
          ),
        ],
      ],
    );
  }


  //fix for web photo preview
  Widget _localImage(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    if (kIsWeb) {
      return Image.network(path, width: width, height: height, fit: fit);
    }
    return Image.file(File(path), width: width, height: height, fit: fit);
  }


  Widget _buildLocalPhotoPreview(int index) {
    final photo = controller.photoToUpload[index];
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(
              () => Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                body: Center(
                  child: _localImage(photo.path),
                ),
              ),
              transition: Transition.fadeIn,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _localImage(
              (photo.path),
              width: double.infinity,
              height: 155,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              controller.removePhotoAt(index);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemarksField({
    required int index,
    required int photoNumber,
    required String fieldKey,
    required String initialValue,
    bool readOnly = false,
  }) {
    return TextFormField(
      key: ValueKey(fieldKey),
      initialValue: initialValue,
      readOnly: readOnly,
      minLines: 1,
      maxLines: 2,
      style: const TextStyle(fontSize: 14),
      textInputAction: TextInputAction.newline,
      onChanged:
          readOnly ? null : (value) => controller.setPhotoRemark(index, value),
      decoration: InputDecoration(
        label: Text.rich(
          TextSpan(
            text: 'Remarks for Photo $photoNumber',
            children: _supportsPhotoRemarks
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : const [],
          ),
        ),
        hintText: readOnly && initialValue.isEmpty
            ? 'No remarks'
            : 'Enter remarks for this photo',
        filled: true,
        fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
        alignLabelWithHint: true,
        labelStyle: const TextStyle(fontSize: 13),
        hintStyle: const TextStyle(fontSize: 13),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required int photoNo,
    required bool enabled,
    String label = "Choose photo",
  }) {
    return NeumorphicButton(
      onPressed: enabled ? () => _pickPhoto(photoNo: photoNo) : null,
      style: NeumorphicStyle(
        depth: enabled ? 4 : 0,
        color: enabled ? const Color(0xffe9f3fd) : Colors.grey.shade300,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              color: enabled ? Colors.blue.shade700 : Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(
              enabled || label != "Choose photo" ? label : "No file chosen",
              style: TextStyle(
                color: enabled ? Colors.blue.shade700 : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
