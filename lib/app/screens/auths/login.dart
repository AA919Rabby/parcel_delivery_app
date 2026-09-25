import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_name/app/screens/auths/register.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:app_name/app/widgets/custom_button.dart';

class Login extends StatelessWidget {
  Login({super.key});
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
                  const SizedBox(height: 30),
                  const Icon(Icons.local_shipping, color: Colors.white, size: 60),
                  const SizedBox(height: 10),
                  Text("Ideal 360", style: GoogleFonts.numans(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 1.2)),

                  Container(
                    margin: const EdgeInsets.only(top: 40, right: 25, left: 25, bottom: 40),
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
                        ]
                    ),
                    child: Form(
                      key: authController.loginKey,
                      child: Column(
                        children: [
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
                            'Sign in to your account',
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
                              validator: (value) {
                                if (value!.isEmpty) return 'Email is required';
                                if (GetUtils.isEmail(value) == false) return 'Invalid email';
                                return null;
                              },
                              controller: authController.loginEmail,
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
                                  if (value!.isEmpty) return 'Password is required';
                                  return null;
                                },
                                controller: authController.loginPassword,
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueAccent),
                                obscureText: authController.isPasswordVisibility1.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    authController.isPasswordVisibility1.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () => authController.togglePasswordVisibility1(),
                                ),
                                hintText: 'Enter your password',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, right: 25),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  TextEditingController resetEmailController = TextEditingController(text: authController.loginEmail.text);

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          backgroundColor: Colors.white,
                                          title: Text('Reset Password', style: GoogleFonts.numans(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Enter your email address to receive a password reset link.', style: GoogleFonts.numans(color: Colors.grey.shade700)),
                                              const SizedBox(height: 15),
                                              TextField(
                                                controller: resetEmailController,
                                                keyboardType: TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                    hintText: "Email",
                                                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.blueAccent),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Cancel', style: GoogleFonts.numans(color: Colors.grey, fontWeight: FontWeight.bold)),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                authController.resetPassword(resetEmailController.text);
                                              },
                                              child: Text('Send Link', style: GoogleFonts.numans(color: Colors.white, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                },
                                child: Text('Forgot password?', style: GoogleFonts.numans(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
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
                                    if (authController.loginKey.currentState!.validate()) {
                                      authController.login();
                                    }
                                  },
                                  color: Colors.blueAccent,
                                  label: 'Login',
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
                                Text("Don't have an account?", style: GoogleFonts.numans(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    Future.delayed(const Duration(milliseconds: 300), () => Get.off(() => Register(), transition: Transition.fade));
                                  },
                                  child: Text("Register", style: GoogleFonts.numans(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold)),
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