import 'package:app_name/app/rider/riderhome/rider_drawer/rider_find_order.dart';
import 'package:app_name/app/rider/riderhome/rider_home_screen.dart';
import 'package:app_name/app/screens/app_screens/drawer/send_parcel.dart';
import 'package:app_name/app/screens/app_screens/intro_screen.dart';
import 'package:app_name/app/screens/auths/auth.dart';
import 'package:app_name/app/screens/auths/login.dart';
import 'package:app_name/app/screens/auths/register.dart';
import 'package:app_name/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
       home:IntroScreen(),
       //home: SendParcel(),
    );
  }
}
