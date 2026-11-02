import 'package:google_maps_flutter/google_maps_flutter.dart';

const List<PinDetail> pinedLocations = [
  PinDetail(
    "1-1",
    LatLng(
      1.2834830403352377,
      110.42556522983388,
    ),
    "Package 1",
  ),
  PinDetail(
    "1-2",
    LatLng(
      2.297784623113086,
      111.84103569401579,
    ),
    "Package 1",
  ),
  PinDetail(
    "2-1",
    LatLng(
      1.2304647635186923,
      111.4723675089652,
    ),
    "Package 2",
  ),
  PinDetail(
    "2-2",
    LatLng(
      1.4217208571897861,
      111.50693276153415,
    ),
    "Package 2",
  ),
  PinDetail(
    "3-1",
    LatLng(
      2.8998483827101174,
      112.09321593354606,
    ),
    "Package 3",
  ),
  PinDetail(
    "4-1",
    LatLng(
      4.399178268314965,
      113.99149287544238,
    ),
    "Package 4",
  ),
  PinDetail(
    "5-1",
    LatLng(
      3.1712537341773066,
      113.04189461576561,
    ),
    "Package 5",
  ),
  PinDetail(
    "5-2",
    LatLng(
      4.711881981100366,
      114.98787223343257,
    ),
    "Package 5",
  ),
];

class PinDetail {
  final String id;
  final LatLng coordinate;
  final String pkgName;

  const PinDetail(
    this.id,
    this.coordinate,
    this.pkgName,
  );
}
