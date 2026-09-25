import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/screens/app_screens/drawer/pricing_screen.dart';
import 'package:app_name/app/screens/app_screens/drawer/recently_send.dart';
import 'package:app_name/app/screens/app_screens/drawer/send_parcel.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/app_drawer_controller.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});

  final firebaseController = Get.put(FirebaseController());
  final authController = Get.put(AuthController());
  final appDrawerController = Get.put(AppDrawerController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade100, // Lighter, cleaner background
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // --- Send Parcel ---
              _buildDrawerItem(
                context: context,
                index: 0,
                icon: Icons.local_shipping,
                title: 'Send Parcel',
                subtitle: 'Fast Delivery',
                iconColor: Colors.blueAccent,
                onTap: () => appDrawerController.goToSendParcel(),
              ),

              // --- Recently Send ---
              _buildDrawerItem(
                context: context,
                index: 1,
                icon: Icons.history,
                title: 'Recently send',
                subtitle: 'Secure & Safe',
                iconColor: Colors.blueAccent,
                onTap: () => appDrawerController.goToRecentlySend(),
              ),

              // --- Check Rates / Pricing ---
              _buildDrawerItem(
                context: context,
                index: 2,
                icon: Icons.calculate_outlined,
                title: 'Pricing',
                subtitle: 'Lowest charge',
                iconColor: Colors.blueAccent,
                onTap: () => appDrawerController.goToPricing(),
              ),

              // --- Logout ---
              _buildDrawerItem(
                context: context,
                index: 3,
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Logout your account',
                iconColor: Colors.redAccent,
                indicatorColor: Colors.redAccent,
                onTap: () {
                  appDrawerController.selectLogout();
                  logout();
                },
              ),
              const SizedBox(height: 17),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
    Color indicatorColor = Colors.blueAccent,
  }) {
    return Padding(
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
                  width: appDrawerController.selectedItemIndex.value == index ? 6.0 : 0.0,
                  color: indicatorColor,
                )),
                Expanded(
                  child: ListTile(
                    onTap: onTap,
                    leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Icon(icon, color: iconColor)
                    ),
                    title: Text(
                      title,
                      style: GoogleFonts.numans(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      subtitle,
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
    );
  }

  logout() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.logout, color: Colors.redAccent, size: 35),
              ),
              const SizedBox(height: 15),
              Text('Logout?', style: GoogleFonts.numans(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('After logout you can login back.', textAlign: TextAlign.center, style: GoogleFonts.numans(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.grey.shade200, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                appDrawerController.clearSelection();
                Get.back();
                },
                  child: Text('No', style: GoogleFonts.numans(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    appDrawerController.clearSelection();
                    authController.logoutUser();
                  },
                  child: Text('Yes', style: GoogleFonts.numans(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      appDrawerController.clearSelection();
    });
  }
}