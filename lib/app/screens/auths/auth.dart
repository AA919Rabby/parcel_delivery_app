import 'package:app_name/app/configs/my_themes.dart';
import 'package:app_name/app/controllers/app_controllers/home_controller.dart';
import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:app_name/app/rider/rider_login.dart';
import 'package:app_name/app/screens/auths/login.dart';
import 'package:app_name/app/screens/auths/register.dart';
import 'package:app_name/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class Auth extends StatelessWidget {
  Auth({super.key});
  final authController=Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 90,top: 150),
                child: Lottie.asset('assets/anime/auth.json',
                  height:350,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10,),
              const Spacer(),
              //custom button
              Padding(
                padding: const EdgeInsets.only(left: 55,right: 55,top: 50),
                child: CustomButton(
                  onTap: (){
                    showSelectionDialog(context);
                  },
                  color:Colors.blue, label:'Get Started',labelColor: Mythemes.appMainColor,),
              ),
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
///TODO helper widget for check user login with rider or customer
  void showSelectionDialog(BuildContext context){
    final authController = Get.find<AuthController>();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:  Colors.grey.shade200,
          title: Text("Select Role", textAlign: TextAlign.center,style: GoogleFonts.numans(
            color: Colors.black,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => GestureDetector(
                onTap: () => authController.updateRole('Rider'),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: authController.selectedRole.value == 'Rider'
                          ? Colors.blue
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.directions_bike,
                        color: authController.selectedRole.value == 'Rider' ? Colors.blue : Colors.black),
                    title: Text(
                      'as Rider',
                      style: GoogleFonts.numans(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),

              SizedBox(height: 10),

              Obx(() => GestureDetector(
                onTap: () => authController.updateRole('Customer'),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: authController.selectedRole.value == 'Customer'
                          ? Colors.blue
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person,
                        color: authController.selectedRole.value == 'Customer' ? Colors.blue : Colors.black),
                    title: Text(
                      'as Customer',
                      style: GoogleFonts.numans(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
          actions: [
            Obx(() {
              bool isSelected = authController.selectedRole.value.isNotEmpty;
              return SizedBox(
                height: 42,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: isSelected
                      ? () {
                    if (authController.selectedRole.value == 'Rider') {
                      Future.delayed(Duration(milliseconds: 800),(){
                        Get.offAll(()=>RiderLogin(),transition: Transition.zoom);
                      });
                    } if (authController.selectedRole.value == 'Customer') {
                      Future.delayed(Duration(milliseconds: 800),(){
                        Get.offAll(()=>Login(),transition: Transition.zoom);
                      });
                    }
                  }
                      : null,
                  child: Text(
                    'Continue',
                    style: GoogleFonts.numans(color: Colors.white,
                    fontWeight: FontWeight.bold,fontSize: 14
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }


}
