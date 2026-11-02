import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/controller/form_depot/common/inspection_draft_support.dart';
import 'package:tram/model/form/form_depot/common/form_photo_listing_model.dart';
import 'package:tram/provider/api_provider.dart';
import 'package:tram/repository/form_repository.dart';

class _TestAuthController extends AuthController {
  @override
  String? getUserType() => 'Service Provider';
}

class _RecordingApiProvider extends ApiProvider {
  final List<Map<String, dynamic>> requests = [];

  @override
  Future<dio.Response<dynamic>> store(
    String url, {
    Map<String, dynamic> data = const {},
  }) async {
    requests.add(Map<String, dynamic>.from(data));
    return dio.Response<dynamic>(
      requestOptions: dio.RequestOptions(path: url),
      statusCode: 200,
      data: {'http_status': 'Success.', 'data': 'Photo saved successfully'},
    );
  }
}

class _EventuallyConsistentPhotoProvider extends ApiProvider {
  int listCalls = 0;

  @override
  Future<dio.Response<dynamic>> store(
    String url, {
    Map<String, dynamic> data = const {},
  }) async {
    listCalls++;
    return dio.Response<dynamic>(
      requestOptions: dio.RequestOptions(path: url),
      statusCode: 200,
      data: {
        'http_status': 'Success.',
        'data': listCalls < 3
            ? []
            : [
                {
                  'image': 'photo1.jpg',
                  'photoNo': 'photo1',
                  'userRemarks': 'visible remark',
                }
              ],
      },
    );
  }
}

class _TwentyPhotoProvider extends ApiProvider {
  Map<String, dynamic>? request;

  @override
  Future<dio.Response<dynamic>> store(
    String url, {
    Map<String, dynamic> data = const {},
  }) async {
    request = Map<String, dynamic>.from(data);
    return dio.Response<dynamic>(
      requestOptions: dio.RequestOptions(path: url),
      statusCode: 200,
      data: {
        'http_status': 'Success.',
        'data': List.generate(
          20,
          (index) => {
            'image': 'photo${index + 1}.jpg',
            'photoNo': 'photo${index + 1}',
            'userRemarks': 'Remark ${index + 1}',
          },
        ).reversed.toList(),
      },
    );
  }
}

class _RemarkEventuallyConsistentPhotoProvider extends ApiProvider {
  int listCalls = 0;

  @override
  Future<dio.Response<dynamic>> store(
    String url, {
    Map<String, dynamic> data = const {},
  }) async {
    if (url.contains('photoUpload')) {
      // Photo upload always succeeds; only the list endpoint below lags.
      return dio.Response<dynamic>(
        requestOptions: dio.RequestOptions(path: url),
        statusCode: 200,
        data: {'http_status': 'Success.', 'data': 'Photo saved successfully'},
      );
    }

    listCalls++;
    // The photo row is visible from the very first read, but the backend
    // writes its remark in a slower follow-up step that only shows up from
    // the 3rd read onward.
    final remark = listCalls < 3 ? '' : 'visible remark';
    return dio.Response<dynamic>(
      requestOptions: dio.RequestOptions(path: url),
      statusCode: 200,
      data: {
        'http_status': 'Success.',
        'data': [
          {
            'image': 'photo1.jpg',
            'photoNo': 'photo1',
            'userRemarks': remark,
          }
        ],
      },
    );
  }
}

class _PartialPhotoUploadProvider extends ApiProvider {
  final List<Map<String, dynamic>> uploadRequests = [];

  @override
  Future<dio.Response<dynamic>> store(
    String url, {
    Map<String, dynamic> data = const {},
  }) async {
    if (url.contains('listPhoto')) {
      return dio.Response<dynamic>(
        requestOptions: dio.RequestOptions(path: url),
        statusCode: 200,
        data: {
          'http_status': 'Success.',
          'data': [
            {
              'image': 'photo1.jpg',
              'photoNo': 'photo1',
              'userRemarks': 'first remark',
            }
          ],
        },
      );
    }

    uploadRequests.add(Map<String, dynamic>.from(data));
    return dio.Response<dynamic>(
      requestOptions: dio.RequestOptions(path: url),
      statusCode: 200,
      data: {'http_status': 'Success.', 'data': 'Photo saved successfully'},
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          pathProviderChannel, (_) async => '/private/tmp');
  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  group('FormPhotoListingModel remarks', () {
    for (final entry in {
      'user_remarks': 'documented',
      'userRemarks': 'camel case',
      'USER_REMARKS': 'upper case',
      'remarks': 'legacy plural',
      'remark': 'legacy singular',
      'photo_remarks': 'photo prefix',
      'photoRemarks': 'photo camel case',
    }.entries) {
      test('reads ${entry.key}', () {
        final model = FormPhotoListingModel.fromJson({
          'image': 'photo.jpg',
          'photoNo': 'photo1',
          entry.key: entry.value,
        });

        expect(model.remarks, entry.value);
      });
    }

    test('uses an empty remark when the response omits it', () {
      final model = FormPhotoListingModel.fromJson({
        'image': 'photo.jpg',
        'photoNo': 'photo1',
      });

      expect(model.remarks, isEmpty);
    });
  });

  test('orders Form C photos by photoNo without losing remark associations',
      () {
    final response = FormPhotoListingDataModel.fromJson({
      'http_status': 'Success.',
      'data': [
        {
          'image': 'photo3.jpg',
          'photoNo': 'photo3',
          'userRemarks': 'third remark',
        },
        {
          'image': 'photo1.jpg',
          'photoNo': 'photo1',
          'userRemarks': 'first remark',
        },
        {
          'image': 'photo2.jpg',
          'photoNo': 'photo2',
          'userRemarks': 'second remark',
        },
      ],
    });

    final orderedPhotos = response.orderedByPhotoNumber();

    expect(
      orderedPhotos.map((photo) => photo.photoNo),
      ['photo1', 'photo2', 'photo3'],
    );
    expect(
      orderedPhotos.map((photo) => photo.remarks),
      ['first remark', 'second remark', 'third remark'],
    );
  });

  test('supports additional photos and reports every missing photo remark', () {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(_RecordingApiProvider());
    final controller = BaseFormController();

    for (var index = 0; index < 9; index++) {
      controller.addPhoto(XFile('/private/tmp/photo${index + 1}.jpg'));
      controller.setPhotoRemark(index, 'Remark ${index + 1}');
    }
    controller.setPhotoRemark(1, '  ');
    controller.setPhotoRemark(8, '');

    expect(controller.photoToUpload, hasLength(9));
    expect(controller.photoRemarks, hasLength(9));
    expect(controller.missingPhotoRemarkNumbers, [2, 9]);
  });

  test('preserves sparse photo positions and enables an additional photo',
      () async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    final apiProvider =
        Get.put<ApiProvider>(_RecordingApiProvider()) as _RecordingApiProvider;
    final controller = BaseFormController()
      ..formType = 'C'
      ..repository = FormRepository(formType: 'C');

    expect(
      controller.addPhoto(
        XFile.fromData(Uint8List.fromList([1]), name: 'p1.jpg'),
        photoNumber: 1,
      ),
      isTrue,
    );
    expect(
      controller.addPhoto(
        XFile.fromData(Uint8List.fromList([3]), name: 'p3.jpg'),
        photoNumber: 3,
      ),
      isTrue,
    );

    final additionalPhotoNumber =
        controller.nextAvailablePhotoNumber(startAt: 8);
    expect(additionalPhotoNumber, 8);
    expect(
      controller.addPhoto(
        XFile.fromData(Uint8List.fromList([8]), name: 'additional.jpg'),
        photoNumber: additionalPhotoNumber,
      ),
      isTrue,
    );

    controller.setPhotoRemark(0, 'P1 overview');
    controller.setPhotoRemark(1, 'P3 downstream');
    controller.setPhotoRemark(2, 'Additional P3 distress');

    expect(controller.selectedPhotoNumbers, [1, 3, 8]);
    expect(controller.uploadIndexForPhotoNumber(2), isNull);
    expect(controller.uploadIndexForPhotoNumber(3), 1);
    expect(controller.missingPhotoRemarkNumbers, isEmpty);

    await controller.uploadPhoto(
      'inspection-sparse',
      clearPendingOnSuccess: false,
    );

    expect(
      apiProvider.requests.map((request) => request['photoNo']),
      ['photo1', 'photo3', 'photo8'],
    );
    expect(
      apiProvider.requests.map((request) => request['userRemarks']),
      ['P1 overview', 'P3 downstream', 'Additional P3 distress'],
    );
  });

  test('restores sparse photo positions from a draft', () {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(_RecordingApiProvider());
    final source = BaseFormController();

    source.addPhoto(XFile('/private/tmp/p1.jpg'), photoNumber: 1);
    source.addPhoto(XFile('/private/tmp/p3.jpg'), photoNumber: 3);
    source.setPhotoRemark(0, 'P1 remark');
    source.setPhotoRemark(1, 'P3 remark');

    final data = <String, dynamic>{};
    InspectionDraftSupport.addCommonData(
      data,
      baseController: source,
      useCurrentLocation: false,
    );
    final mediaPaths = InspectionDraftSupport.encodeMediaPaths(source);

    final restored = BaseFormController();
    InspectionDraftSupport.restoreCommonData(
      data,
      mediaPaths: mediaPaths,
      baseController: restored,
    );

    expect(restored.selectedPhotoNumbers, [1, 3]);
    expect(restored.photoRemarks.take(2), ['P1 remark', 'P3 remark']);
  });

  test('Forms G and R support the same required photo remarks as B and C', () {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(_RecordingApiProvider());
    final controller = BaseFormController();

    for (final formType in ['B', 'C', 'G', 'R']) {
      controller.formType = formType;
      expect(
        controller.supportsPhotoRemarks,
        isTrue,
        reason: 'Form $formType must display and validate photo remarks',
      );
    }

    controller.formType = 'M';
    expect(controller.supportsPhotoRemarks, isFalse);
  });

  test('limits inspection uploads to 20 photos', () {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(_RecordingApiProvider());
    final controller = BaseFormController();

    for (var index = 0; index < 20; index++) {
      expect(
        controller.addPhoto(XFile('/private/tmp/photo${index + 1}.jpg')),
        isTrue,
      );
    }

    expect(
      controller.addPhoto(XFile('/private/tmp/photo21.jpg')),
      isFalse,
    );
    expect(controller.photoToUpload, hasLength(20));
    expect(controller.hasExceededPhotoLimit, isFalse);
  });

  test('loads and orders all 20 photos for inspection details', () async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    final apiProvider = Get.put<ApiProvider>(
      _TwentyPhotoProvider(),
    ) as _TwentyPhotoProvider;
    final controller = BaseFormController()
      ..formType = 'B'
      ..recID = 'inspection-20'
      ..repository = FormRepository(formType: 'B');

    await controller.loadPhoto();

    expect(apiProvider.request, containsPair('recID', 'inspection-20'));
    expect(apiProvider.request, containsPair('limit', '20'));
    expect(controller.photoLinks, hasLength(20));
    expect(controller.photoLinks.first.photoNo, 'photo1');
    expect(controller.photoLinks.last.photoNo, 'photo20');
  });

  test('keeps additional photo remarks aligned when a photo is removed', () {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(_RecordingApiProvider());
    final controller = BaseFormController();

    for (var index = 0; index < 9; index++) {
      controller.addPhoto(XFile('/private/tmp/photo${index + 1}.jpg'));
      controller.setPhotoRemark(index, 'Remark ${index + 1}');
    }

    controller.removePhotoAt(3);

    expect(controller.photoToUpload, hasLength(8));
    expect(controller.photoRemarks, hasLength(8));
    expect(controller.photoRemarks[3], 'Remark 5');
    expect(controller.photoRemarks.last, 'Remark 9');
  });

  test('keeps Form C photos and remarks until the full submission succeeds',
      () async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    final apiProvider =
        Get.put<ApiProvider>(_RecordingApiProvider()) as _RecordingApiProvider;
    final controller = BaseFormController()
      ..formType = 'C'
      ..repository = FormRepository(formType: 'C');
    controller.photoToUpload.assignAll([
      XFile.fromData(
        Uint8List.fromList([1, 2, 3]),
        name: 'photo1.jpg',
        mimeType: 'image/jpeg',
      ),
      XFile.fromData(
        Uint8List.fromList([4, 5, 6]),
        name: 'photo2.jpg',
        mimeType: 'image/jpeg',
      ),
    ]);
    controller.photoRemarks.value = ['first remark', 'second remark'];

    await controller.uploadPhoto(
      'inspection-1',
      clearPendingOnSuccess: false,
    );

    expect(controller.photoToUpload, hasLength(2));
    expect(controller.photoRemarks, ['first remark', 'second remark']);
    expect(apiProvider.requests, hasLength(2));
    expect(apiProvider.requests[0], containsPair('photoNo', 'photo1'));
    expect(
        apiProvider.requests[0], containsPair('userRemarks', 'first remark'));
    expect(
        apiProvider.requests[0], containsPair('user_remarks', 'first remark'));
    expect(apiProvider.requests[1], containsPair('photoNo', 'photo2'));
    expect(
      apiProvider.requests[1],
      containsPair('userRemarks', 'second remark'),
    );
    expect(
      apiProvider.requests[1],
      containsPair('user_remarks', 'second remark'),
    );

    controller.clearPendingPhotos();

    expect(controller.photoToUpload, isEmpty);
    expect(controller.photoRemarks, everyElement(isEmpty));
  });

  test('pending sync resumes after photos already uploaded successfully',
      () async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    final apiProvider = Get.put<ApiProvider>(
      _PartialPhotoUploadProvider(),
    ) as _PartialPhotoUploadProvider;
    final controller = BaseFormController()
      ..formType = 'C'
      ..repository = FormRepository(formType: 'C');
    controller.photoToUpload.assignAll([
      XFile.fromData(
        Uint8List.fromList([1, 2, 3]),
        name: 'photo1.jpg',
        mimeType: 'image/jpeg',
      ),
      XFile.fromData(
        Uint8List.fromList([4, 5, 6]),
        name: 'photo2.jpg',
        mimeType: 'image/jpeg',
      ),
    ]);
    controller.photoRemarks.value = ['first remark', 'second remark'];

    await controller.uploadPhoto(
      'inspection-partial',
      clearPendingOnSuccess: false,
      resumeExistingUploads: true,
    );

    expect(apiProvider.uploadRequests, hasLength(1));
    expect(
        apiProvider.uploadRequests.single, containsPair('photoNo', 'photo2'));
  });

  test('keeps Form C photo state when a selected file cannot be read',
      () async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    final apiProvider =
        Get.put<ApiProvider>(_RecordingApiProvider()) as _RecordingApiProvider;
    final controller = BaseFormController()
      ..formType = 'C'
      ..repository = FormRepository(formType: 'C');
    controller.photoToUpload.assignAll([
      XFile('/__form_c_missing_photo__/photo1.jpg'),
    ]);
    controller.photoRemarks.value = ['must remain'];

    await expectLater(
      controller.uploadPhoto(
        'inspection-1',
        clearPendingOnSuccess: false,
      ),
      throwsA(isA<StateError>()),
    );

    expect(controller.photoToUpload, hasLength(1));
    expect(controller.photoRemarks, ['must remain']);
    expect(apiProvider.requests, isEmpty);
  });

  test('retries until a newly uploaded photo is visible', () async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    final apiProvider = Get.put<ApiProvider>(
      _EventuallyConsistentPhotoProvider(),
    ) as _EventuallyConsistentPhotoProvider;
    final controller = BaseFormController()
      ..formType = 'C'
      ..repository = FormRepository(formType: 'C');

    final result = await controller.waitForUploadedPhotos(
      'inspection-1',
      expectedCount: 1,
      attempts: 3,
    );

    expect(apiProvider.listCalls, 3);
    expect(result.data.single.image, 'photo1.jpg');
    expect(result.data.single.remarks, 'visible remark');
  });

  test(
      'shows a newly uploaded photo immediately, then fills in its remark '
      'in the background instead of delaying the photo for it', () async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    final apiProvider = Get.put<ApiProvider>(
      _RemarkEventuallyConsistentPhotoProvider(),
    ) as _RemarkEventuallyConsistentPhotoProvider;
    // Use an inspection ID no other test in this file touches: the upload
    // tracking maps are static, so a shared ID could leak state between
    // tests depending on run order.
    const inspectionID = 'inspection-remark-race';
    final controller = BaseFormController()
      ..formType = 'C'
      ..recID = inspectionID
      ..repository = FormRepository(formType: 'C');
    controller.photoToUpload.assignAll([
      XFile.fromData(
        Uint8List.fromList([1, 2, 3]),
        name: 'photo1.jpg',
        mimeType: 'image/jpeg',
      ),
    ]);
    controller.photoRemarks.value = ['visible remark'];

    // The photo row is visible on the very first read (count is already
    // satisfied), but the backend writes its remark in a slower follow-up
    // step that only shows up from the 3rd read onward.
    await controller.uploadPhoto(inspectionID, clearPendingOnSuccess: false);

    final stopwatch = Stopwatch()..start();
    await controller.loadPhoto();
    stopwatch.stop();

    // The photo itself must appear right away - it must not be held back
    // behind the remark, which the mock only reveals on the 3rd list call.
    expect(controller.photoLinks, hasLength(1));
    expect(controller.photoLinks.single.remarks, isEmpty);
    expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 400)));

    // The background catch-up then fills the remark in on the same,
    // already-displayed entry, with no further action from the caller.
    await Future.delayed(const Duration(milliseconds: 2000));

    expect(apiProvider.listCalls, 3);
    expect(controller.photoLinks.single.remarks, 'visible remark');
  });
}
