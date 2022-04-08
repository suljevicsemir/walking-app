

import 'package:flutter/cupertino.dart';
import 'package:pedometer/pedometer.dart';

class PedometerProvider extends ChangeNotifier {

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;



  String status = '?', steps = '?';
  int initialSteps = 0;
  int totalSteps = 0;
  bool isInitial = true;

  void onStepCount(StepCount event) {
    debugPrint(event.toString());
    if (isInitial) {
        initialSteps = event.steps;
        steps = '0';
        isInitial = false;
      } else {
        totalSteps = event.steps - initialSteps;
        double distance = 1.92 * 0.414 * totalSteps;
        steps = distance.toString();
    }
    notifyListeners();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint(event.toString());
    status = event.status;
    notifyListeners();
  }

  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');
    status = 'Pedestrian Status not available';
    notifyListeners();
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');
    steps = 'Step Count not available';
    notifyListeners();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    notifyListeners();
    //if (!mounted) return;
  }

}