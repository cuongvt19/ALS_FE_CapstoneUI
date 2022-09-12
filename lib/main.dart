import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:capstone_ui/Components/BottomNavBar/NavItem.dart';
import 'package:capstone_ui/Components/PageRoute/route_generator.dart';
import 'package:capstone_ui/Splash/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'Home/home_screen.dart';
import 'Login/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromARGB(0, 255, 255, 255)));
    return ChangeNotifierProvider(
      create: (context) => NavItems(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'San',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSplashScreen(
//       splash: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Image.asset('assets/images/logo_ALS.png', width: 450,),
//           ],
//         ),
//       ),
//       nextScreen: LoginScreen(),
//       splashIconSize: 200,
//       duration: 3000,
//       splashTransition: SplashTransition.slideTransition,
//     );
//   }
// }
