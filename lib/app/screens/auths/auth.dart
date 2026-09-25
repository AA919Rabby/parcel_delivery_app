import 'package:app_name/app/configs/my_themes.dart';
import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:app_name/app/rider/rider_login.dart';
import 'package:app_name/app/screens/auths/login.dart';
import 'package:app_name/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Auth extends StatelessWidget {
  Auth({super.key});
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white base
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // Added to ensure perfect centering without overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/anime/auth.json',
                  height: 350,
                  width: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome to Ideal 360",
                  style: GoogleFonts.numans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your fast & reliable delivery partner",
                  style: GoogleFonts.numans(
                      fontSize: 14,
                      color: Colors.grey.shade600
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: CustomButton(
                      onTap: () => showSelectionDialog(context),
                      color: Colors.blueAccent,
                      label: 'Get Started',
                      labelColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSelectionDialog(BuildContext context){
    final authController = Get.find<AuthController>();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          title: Text("Select Role", textAlign: TextAlign.center, style: GoogleFonts.numans(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => GestureDetector(
                onTap: () => authController.updateRole('Rider'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: authController.selectedRole.value == 'Rider' ? Colors.blue.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: authController.selectedRole.value == 'Rider'
                          ? Colors.blueAccent
                          : Colors.grey.shade200,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: authController.selectedRole.value == 'Rider' ? Colors.blueAccent : Colors.grey.shade100,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.sports_motorsports, color: authController.selectedRole.value == 'Rider' ? Colors.white : Colors.grey.shade600)
                    ),
                    title: Text('Continue as Rider', style: GoogleFonts.numans(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),

              const SizedBox(height: 12),

              Obx(() => GestureDetector(
                onTap: () => authController.updateRole('Customer'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: authController.selectedRole.value == 'Customer' ? Colors.blue.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: authController.selectedRole.value == 'Customer'
                          ? Colors.blueAccent
                          : Colors.grey.shade200,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: authController.selectedRole.value == 'Customer' ? Colors.blueAccent : Colors.grey.shade100,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.person, color: authController.selectedRole.value == 'Customer' ? Colors.white : Colors.grey.shade600)
                    ),
                    title: Text('Continue as Customer', style: GoogleFonts.numans(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Obx(() {
              bool isSelected = authController.selectedRole.value.isNotEmpty;
              return SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isSelected
                      ? () {
                    if (authController.selectedRole.value == 'Rider') {
                      Get.back();
                      Future.delayed(const Duration(milliseconds: 300), () => Get.offAll(()=>RiderLogin(), transition: Transition.zoom));
                    } if (authController.selectedRole.value == 'Customer') {
                      Get.back();
                      Future.delayed(const Duration(milliseconds: 300), () => Get.offAll(()=>Login(), transition: Transition.zoom));
                    }
                  }
                      : null,
                  child: Text('Proceed', style: GoogleFonts.numans(color: isSelected ? Colors.white : Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}