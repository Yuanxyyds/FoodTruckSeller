import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:food_truck_mobile/providers/auth_manager.dart';
import 'package:food_truck_mobile/providers/restaurant_manager.dart';
import 'package:food_truck_mobile/helper/theme.dart';
import 'package:food_truck_mobile/providers/user_location_provider.dart';
import 'package:food_truck_mobile/screen/account_screen.dart';
import 'package:provider/provider.dart';
import 'providers/food_manager.dart';
import 'providers/section_manager.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // runApp(DevicePreview(
  // enabled: !kReleaseMode, builder: (context) => const MyApp()));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthManager()),
    ChangeNotifierProvider(create: (_) => RestaurantManager()),
    ChangeNotifierProvider(create: (_) => SectionManager()),
    ChangeNotifierProvider(create: (_) => FoodManager()),
    ChangeNotifierProvider(create: (_) => UserLocationProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: FoodTruckThemeData.themeData,
      home: const AccountScreen(),
    );
  }
}
