import 'package:app_name/app/controllers/app_controllers/home_controller.dart';
import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/controllers/firebase/parcel_controller.dart';
import 'package:app_name/app/widgets/custom_button.dart';
import 'package:app_name/app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';



class SendParcel extends StatelessWidget {
   SendParcel({super.key});
   final firebaseController=Get.put(FirebaseController());
   final homeController=Get.put(HomeController());
   final parcelController=Get.put(ParcelController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
          child: Column(
            children: [
              //top section
              Container(
                height:MediaQuery.of(context).size.height*0.18,
                width: double.infinity,
                decoration: BoxDecoration(
                color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: Offset(0,0)
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 7,left: 20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: (){
                           Get.back();
                          },
                          child: Icon(Icons.arrow_back,color: Colors.white,size: 27,)),
                      const SizedBox(height: 7,),
                    Text('Send Parcel',style: GoogleFonts.numans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),),
                      const SizedBox(height: 5,),
                      Text('Fast Delivery',style: GoogleFonts.numans(
                        color: Colors.grey.shade300,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                ),

              ),
              const SizedBox(height: 30,),
             Expanded(
               child: SingleChildScrollView(
                 physics: const BouncingScrollPhysics(),
                 child: Align(
                   alignment: Alignment.topLeft,
                   child: Padding(
                     padding: const EdgeInsets.only(left: 10,right: 10),
                     child: Form(
                       key: parcelController.sendParcelKey,
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 20),
                             child: Text('Sender Information',style: GoogleFonts.numans(
                               color: Colors.black,
                               fontSize: 17,
                               fontWeight: FontWeight.w600,
                             ),),
                           ),

                            //sender info
                           const SizedBox(height: 20,),
                           Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: CustomText(
                                 validator: (value){
                                   if(value!.isEmpty){
                                     return 'required';
                                   }
                                   return null;
                                 },
                                 controller: parcelController.sendParcelUsername,
                                 labelText: 'Username',
                                 prefixIcon: Icon(Icons.person,color: Colors.black,),
                                 hintText: 'Enter your username'),
                           ),
                           const SizedBox(height: 17,),
                           Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: CustomText(
                                 validator: (value){
                                   if(value!.isEmpty){
                                     return 'required';
                                   }
                                   if(value.length<11){
                                     return 'Invalid phone number';
                                   }
                                   return null;
                                 },
                                 controller: parcelController.sendParcelPhoneNUmber,
                                 labelText: 'Phone number',
                                 prefixIcon: Icon(Icons.call,color: Colors.black,),
                                 hintText: 'Enter your phone number'),
                           ),
                           const SizedBox(height: 17,),
                           Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: CustomText(
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'required';
                                  }
                                  return null;
                                },
                                 controller: parcelController.sendParcelAddress,
                                 labelText: 'Address',
                                 prefixIcon: Icon(Icons.location_on,color: Colors.black,),
                                 hintText: 'Enter your address'),
                           ),
                           const SizedBox(height: 17,),
                           Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: CustomText(
                                 controller: parcelController.sendParcelEmail,
                                 labelText: 'Email (Optional)',
                                 prefixIcon: Icon(Icons.alternate_email,color: Colors.black,),
                                 hintText: 'Enter your email'),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(top: 17, left: 15, right: 15),
                             child: Row(
                               children: [
                                 Expanded(
                                   child: CustomText(
                                     validator: (value) {
                                       if (value == null || value.isEmpty) {
                                         return 'required';
                                       }
                                       final n = int.tryParse(value);
                                       if (n == null) {
                                         return 'Please enter a whole number';
                                       }
                                       if (n == 0) {
                                         return '0 is not acceptable';
                                       }
                                       if (n < 0) {
                                         return 'Invalid weight';
                                       }
                                       return null;
                                     },
                                     controller: parcelController.sendParcelWeight,
                                     labelText: 'Weight',
                                     prefixIcon: const Icon(Icons.scale, color: Colors.black),
                                     hintText: 'Kg',
                                   ),
                                 ),
                                 const SizedBox(width: 15),
                                 Expanded(
                                   child: CustomText(
                                     validator: (value) {
                                       if (value == null || value.isEmpty) {
                                         return 'required';
                                       }
                                       final price = int.tryParse(value);
                                       if (price == null) {
                                         return 'Please enter a whole number';
                                       }
                                       if (price <= 0) {
                                         return 'Invalid price';
                                       }
                                       return null;
                                     },
                                     controller: parcelController.sendParcelPrice,
                                     labelText: 'Price',
                                     prefixIcon: const Icon(Icons.payment, color: Colors.black),
                                     hintText: '৳ BDT',
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           const SizedBox(height: 17,),
                           Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: Obx( () => DropdownButtonFormField<String>(
                               dropdownColor: Colors.grey.shade200,
                               value: homeController.selectedType.value,
                               decoration: InputDecoration(
                                 labelText: 'Type',
                                 prefixIcon: const Icon(Icons.category, color: Colors.black),
                               ),
                               items: homeController.parcelTypes.map((String type) {
                                 return DropdownMenuItem<String>(
                                   value: type,
                                   child: Text(type, style: GoogleFonts.numans(fontSize: 14,
                                       color: Colors.black,fontWeight: FontWeight.w600)),
                                 );
                               }).toList(),
                               onChanged: (value) {
                                 homeController.updateSelectedType(value!);
                               },
                             )),
                           ),
                           const SizedBox(height: 45,),
                           Padding(
                             padding: const EdgeInsets.only(left: 25,right: 15),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     Text('** ',style: GoogleFonts.numans(
                                       color: Colors.black,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold,
                                     ),),
                                     Text('NOTE ',style: GoogleFonts.numans(
                                       color: Colors.red,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold,
                                     ),),
                                     Text(':  ',
                                       style: GoogleFonts.numans(
                                       color: Colors.black,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold,
                                     ),),
                                     Expanded(
                                       child: SizedBox(
                                         height: 20,
                                         child:   Marquee(
                                           text: ' 🚚 DELIVERY CHARGE WILL INCLUDED IN THE PRICE. THANK YOU FOR CHOOSING US!',
                                           style: GoogleFonts.numans(
                                             color: Colors.black,
                                             fontSize: 12,
                                             fontWeight: FontWeight.w600,
                                           ),
                                           scrollAxis: Axis.horizontal,
                                           blankSpace: 30.0,
                                           velocity: 30.0,
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                                 const SizedBox(height: 6,),
                                 Text('** Inside Dhaka ৳60.',style: GoogleFonts.numans(
                                   color: Colors.black,
                                   fontSize: 13,
                                   fontWeight: FontWeight.w600,
                                 ),),
                                 const SizedBox(height: 6,),
                                 Text('** Outside Dhaka ৳120.',style: GoogleFonts.numans(
                                   color: Colors.black,
                                   fontSize: 13,
                                   fontWeight: FontWeight.w600,
                                 ),),
                                 const SizedBox(height: 6,),
                                 Text('** Shipping cost per kg ৳5',style: GoogleFonts.numans(
                                   color: Colors.black,
                                   fontSize: 13,
                                   fontWeight: FontWeight.w600,
                                 ),),
                               ],
                             )
                           ),

                           //receiver info
                           Padding(
                             padding: const EdgeInsets.only(top: 50,left: 20),
                             child: Text('Receiver Information',style: GoogleFonts.numans(
                               color: Colors.black,
                               fontSize: 17,
                               fontWeight: FontWeight.w600,
                             ),),
                           ),

                           Padding(
                             padding: const EdgeInsets.only(top: 20, left: 15,right: 15),
                             child: CustomText(
                                 validator: (value){
                                   if(value!.isEmpty){
                                     return 'required';
                                   }
                                   return null;
                                 },
                                 controller: parcelController.receiverParcelUsername,
                                 labelText: 'Username',
                                 prefixIcon: Icon(Icons.person,color: Colors.black,),
                                 hintText: 'Enter your username'),
                           ),
                           const SizedBox(height: 17,),
                           Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: CustomText(
                                 validator: (value){
                                   if(value!.isEmpty){
                                     return 'required';
                                   }
                                   if(value.length<11){
                                     return 'Invalid phone number';
                                   }
                                   return null;
                                 },
                                 controller: parcelController.receiverParcelPhoneNumber,
                                 labelText: 'Phone number',
                                 prefixIcon: Icon(Icons.call,color: Colors.black,),
                                 hintText: 'Enter your phone number'),
                           ),
                           const SizedBox(height: 17,),
                           Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: CustomText(
                                 validator: (value){
                                   if(value!.isEmpty){
                                     return 'required';
                                   }
                                   return null;
                                 },
                                 controller: parcelController.receiverParcelAddress,
                                 labelText: 'Address',
                                 prefixIcon: Icon(Icons.location_on,color: Colors.black,),
                                 hintText: 'Enter your address'),
                           ),
                           const SizedBox(height: 17,),
                           Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: CustomText(
                                 controller: parcelController.receiverParcelEmail,
                                 labelText: 'Email (Optional)',
                                 prefixIcon: Icon(Icons.alternate_email,color: Colors.black,),
                                 hintText: 'Enter your email'),
                           ),
                          const SizedBox(height: 50,),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(()=> parcelController.isLoading.value?Center(
                  child: CircularProgressIndicator(color: Colors.blue,),
                ):CustomButton(
                  onTap: (){
                    if(parcelController.sendParcelKey.currentState!.validate()){
                      parcelController.sendParcel();
                     Future.delayed(Duration(milliseconds: 50),(){
                       checkMark();
                     });
                    }
                  },
                  color: Colors.blue, label: 'Send',labelColor: Colors.white,)),
              ),
              const SizedBox(height: 20,),
            ],
          )),
    );
  }
  //success parcel request
   checkMark(){
     Get.dialog(
       barrierDismissible: false,
       AlertDialog(
         elevation: 5,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(20),
         ),
         backgroundColor: Colors.grey.shade200,
         title: Center(
           child: Column(
           mainAxisSize: MainAxisSize.min,
             children: [
             TweenAnimationBuilder(tween: Tween(begin: 0.0,end: 1.0),
                 duration: Duration(milliseconds: 800),
                 curve: Curves.elasticOut,
                 builder: (context,scale,child){
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                 },
               child:  Container(
                   height: 120,
                   width: 100,
                   decoration: BoxDecoration(
                     color: Colors.green,
                     shape: BoxShape.circle,
                   ),
                   child: Icon(Icons.check,color: Colors.white,size: 60,)),
             )
             ],
           ),
         ),
         content: Padding(
           padding: const EdgeInsets.only(top: 7,left: 20,right: 20),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               GestureDetector(
                 onTap: ()=>Get.back(),
                 child: Text('Done',style: GoogleFonts.numans(
                   color: Colors.black,
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),),
               ),
             ],
           ),
         ),
       ),
     );
   }

}
