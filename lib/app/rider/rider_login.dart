import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/rider/verify_otp.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:app_name/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



class RiderLogin extends StatelessWidget {
   RiderLogin({super.key});
   final firebaseController=Get.put(FirebaseController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 270,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 150, right: 40, left: 40, bottom: 40),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    )
                  ]
              ),
              child: Form(
               key: firebaseController.riderLoginKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Welcome back',
                      style: GoogleFonts.numans(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: CustomAuth(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'required';
                          }if(GetUtils.isEmail(value)==false){
                            return 'invalid email';
                          }
                          return null;
                        },
                        controller: firebaseController.riderLogin,
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.alternate_email, color: Colors.black),
                        hintText: 'Enter your email',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: CustomAuth(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'required';
                          }return null;
                        },
                        controller: firebaseController.riderPassword,
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.key, color: Colors.black),
                        obscureText: true,
                        suffixIcon: const Icon(Icons.visibility_off, color: Colors.black),
                        hintText: 'Enter your password',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(()=> firebaseController.isLoading.value?Center(
                      child: CircularProgressIndicator(color: Colors.blue,),
                    ):Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomButton(
                        onTap: (){
                          if(firebaseController.riderLoginKey.currentState!.validate()){
                           firebaseController.loginAsRider();
                          }
                        },
                        color: Colors.blue,
                        label: 'Login',
                        labelColor: Colors.white,
                      ),
                    ),),
                    const SizedBox(height: 10,),
                    const Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
