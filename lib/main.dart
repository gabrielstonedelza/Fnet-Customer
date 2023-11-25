import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fnet_customer/splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'dashboard.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // darkTheme: Themes.dark,
      theme: ThemeData(
          // scaffoldBackgroundColor: backgroundColor,
          // textTheme: GoogleFonts.sansitaSwashedTextTheme(Theme.of(context).textTheme),
          ),
      defaultTransition: Transition.leftToRight,
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const Splash()),
        GetPage(name: "/login", page: () => const LoginView()),
        GetPage(name: "/dashboard", page: () => const DashBoard()),
      ],
    );
  }
}
