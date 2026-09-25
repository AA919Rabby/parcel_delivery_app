import 'package:app_name/app/screens/app_screens/home/home_screen.dart';
import 'package:app_name/app/screens/auths/auth.dart';
import 'package:app_name/app/screens/auths/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  //login
  final loginEmail = TextEditingController();
  final loginPassword = TextEditingController();
  final loginKey = GlobalKey<FormState>();

  //register
  final registerUsername = TextEditingController();
  final registerEmail = TextEditingController();
  final registerPassword = TextEditingController();
  final registerConfirmPassword = TextEditingController();
  final registerKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  //rider info
  var selectedRole = ''.obs;

  // 3 separate password visibility toggles
  var isPasswordVisibility1 = true.obs; // For Login Password
  var isPasswordVisibility2 = true.obs; // For Register Password
  var isPasswordVisibility3 = true.obs; // For Register Confirm Password

  void togglePasswordVisibility1() {
    isPasswordVisibility1.value = !isPasswordVisibility1.value;
  }

  void togglePasswordVisibility2() {
    isPasswordVisibility2.value = !isPasswordVisibility2.value;
  }

  void togglePasswordVisibility3() {
    isPasswordVisibility3.value = !isPasswordVisibility3.value;
  }

  void updateRole(String role) {
    selectedRole.value = role;
  }

  //login
  login() async {
    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(
        email: loginEmail.text.trim(),
        password: loginPassword.text.trim(),
      );
      Get.offAll(() => HomeScreen());
      Get.snackbar('Welcome back', 'Login as ${loginEmail.text.trim()}');
      loginEmail.clear();
      loginPassword.clear();
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'user-not-found') message = "No user found for that email.";
      else if (e.code == 'wrong-password') message = "Wrong password provided.";

      Get.snackbar('Login Failed', message);
    } finally {
      isLoading.value = false;
    }
  }

  //register
  register() async {
    try {
      isLoading.value = true;
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: registerEmail.text.trim(),
        password: registerPassword.text.trim(),
      );
      if (credential.user != null) {
        await db.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'username': registerUsername.text.trim(),
          'email': registerEmail.text.trim(),
          'createdAt': Timestamp.now(),
        });
      }
      Get.off(() => Login());
      registerUsername.clear();
      registerEmail.clear();
      registerPassword.clear();
      registerConfirmPassword.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Account Exists',
          'This email is already registered. Please login instead.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ---------- ADDED: Reset Password Logic ----------
  Future<void> resetPassword(String email) async {
    try {
      if (email.isEmpty) {
        Get.snackbar('Error', 'Please enter your email to reset password.');
        return;
      }
      await auth.sendPasswordResetEmail(email: email.trim());
      Get.snackbar(
        'Email Sent',
        'A password reset link has been sent to $email. Please check your inbox.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        padding: EdgeInsets.only(top: 10),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Failed to send reset email.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
  // --------------------------------------------------

  //user logout
  logoutUser() async {
    await auth.signOut();
    Get.offAll(() => Auth());
  }
}