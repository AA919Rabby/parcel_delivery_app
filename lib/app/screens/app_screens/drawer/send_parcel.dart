import 'package:app_name/app/controllers/app_controllers/home_controller.dart';
import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/controllers/firebase/parcel_controller.dart';
import 'package:app_name/app/widgets/custom_button.dart';
import 'package:app_name/app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class SendParcel extends StatelessWidget {
  SendParcel({super.key});
  final firebaseController = Get.put(FirebaseController());
  final homeController = Get.put(HomeController());
  final parcelController = Get.put(ParcelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Column(
            children: [
              // Top section with Gradient
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(.3), blurRadius: 15, offset: const Offset(0, 5))
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24)
                          )),
                      const SizedBox(height: 15),
                      Text('Send Parcel', style: GoogleFonts.numans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      Text('Fast & Reliable Delivery', style: GoogleFonts.numans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: parcelController.sendParcelKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sender Information Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                      child: const Icon(Icons.person, color: Colors.blueAccent, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Sender Information', style: GoogleFonts.numans(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                CustomText(
                                    validator: (value) => value!.isEmpty ? 'required' : null,
                                    controller: parcelController.sendParcelUsername,
                                    labelText: 'Username',
                                    prefixIcon: const Icon(Icons.person_outline, color: Colors.blueAccent),
                                    hintText: 'Enter your username'),
                                const SizedBox(height: 15),
                                CustomText(
                                    validator: (value) {
                                      if(value!.isEmpty) return 'required';
                                      if(value.length < 11) return 'Invalid phone number';
                                      return null;
                                    },
                                    controller: parcelController.sendParcelPhoneNUmber,
                                    labelText: 'Phone number',
                                    prefixIcon: const Icon(Icons.phone_outlined, color: Colors.blueAccent),
                                    hintText: 'Enter your phone number'),
                                const SizedBox(height: 15),
                                CustomText(
                                    validator: (value) => value!.isEmpty ? 'required' : null,
                                    controller: parcelController.sendParcelAddress,
                                    labelText: 'Address',
                                    prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.blueAccent),
                                    hintText: 'Enter your address'),
                                const SizedBox(height: 15),
                                CustomText(
                                    controller: parcelController.sendParcelEmail,
                                    labelText: 'Email (Optional)',
                                    prefixIcon: const Icon(Icons.alternate_email, color: Colors.blueAccent),
                                    hintText: 'Enter your email'),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return 'required';
                                          final n = int.tryParse(value);
                                          if (n == null) return 'Enter a whole number';
                                          if (n == 0) return '0 is not acceptable';
                                          if (n < 0) return 'Invalid weight';
                                          return null;
                                        },
                                        controller: parcelController.sendParcelWeight,
                                        labelText: 'Weight',
                                        prefixIcon: const Icon(Icons.scale_outlined, color: Colors.blueAccent),
                                        hintText: 'Kg',
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: CustomText(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return 'required';
                                          final price = int.tryParse(value);
                                          if (price == null) return 'Enter a whole number';
                                          if (price <= 0) return 'Invalid price';
                                          return null;
                                        },
                                        controller: parcelController.sendParcelPrice,
                                        labelText: 'Price',
                                        prefixIcon: const Icon(Icons.payments_outlined, color: Colors.blueAccent),
                                        hintText: '৳ BDT',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Obx( () => DropdownButtonFormField<String>(
                                  dropdownColor: Colors.white,
                                  value: homeController.selectedType.value,
                                  decoration: InputDecoration(
                                    labelText: 'Parcel Type',
                                    prefixIcon: const Icon(Icons.category_outlined, color: Colors.blueAccent),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
                                  ),
                                  items: homeController.parcelTypes.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type, style: GoogleFonts.numans(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600)),
                                    );
                                  }).toList(),
                                  onChanged: (value) => homeController.updateSelectedType(value!),
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Warning / Note Section
                          Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.orange.shade200)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                                      const SizedBox(width: 8),
                                      Text('Important Note', style: GoogleFonts.numans(color: Colors.orange.shade800, fontSize: 14, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 20,
                                    child: Marquee(
                                      text: ' 🚚 DELIVERY CHARGE WILL BE INCLUDED IN THE PRICE. THANK YOU FOR CHOOSING US!',
                                      style: GoogleFonts.numans(color: Colors.orange.shade800, fontSize: 13, fontWeight: FontWeight.w600),
                                      scrollAxis: Axis.horizontal,
                                      blankSpace: 30.0,
                                      velocity: 30.0,
                                    ),
                                  ),
                                  const Divider(color: Colors.orangeAccent),
                                  Text('• Inside Dhaka: ৳60', style: GoogleFonts.numans(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text('• Outside Dhaka: ৳120', style: GoogleFonts.numans(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text('• Shipping cost per kg: ৳5', style: GoogleFonts.numans(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              )
                          ),
                          const SizedBox(height: 20),

                          // Receiver Information Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                      child: const Icon(Icons.person_pin_circle_outlined, color: Colors.green, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Receiver Information', style: GoogleFonts.numans(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                CustomText(
                                    validator: (value) => value!.isEmpty ? 'required' : null,
                                    controller: parcelController.receiverParcelUsername,
                                    labelText: 'Username',
                                    prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
                                    hintText: 'Enter receiver username'),
                                const SizedBox(height: 15),
                                CustomText(
                                    validator: (value) {
                                      if(value!.isEmpty) return 'required';
                                      if(value.length < 11) return 'Invalid phone number';
                                      return null;
                                    },
                                    controller: parcelController.receiverParcelPhoneNumber,
                                    labelText: 'Phone number',
                                    prefixIcon: const Icon(Icons.phone_outlined, color: Colors.green),
                                    hintText: 'Enter receiver phone number'),
                                const SizedBox(height: 15),
                                CustomText(
                                    validator: (value) => value!.isEmpty ? 'required' : null,
                                    controller: parcelController.receiverParcelAddress,
                                    labelText: 'Address',
                                    prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.green),
                                    hintText: 'Enter receiver address'),
                                const SizedBox(height: 15),
                                CustomText(
                                    controller: parcelController.receiverParcelEmail,
                                    labelText: 'Email (Optional)',
                                    prefixIcon: const Icon(Icons.alternate_email, color: Colors.green),
                                    hintText: 'Enter receiver email'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Send Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]
                ),
                child: Obx(()=> parcelController.isLoading.value ? const Center(
                  child: SpinKitCircle(color: Colors.blueAccent, size: 30.0),
                ) : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                      onTap: (){
                        if(parcelController.sendParcelKey.currentState!.validate()){
                          parcelController.sendParcel();
                          Future.delayed(const Duration(milliseconds: 50),(){
                            checkMark();
                          });
                        }
                      },
                      color: Colors.blueAccent, label: 'Send Parcel', labelColor: Colors.white),
                )),
              ),
            ],
          )),
    );
  }

  // Success parcel request dialog
  checkMark(){
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, scale, child){
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 70)
              ),
            ),
            const SizedBox(height: 20),
            Text('Order Placed!', style: GoogleFonts.numans(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Your parcel is successfully registered.', textAlign: TextAlign.center, style: GoogleFonts.numans(color: Colors.grey.shade600, fontSize: 14)),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                onPressed: () => Get.back(),
                child: Text('Done', style: GoogleFonts.numans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}