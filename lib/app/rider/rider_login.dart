import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/rider/verify_otp.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:app_name/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RiderLogin extends StatelessWidget {
  RiderLogin({super.key});
  final firebaseController = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Upgraded top background gradient
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.sports_motorsports, color: Colors.white, size: 60),
                  const SizedBox(height: 10),
                  Text("Rider Portal", style: GoogleFonts.numans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),

                  Container(
                    margin: const EdgeInsets.only(top: 40, right: 30, left: 30, bottom: 40),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white, // Pure white for better contrast
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ]
                    ),
                    child: Form(
                      key: firebaseController.riderLoginKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            'Welcome Back!',
                            style: GoogleFonts.numans(
                              color: Colors.blueAccent,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Sign in to start delivering',
                            style: GoogleFonts.numans(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 35),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomAuth(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Email is required';
                                }if(GetUtils.isEmail(value)==false){
                                  return 'Invalid email address';
                                }
                                return null;
                              },
                              controller: firebaseController.riderLogin,
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.alternate_email, color: Colors.blueAccent),
                              hintText: 'Enter your email',
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Obx(
                                  () => CustomAuth(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                                controller: firebaseController.riderPassword,
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueAccent),
                                obscureText: firebaseController.isPasswordHidden.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    firebaseController.isPasswordHidden.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    firebaseController.togglePasswordVisibility();
                                  },
                                ),
                                hintText: 'Enter your password',
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          Obx(()=> firebaseController.isLoading.value ? const Center(
                            child: SpinKitCircle(color: Colors.blueAccent, size: 40.0),
                          ) : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: CustomButton(
                                onTap: (){
                                  if(firebaseController.riderLoginKey.currentState!.validate()){
                                    firebaseController.loginAsRider();
                                  }
                                },
                                color: Colors.blueAccent,
                                label: 'Login',
                                labelColor: Colors.white,
                              ),
                            ),
                          )),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}