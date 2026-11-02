import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tram/constant/pinned_position.dart';

class MacOSHomeMap extends StatelessWidget {
  const MacOSHomeMap({
    super.key,
    required this.initialCameraPosition,
    required this.pins,
    required this.onMarkerTapped,
  });

  final CameraPosition initialCameraPosition;
  final List<PinDetail> pins;
  final ValueChanged<String> onMarkerTapped;

  String _mapHtml() {
    final markerData = pins
        .map(
          (pin) => {
            'id': pin.id,
            'lat': pin.coordinate.latitude,
            'lng': pin.coordinate.longitude,
            'package': pin.pkgName,
          },
        )
        .toList(growable: false);

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    html, body, #map { width: 100%; height: 100%; margin: 0; padding: 0; overflow: hidden; }
  </style>
</head>
<body>
  <div id="map"></div>
  <script>
    const markerData = ${jsonEncode(markerData)};

    function notifyFlutter(packageName) {
      if (window.flutter_inappwebview) {
        window.flutter_inappwebview.callHandler('homeMapMarkerTapped', packageName);
      }
    }

    function initMap() {
      const map = new google.maps.Map(document.getElementById('map'), {
        center: {
          lat: ${initialCameraPosition.target.latitude},
          lng: ${initialCameraPosition.target.longitude}
        },
        zoom: ${initialCameraPosition.zoom},
        mapTypeId: 'roadmap',
        tilt: 0,
        gestureHandling: 'greedy',
        disableDefaultUI: true,
        clickableIcons: false
      });

      const locationButton = document.createElement('button');
      locationButton.type = 'button';
      locationButton.title = 'My location';
      locationButton.setAttribute('aria-label', 'My location');
      locationButton.innerHTML = '&#9678;';
      locationButton.style.cssText =
        'background:#fff;border:0;border-radius:50%;width:44px;height:44px;' +
        'margin:0 10px 10px 0;box-shadow:0 1px 4px rgba(0,0,0,.3);' +
        'font-size:27px;line-height:42px;color:#555;cursor:pointer;';
      locationButton.addEventListener('click', function() {
        if (!navigator.geolocation) {
          map.setCenter({
            lat: ${initialCameraPosition.target.latitude},
            lng: ${initialCameraPosition.target.longitude}
          });
          return;
        }
        navigator.geolocation.getCurrentPosition(
          function(position) {
            map.setCenter({
              lat: position.coords.latitude,
              lng: position.coords.longitude
            });
            map.setZoom(15);
          },
          function() {
            map.setCenter({
              lat: ${initialCameraPosition.target.latitude},
              lng: ${initialCameraPosition.target.longitude}
            });
          }
        );
      });
      map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(locationButton);

      markerData.forEach(function(item) {
        const marker = new google.maps.Marker({
          map: map,
          position: {lat: item.lat, lng: item.lng}
        });
        marker.addListener('click', function() {
          notifyFlutter(item.package);
        });
      });
    }
  </script>
  <script async src="https://maps.googleapis.com/maps/api/js?key=AIzaSyATlg5DGvaBpIvlpY17_w8Bj_FfmWwkjHo&loading=async&callback=initMap"></script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
        data: _mapHtml(),
        baseUrl: WebUri('https://localhost/'),
      ),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        transparentBackground: true,
        disableHorizontalScroll: true,
        disableVerticalScroll: true,
      ),
      onWebViewCreated: (webViewController) {
        webViewController.addJavaScriptHandler(
          handlerName: 'homeMapMarkerTapped',
          callback: (arguments) {
            if (arguments.isNotEmpty) {
              onMarkerTapped(arguments.first.toString());
            }
            return null;
          },
        );
      },
      onConsoleMessage: (_, message) {
        if (kDebugMode) {
          debugPrint('macOS home map: ${message.message}');
        }
      },
    );
  }
}
