import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/rider/riderhome/rider_home_screen.dart';
import 'package:app_name/app/screens/app_screens/home/home_screen.dart';
import 'package:app_name/app/screens/auths/auth.dart';
import 'package:app_name/app/screens/auths/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- ADDED

class IntroController extends GetxController {
  final authController = Get.put(AuthController());
  final firebaseController = Get.put(FirebaseController());

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 4), () {
      checkUser();
    });
    super.onInit();
  }

  Future<void> checkUser() async {
    // --- ADDED: Safely Check User Logged In locally first ---
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String role = prefs.getString('userRole') ?? '';

    // Automatically put them through if they successfully logged in before (Solves offline kickouts)
    if (isLoggedIn && role.isNotEmpty) {
      if (role == 'rider') {
        Get.offAll(() => RiderHomeScreen());
      } else {
        Get.offAll(() => HomeScreen());
      }
      return;
    }
    // ---------------------------------------------------------

    // Original Logic (FallBack Mechanism for existing old logins)
    final user = authController.auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot doc = await authController.db
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          String fetchedRole = doc.get('role') ?? 'user';

          // Save the cache here too, so next time it works perfectly
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userRole', fetchedRole);

          if (fetchedRole == 'rider') {
            Get.offAll(() => RiderHomeScreen());
          } else {
            Get.offAll(() => HomeScreen());
          }
        } else {
          Get.offAll(() => Auth());
        }
      } catch (e) {
        Get.offAll(() => Auth()); // if it fails, fallback
      }
    } else {
      Get.offAll(() => Auth());
    }
  }
}