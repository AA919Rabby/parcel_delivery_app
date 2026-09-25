import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/rider_controller.dart';


class RiderDrawerScreen extends StatelessWidget {
  RiderDrawerScreen({super.key});

  final firebaseController = Get.put(FirebaseController());
  final riderController = Get.put(RiderController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade100, // Slightly lighter background
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // --- Find Order Item ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          // Left-side indicator bar
                          Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: riderController.selectedItemIndex.value == 0 ? 6.0 : 0.0,
                            color: Colors.blueAccent,
                          )),
                          Expanded(
                            child: ListTile(
                              onTap: () {
                                riderController.goToFindOrder();
                              },
                              leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: const Icon(Icons.bookmark_border, color: Colors.blueAccent)
                              ),
                              title: Text(
                                'Find order',
                                style: GoogleFonts.numans(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                'Easy delivery',
                                style: GoogleFonts.numans(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- Logout Item ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: riderController.selectedItemIndex.value == 1 ? 6.0 : 0.0,
                            color: Colors.redAccent,
                          )),
                          Expanded(
                            child: ListTile(
                              onTap: () {
                                riderController.selectLogout();
                                logout();
                              },
                              leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: const Icon(Icons.logout, color: Colors.redAccent)
                              ),
                              title: Text(
                                'Logout',
                                style: GoogleFonts.numans(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                'Logout your account',
                                style: GoogleFonts.numans(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 17),
            ],
          ),
        ),
      ),
    );
  }

  logout() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Softer corners
        ),
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle
                ),
                child: const Icon(Icons.logout, color: Colors.redAccent, size: 35),
              ),
              const SizedBox(height: 15),
              Text(
                'Logout?',
                style: GoogleFonts.numans(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'After logout you can login back.',
                textAlign: TextAlign.center,
                style: GoogleFonts.numans(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Get.back(),
                  child: Text('No', style: GoogleFonts.numans(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () {
                    firebaseController.riderLogout();
                  },
                  child: Text('Yes', style: GoogleFonts.numans(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      riderController.clearSelection();
    });
  }

  changeName() {
    // Keep exact existing logic, just made UI softer
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Text('Enter new username', style: GoogleFonts.numans(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomAuth(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                hintText: 'New username',
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 7, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Text('Back', style: GoogleFonts.numans(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Text('Confirm', style: GoogleFonts.numans(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}