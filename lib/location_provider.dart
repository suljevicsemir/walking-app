
import 'dart:async';


import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

@immutable
class LocationAccuracyModel {

  const LocationAccuracyModel({required this.verticalAccuracy, required this.horizontalAccuracy, required this.distance});

  final double? verticalAccuracy;
  final double? horizontalAccuracy;
  final double distance;

  String get verticalConvert {
    return verticalAccuracy == null ? "UNKNOWN" : verticalAccuracy!.toStringAsFixed(2);
  }
  String get horizontalConvert {
    return horizontalAccuracy == null ? "UNKNOWN" : horizontalAccuracy!.toStringAsFixed(2);
  }

}

class LocationProvider extends ChangeNotifier {


  final Location _location = Location();
  LocationData? _lastLocation;
  bool _isFirstRun = true;
  late StreamSubscription listener;
  bool _trackingInProgress = false;
  double _distanceTraveled = 0.0;

  double _distanceDelta = 1.0;

  double? _horizontalAccuracy;
  double? _verticalAccuracy;

  final List<LocationAccuracyModel> accuracyList = [
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
    // LocationAccuracyModel(verticalAccuracy: 20, horizontalAccuracy: 20, distance: 15),
  ];



  //util method to check permission
  Future<void> checkPermission() async{
    final PermissionStatus status = await _location.hasPermission();
    if(status == PermissionStatus.granted) {
      startLocationListener();
    }
    else {
      final PermissionStatus newStatus = await _location.requestPermission();
      if(newStatus == PermissionStatus.granted) {
        startLocationListener();
      }
    }
  }

  Future<void> startLocationListener() async{
    trackingInProgress = true;
    _lastLocation = null;



    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 2000,
      distanceFilter: 0
    );

    listener = _location.onLocationChanged.listen((LocationData locationData) {
      // debugPrint("Location changed!");
      // debugPrint("Current latitude: ${locationData.latitude}");      // debugPrint("Current longitude: ${locationData.longitude}");

      _lastLocation ??= locationData;

      final double newDistance = geolocator.Geolocator.distanceBetween(locationData.latitude!, locationData.longitude!, _lastLocation!.latitude!, _lastLocation!.longitude!);

      accuracyList.add(LocationAccuracyModel(verticalAccuracy: locationData.verticalAccuracy, horizontalAccuracy: locationData.accuracy, distance: newDistance));
      notifyListeners();

      //adding to total distance if horizontal accuracy is less or equal to 11
      if(locationData.accuracy != null && locationData.accuracy! <= 11 && locationData.accuracy! >= 0) {
        distanceTraveled = distanceTraveled + newDistance;
      }


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


  set horizontalAccuracy(double? value) {
    _horizontalAccuracy = value;
    notifyListeners();
  }

  double? get horizontalAccuracy => _horizontalAccuracy;

  set verticalAccuracy(double? value) {
    _verticalAccuracy = value;
    notifyListeners();
  }

  double? get verticalAccuracy => _verticalAccuracy;








}