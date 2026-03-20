import 'package:app_name/app/screens/app_screens/home/home_screen.dart';
import 'package:app_name/app/screens/auths/auth.dart';
import 'package:app_name/app/screens/auths/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthController extends GetxController{


  //login
  final loginEmail=TextEditingController();
  final loginPassword=TextEditingController();
  final loginKey=GlobalKey<FormState>();

  //register
  final registerUsername=TextEditingController();
  final registerEmail=TextEditingController();
  final registerPassword=TextEditingController();
  final registerConfirmPassword=TextEditingController();
  final registerKey=GlobalKey<FormState>();


  var isLoading=false.obs;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
 //rider info
  var selectedRole=''.obs;


 void updateRole(String role){
  selectedRole.value=role;
  }

  //login
  login()async{
    try{
      isLoading.value=true;
      await auth.signInWithEmailAndPassword(
        email: loginEmail.text.trim(),
        password: loginPassword.text.trim(),
      );
      Get.offAll(()=>HomeScreen());
      Get.snackbar('Welcome back','Login as ${loginEmail.text.trim()}');
      loginEmail.clear();
      loginPassword.clear();
    }on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'user-not-found') message = "No user found for that email.";
      else if (e.code == 'wrong-password') message = "Wrong password provided.";

      Get.snackbar('Login Failed', message,
         );
    }finally{
      isLoading.value=false;
    }
  }


 //register
  register()async{
    try{
      isLoading.value=true;
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
      Get.off(()=>Login());
      registerUsername.clear();
      registerEmail.clear();
      registerPassword.clear();
      registerConfirmPassword.clear();
    }on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Account Exists',
          'This email is already registered. Please login instead.',
        );
      }
      }finally{
      isLoading.value=false;
    }
  }



//user logout
  logoutUser()async{
    await auth.signOut();
    Get.offAll(()=>Auth());
  }


}