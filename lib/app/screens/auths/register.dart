import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_name/app/screens/auths/login.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:app_name/app/widgets/custom_button.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade100, // Clean light background
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Header Gradient
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
                  const Icon(Icons.person_add_alt_1, color: Colors.white, size: 50),
                  const SizedBox(height: 10),
                  Text("Join Ideal 360", style: GoogleFonts.numans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),

                  Container(
                    margin: const EdgeInsets.only(top: 30, right: 25, left: 25, bottom: 40),
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ]),
                    child: Form(
                      key: authController.registerKey,
                      child: Column(
                        children: [
                          Text('Create Account', style: GoogleFonts.numans(color: Colors.blueAccent, fontSize: 26, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 5),
                          Text('Get started with delivery', style: GoogleFonts.numans(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 30),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomAuth(
                              validator: (value) => value!.isEmpty ? 'Username is required' : null,
                              controller: authController.registerUsername,
                              labelText: 'Username',
                              prefixIcon: const Icon(Icons.person_outline, color: Colors.blueAccent),
                              hintText: 'Enter your username',
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomAuth(
                              validator: (value) {
                                if (value!.isEmpty) return 'Email is required';
                                if (GetUtils.isEmail(value) == false) return 'Invalid email address';
                                return null;
                              },
                              controller: authController.registerEmail,
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.alternate_email, color: Colors.blueAccent),
                              hintText: 'Enter your email',
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Obx(
                                  () => CustomAuth(
                                validator: (value) {
                                  if (value!.isEmpty) return 'Password is required';
                                  if (value.length < 8) return 'Password must be at least 8 chars';
                                  return null;
                                },
                                controller: authController.registerPassword,
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueAccent),
                                obscureText: authController.isPasswordVisibility2.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    authController.isPasswordVisibility2.value ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () => authController.togglePasswordVisibility2(),
                                ),
                                hintText: 'Enter your password',
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Obx(
                                  () => CustomAuth(
                                validator: (value) {
                                  if (value!.isEmpty) return 'Confirm password is required';
                                  if (value != authController.registerPassword.text) return 'Passwords do not match';
                                  return null;
                                },
                                controller: authController.registerConfirmPassword,
                                labelText: 'Confirm Password',
                                prefixIcon: const Icon(Icons.lock_reset_outlined, color: Colors.blueAccent),
                                obscureText: authController.isPasswordVisibility3.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    authController.isPasswordVisibility3.value ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () => authController.togglePasswordVisibility3(),
                                ),
                                hintText: 'Confirm your password',
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Obx(
                                () => authController.isLoading.value
                                ? const Center(child: SpinKitCircle(color: Colors.blueAccent, size: 40.0))
                                : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: CustomButton(
                                  onTap: () {
                                    if (authController.registerKey.currentState!.validate()) {
                                      authController.register();
                                    }
                                  },
                                  color: Colors.blueAccent,
                                  label: 'Register',
                                  labelColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?", style: GoogleFonts.numans(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    Future.delayed(const Duration(milliseconds: 300), () => Get.off(() => Login(), transition: Transition.fade));
                                  },
                                  child: Text("Login", style: GoogleFonts.numans(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
    );
  }
}