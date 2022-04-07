
import 'dart:async';

import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {


  final Location _location = Location();
  LocationData? _lastLocation;
  bool _isFirstRun = true;
  late StreamSubscription listener;
  bool _trackingInProgress = false;
  double _distanceTraveled = 0.0;

  double _distanceDelta = 2.0;

  Future<void> startLocationListener() async{
    trackingInProgress = true;
    _lastLocation = null;

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 2000,
      distanceFilter: 10
    );

    listener = _location.onLocationChanged.listen((LocationData locationData) {
      debugPrint("Location changed!");
      debugPrint("Current latitude: ${locationData.latitude}");
      debugPrint("Current longitude: ${locationData.longitude}");

      _lastLocation ??= locationData;

      final double newDistance = geolocator.Geolocator.distanceBetween(locationData.latitude!, locationData.longitude!, _lastLocation!.latitude!, _lastLocation!.longitude!);

      if(!_isFirstRun && newDistance < _distanceDelta) {
        return;
      }
      debugPrint("Traveled distance: $newDistance");
      if(!_isFirstRun) {
        _isFirstRun = true;
      }
      distanceTraveled = distanceTraveled + newDistance;
      _lastLocation = locationData;
    });
  }

  void stopTracking() {
    trackingInProgress = false;
    listener.cancel();
  }

  void increaseDelta() {
    _distanceDelta += 0.1;
  }

  void decreaseDelta() {
    _distanceDelta -= 0.1;
  }

  double get distanceDelta => _distanceDelta;

  set trackingInProgress(bool value) {
    _trackingInProgress = value;
    notifyListeners();
  }

  bool get trackingInProgress => _trackingInProgress;

  double get distanceTraveled => _distanceTraveled;

  set distanceTraveled(double value) {
    _distanceTraveled = value;
    notifyListeners();
  }






}