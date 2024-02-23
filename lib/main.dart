// import 'dart:io';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:foodie_user_app/bottomnavigation.dart';
// import 'package:foodie_user_app/viewRestaurant.dart';
// import 'package:get/get.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'Cert.dart';
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// void main() async {
//   HttpOverrides.global = DevHttpOverrides();
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Services.init();
//   // await PushNotificationService.setupInteractedMessage();
//   runApp(const MyApp());
//   configLoading();
// }
//
// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//     ..loadingStyle = EasyLoadingStyle.dark
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..progressColor = Colors.yellow
//     ..backgroundColor = Colors.green
//     ..indicatorColor = Colors.yellow
//     ..textColor = Colors.yellow
//     ..maskColor = Colors.blue.withOpacity(0.5)
//     ..userInteractions = false
//     ..dismissOnTap = false;
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       navigatorKey: navigatorKey,
//       builder: (context, child) {
//         child = ResponsiveWrapper.builder(
//           BouncingScrollWrapper.builder(context, child!),
//           maxWidth: 1200,
//           minWidth: 450,
//           defaultScale: true,
//           breakpoints: [
//             const ResponsiveBreakpoint.resize(450, name: MOBILE),
//             const ResponsiveBreakpoint.autoScale(450, name: MOBILE),
//             const ResponsiveBreakpoint.resize(700, name: TABLET),
//             const ResponsiveBreakpoint.autoScale(700, name: TABLET),
//             const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
//             const ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
//           ],
//         );
//         child = EasyLoading.init()(context, child);
//         return child;
//       },
//       title: 'GTSuvai',
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//         fontFamily: 'sans',
//       ),
//       debugShowCheckedModeBanner: false,
//       home: AnimatedSplashScreen(
//         splash: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/abc.gif'),fit: BoxFit.fill
//             )
//           ),
//         ),
//         duration: 4000,
//         nextScreen:  viewRestaurant(),
//         splashIconSize: double.infinity,
//         backgroundColor: Color(0xffFBFBF9),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:foodie_user_app/viewRestaurant.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'Bottomnavigation.dart';

import 'mapnavigation.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        child = ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(450, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(450, name: MOBILE),
            const ResponsiveBreakpoint.resize(700, name: TABLET),
            const ResponsiveBreakpoint.autoScale(700, name: TABLET),
            const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
          ],
        );
        child = EasyLoading.init()(context, child);
        return child;
      },
      title: 'GT Suvai User MongoDb',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                bottomnavigation(),
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/abc.gif"),fit: BoxFit.fill)),
      //  color: Colors.white,
      // child:FlutterLogo(size:MediaQuery.of(context).size.height)
    );
  }
}