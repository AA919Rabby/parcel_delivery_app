import 'package:app_name/app/configs/my_themes.dart';
import 'package:app_name/app/controllers/app_controllers/intro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';



class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});
  final introController=Get.put(IntroController());
  @override
  Widget build(BuildContext context) {
  //  introController.checkUser();
    return Scaffold(
      backgroundColor:Colors.blue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          color:Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/anime/delivery_bike.json',
              height: MediaQuery.of(context).size.height*0.84,
              width: double.infinity,),
          ],
        ),
      ),
    );
  }
}
