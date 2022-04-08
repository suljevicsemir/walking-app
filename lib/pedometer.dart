
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:walking_app/pedometer_provider.dart';

class PedometerPage extends StatefulWidget {
  const PedometerPage({Key? key}) : super(key: key);

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {

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
    setState(() {

    });

  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint(event.toString());
    status = event.status;
    setState(() {

    });
  }

  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');
    status = 'Pedestrian Status not available';
    setState(() {

    });
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');
    steps = 'Step Count not available';
    setState(() {

    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) return;
  }

  Future<void> startTracking() async{
    if(await Permission.activityRecognition.isDenied) {
      final PermissionStatus status = await Permission.activityRecognition.request();
      if(status == PermissionStatus.granted) {
        initPlatformState();
      }
    }
    else {
      initPlatformState();
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startTracking();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Text(
              "Status: $status"
            ),
            Text(
              "Steps: $steps"
            )
          ],
        ),
      ),
    );
  }
}
