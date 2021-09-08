import 'package:flutter/material.dart';
import 'package:immospot/splash/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'immo spot',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),

      ),
    );
  }
}
