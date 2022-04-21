import 'package:flutter/material.dart';
import 'package:walking_app/location_provider.dart';
import 'package:provider/provider.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //attachListener();
  }

  void attachListener() {
    if(scrollController.hasClients) {
      scrollController.addListener(() {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
    else {
      Future.delayed(const Duration(milliseconds: 100), () {
        attachListener();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationProvider>();

    return Scaffold(
      floatingActionButton: _PageFloatingButton(isTracking: provider.trackingInProgress,),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Changing parameters during testing may lead to inconsistent data",
              style: TextStyle(
                color: Colors.red
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                      "Current tracked delta: ${provider.distanceFilter}"
                  ),
                  IconButton(
                    onPressed: () => provider.incrementDistanceFilter(),
                    icon: const Icon(Icons.add, size: 16,),
                    splashRadius: 20,
                  ),
                  IconButton(
                    onPressed: () => provider.decrementDistanceFilter(),
                    icon: const Icon(Icons.remove, size: 16,),
                    splashRadius: 20,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                      "Current tracked interval: ${provider.interval}"
                  ),
                  IconButton(
                    onPressed: () => provider.incrementInterval(),
                    icon: const Icon(Icons.add, size: 16,),
                    splashRadius: 20,
                  ),
                  IconButton(
                    onPressed: () => provider.decrementInterval(),
                    icon: const Icon(Icons.remove, size: 16,),
                    splashRadius: 20,
                  )
                ],
              ),
            ),
            const SizedBox(height: 40,),
            const Center(
              child: Text(
                "Traveled distance",
                style: TextStyle(
                  fontSize: 30
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              "${provider.distanceTraveled.toStringAsFixed(4)} m",
              style: const TextStyle(
                fontSize: 40
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: provider.accuracyList.length,
                itemBuilder: (ctx, index) => AccuracyListItem(model: provider.accuracyList[index])
              ),
            )
          ],
        )
      ),
    );
  }
}

class AccuracyListItem extends StatelessWidget {
  const AccuracyListItem({Key? key, required this.model}) : super(key: key);

  final LocationAccuracyModel model;

  bool get accurate {
    return model.horizontalAccuracy != null && model.horizontalAccuracy! <= 14;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: accurate ? const BoxDecoration() : const BoxDecoration(color: Colors.red),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Horizontal accuracy: ${model.horizontalConvert}"
              ),
              const SizedBox(height: 5,),
              Text(
                  "Vertical accuracy: ${model.verticalConvert}"
              ),
              const SizedBox(height: 5,),
            ],
          ),
          const SizedBox(width: 15,),
          Text(
            "Distance: ${model.distance.toStringAsFixed(2)}"
          )
        ],
      ),
    );
  }
}


class _PageFloatingButton extends StatelessWidget {
  const _PageFloatingButton({
    Key? key,
    required this.isTracking
  }) : super(key: key);

  final bool isTracking;


  @override
  Widget build(BuildContext context) {
    return isTracking ?
    ElevatedButton(
      onPressed: () {
        context.read<LocationProvider>().stopTracking();
      },
      child: Text("Stop tracking")
    ) :
    ElevatedButton(
      onPressed: () {
          context.read<LocationProvider>().checkPermission();
      },
      child: Text("Start location listener")
    );
  }
}


