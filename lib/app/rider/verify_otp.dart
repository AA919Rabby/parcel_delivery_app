// import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
// import 'package:app_name/app/widgets/custom_auth.dart';
// import 'package:app_name/app/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
//
//
// class VerifyOtp extends StatelessWidget {
//   VerifyOtp({super.key});
//   final firebaseController=Get.find<FirebaseController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       backgroundColor: Colors.grey.shade300,
//       body: SingleChildScrollView(
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               height: 200,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(60),
//                   bottomRight: Radius.circular(60),
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(top: 100, right: 40, left: 40, bottom: 40),
//               decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(.1),
//                       blurRadius: 10,
//                       spreadRadius: 10,
//                       offset: const Offset(0, 0),
//                     )
//                   ]
//               ),
//               child: Form(
//                 key: firebaseController.otpKey,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 30),
//                     Text(
//                       'Enter your OTP',
//                       style: GoogleFonts.numans(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 35),
//
//                     Padding(
//                       padding: const EdgeInsets.only(left: 25,right: 25),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: List.generate(6, (index) {
//                           return otpBox(context, index);
//                         }),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Obx(()=> firebaseController.isLoading.value?Center(
//                       child: CircularProgressIndicator(color: Colors.blue,),
//                     ):Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: CustomButton(
//                         onTap: () {
//                           if(firebaseController.otpKey.currentState!.validate()){
//                             firebaseController.verifyOtp();
//                           }
//                         },
//                         color: Colors.blue,
//                         label: 'Login',
//                         labelColor: Colors.white,
//                       ),
//                     ),),
//                     const SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 20),
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Future.delayed(Duration(milliseconds: 50),(){
//                                 Get.back();
//                               });
//                             },
//                             child:Container(
//                               height: 27,
//                               width: 65,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(7),
//                                 border: Border.all(color: Colors.black.withOpacity(.1),width: 1),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Back",
//                                   style: GoogleFonts.numans(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   //helper widget for otp box
//   otpBox(BuildContext context, int index) {
//     return SizedBox(
//       height: 50,
//       width: 45,
//       child: TextFormField(
//         controller: firebaseController.otpDigitControllers[index],
//         onChanged: (value) {
//           if (value.length == 1 && index < 5) {
//             FocusScope.of(context).nextFocus();
//           }
//           if (value.isEmpty && index > 0) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         inputFormatters: [
//           LengthLimitingTextInputFormatter(1),
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: EdgeInsets.zero,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Colors.black12),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Colors.blue, width: 2),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
