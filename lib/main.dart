import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Screens/weather_home.dart';
import 'package:weather_app/weather_services/weather_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => WeatherProvider()),
              ],
              child: WeatherHome(),
            ));
      },
    );
  }
}
