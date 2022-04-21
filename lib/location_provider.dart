
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

  late StreamSubscription listener;
  bool _trackingInProgress = false;
  double _distanceTraveled = 0.0;




  double? _horizontalAccuracy;
  double? _verticalAccuracy;

  final List<LocationAccuracyModel> accuracyList = [];



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


  //prve 4 odbacit

  // pratit svako 10 metara

  // odbacat male i velke
  // odbacat pogresan accuracy i velike distance

  int k = 1;

  int _interval = 1000;
  double _distanceFilter = 2;


  double get distanceFilter => _distanceFilter;
  int get interval => _interval;


  set interval(int value) {
    _interval = value;
    notifyListeners();
  }

  set distanceFilter(double value) {
    _distanceFilter = value;
    notifyListeners();
  }

  Future<void> startLocationListener() async{
    trackingInProgress = true;
    _lastLocation = null;

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: _interval,
      distanceFilter: _distanceFilter
    );

    listener = _location.onLocationChanged.listen((LocationData locationData) {
      _lastLocation ??= locationData;

      final double newDistance = geolocator.Geolocator.distanceBetween(locationData.latitude!, locationData.longitude!, _lastLocation!.latitude!, _lastLocation!.longitude!);

      accuracyList.add(LocationAccuracyModel(verticalAccuracy: locationData.verticalAccuracy, horizontalAccuracy: locationData.accuracy, distance: newDistance));
      notifyListeners();



      if(k > 4 && locationData.accuracy != null && locationData.accuracy! <= 14 && locationData.accuracy! >= 0 && newDistance > 1 && newDistance < 20) {
        distanceTraveled += newDistance;
      }
      k++;
      _lastLocation = locationData;
    });
  }

  void stopTracking() {
    trackingInProgress = false;
    listener.cancel();
  }

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

  void incrementInterval() {
    _interval += 1000;
    notifyListeners();
  }

  void decrementInterval() {
    _interval -= 1000;
    notifyListeners();
  }

  void incrementDistanceFilter() {
    _distanceFilter += 1;
    notifyListeners();
  }

  void decrementDistanceFilter() {
    _distanceFilter -= 1;
    notifyListeners();
  }


}