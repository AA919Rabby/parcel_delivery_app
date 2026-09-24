import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/screens/app_screens/drawer/pricing_screen.dart';
import 'package:app_name/app/screens/app_screens/drawer/recently_send.dart';
import 'package:app_name/app/screens/app_screens/drawer/send_parcel.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      backgroundColor: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            /*Container(
              height:280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(17),
              ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: Offset(0,0)
                  )
                ],
              ),
              ///TODO profile section
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60,),
                    GestureDetector(
                      onTap: (){
                        firebaseController.pickImage();
                      },
                      child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.02),
                                  blurRadius: 10,
                                  spreadRadius: 10,
                                  offset: Offset(0,0)
                              )
                            ],
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(CupertinoIcons.photo_fill,
                                  color: Colors.grey,size: 100,),
                                Icon(CupertinoIcons.add,
                                  color: Colors.black.withOpacity(.4),size: 40,),
                              ],
                            ),
                          )),
                    ),
                 InkWell(
                   onTap: (){
                     changeName();
                   },
                   child: Padding(
                     padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                             Center(child: Icon(Icons.edit,color: Colors.grey.shade300,size: 25,)),
                         const SizedBox(width: 45,),
                         Text('Rabbi',style: GoogleFonts.numans(
                           color: Colors.white,
                           fontSize: 23,
                           fontWeight: FontWeight.bold,
                           letterSpacing: 1.2,
                         ),),
                     ],),
                   ),
                 ),
                ],
              ),
            ),*/

            // --- Send Parcel ---
            Padding(
              padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blue.withOpacity(.2), width: 0.5),
                  color: Colors.white.withOpacity(.7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Left-side low width, full height blue indicator
                        Obx(() => Container(
                          width: appDrawerController.selectedItemIndex.value == 0 ? 5.0 : 0.0,
                          color: Colors.blue,
                        )),
                        Expanded(
                          child: ListTile(
                            onTap: () {
                              appDrawerController.goToSendParcel();
                            },
                            leading: const Icon(Icons.local_shipping, color: Colors.blue),
                            title: Text(
                              'Send Parcel',
                              style: GoogleFonts.numans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Fast Delivery',
                              style: GoogleFonts.numans(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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

            // --- Recently Send ---
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 17, right: 17),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blue.withOpacity(.2), width: 0.5),
                  color: Colors.white.withOpacity(.7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Left-side low width, full height blue indicator
                        Obx(() => Container(
                          width: appDrawerController.selectedItemIndex.value == 1 ? 5.0 : 0.0,
                          color: Colors.blue,
                        )),
                        Expanded(
                          child: ListTile(
                            onTap: () {
                              appDrawerController.goToRecentlySend();
                            },
                            leading: const Icon(Icons.history, color: Colors.blue),
                            title: Text(
                              'Recently send',
                              style: GoogleFonts.numans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Secure & Safe',
                              style: GoogleFonts.numans(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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

            // --- Check Rates / Pricing ---
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 17, right: 17),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blue.withOpacity(.2), width: 0.5),
                  color: Colors.white.withOpacity(.7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Left-side low width, full height blue indicator
                        Obx(() => Container(
                          width: appDrawerController.selectedItemIndex.value == 2 ? 5.0 : 0.0,
                          color: Colors.blue,
                        )),
                        Expanded(
                          child: ListTile(
                            onTap: () {
                              appDrawerController.goToPricing();
                            },
                            leading: const Icon(Icons.calculate, color: Colors.blue),
                            title: Text(
                              'Pricing',
                              style: GoogleFonts.numans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Lowest charge',
                              style: GoogleFonts.numans(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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

            // --- Logout ---
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 17, right: 17),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blue.withOpacity(.2), width: 0.5),
                  color: Colors.white.withOpacity(.7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Left-side low width, full height red indicator
                        Obx(() => Container(
                          width: appDrawerController.selectedItemIndex.value == 3 ? 5.0 : 0.0,
                          color: Colors.red,
                        )),
                        Expanded(
                          child: ListTile(
                            onTap: () {
                              appDrawerController.selectLogout();
                              logout();
                            },
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: Text(
                              'Logout',
                              style: GoogleFonts.numans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Logout your account',
                              style: GoogleFonts.numans(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
    );
  }

  // Helper widget for logout
  logout() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey.shade200,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Logout ?',
                style: GoogleFonts.numans(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'After logout you can login back.',
                style: GoogleFonts.numans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 7, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  appDrawerController.clearSelection();
                  Get.back();
                },
                child: Text(
                  'No',
                  style: GoogleFonts.numans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  appDrawerController.clearSelection();
                  authController.logoutUser();
                },
                child: Text(
                  'Yes',
                  style: GoogleFonts.numans(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      // Clears selection via controller when dialog closes
      appDrawerController.clearSelection();
    });
  }

  // Helper widget for change name
  changeName() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey.shade200,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Text(
                'Enter new username',
                style: GoogleFonts.numans(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CustomAuth(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person, color: Colors.black),
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
                child: Text(
                  'Back',
                  style: GoogleFonts.numans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Confirm',
                style: GoogleFonts.numans(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
