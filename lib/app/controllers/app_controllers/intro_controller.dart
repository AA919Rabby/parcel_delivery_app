import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/rider/riderhome/rider_home_screen.dart';
import 'package:app_name/app/screens/app_screens/home/home_screen.dart';
import 'package:app_name/app/screens/auths/auth.dart';
import 'package:app_name/app/screens/auths/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


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
    final user = authController.auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot doc = await authController.db
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          String role = doc.get('role') ?? 'user';

          if (role == 'rider') {
            Get.offAll(() => RiderHomeScreen());
          } else {
            Get.offAll(() => HomeScreen());
          }
        } else {
          Get.offAll(() => Auth());
        }
      } catch (e) {
        Get.offAll(() => Auth());
      }
    } else {
      Get.offAll(() => Auth());
    }
  }
}