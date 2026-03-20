import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_name/app/screens/auths/register.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:app_name/app/widgets/custom_button.dart';



class Login extends StatelessWidget {
   Login({super.key});
  final authController=Get.put(AuthController());
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
              margin: const EdgeInsets.only(top: 130, right: 40, left: 40, bottom: 40),
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
                key: authController.loginKey,
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
                        controller: authController.loginEmail,
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
                        controller: authController.loginPassword,
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.key, color: Colors.black),
                        obscureText: true,
                        suffixIcon: const Icon(Icons.visibility_off, color: Colors.black),
                        hintText: 'Enter your password',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 18, right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forget password ?',
                            style: GoogleFonts.numans(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  Obx(()=> authController.isLoading.value?Center(
                    child: CircularProgressIndicator(color: Colors.blue,),
                  ):Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomButton(
                      onTap: (){
                        if(authController.loginKey.currentState!.validate()){
                          authController.login();
                        }
                      },
                      color: Colors.blue,
                      label: 'Login',
                      labelColor: Colors.white,
                    ),
                  ),),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account ?",
                            style: GoogleFonts.numans(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 7),
                          GestureDetector(
                            onTap: () {
                              Future.delayed(Duration(milliseconds: 500),(){
                                Get.off(() =>  Register(), transition: Transition.fade);
                              });
                            },
                            child: Text(
                              "Register",
                              style: GoogleFonts.numans(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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