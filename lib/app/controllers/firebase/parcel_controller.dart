import 'package:app_name/app/controllers/app_controllers/home_controller.dart';
import 'package:app_name/app/controllers/firebase/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ParcelController extends GetxController{

  final authController=Get.put(AuthController());
  final homeController=Get.put(HomeController());

  var isLoading=false.obs;


  //sendparcel screen validator key
  final sendParcelKey=GlobalKey<FormState>();
  //send parcel
  final sendParcelUsername=TextEditingController();
  final sendParcelPhoneNUmber=TextEditingController();
  final sendParcelAddress=TextEditingController();
  final sendParcelEmail=TextEditingController();
  final sendParcelWeight=TextEditingController();
  final sendParcelPrice=TextEditingController();
  //receiver parcel
  final receiverParcelUsername=TextEditingController();
  final receiverParcelPhoneNumber=TextEditingController();
  final receiverParcelAddress=TextEditingController();
  final receiverParcelEmail=TextEditingController();



//TODO send parcel request to firebase
  sendParcel() async {
    try {
      isLoading.value = true;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String address = receiverParcelAddress.text.trim().toLowerCase();
      int deliveryBaseFee = address.contains('dhaka') ? 60 : 120;
      double weight = double.tryParse(sendParcelWeight.text.trim()) ?? 0.0;
      double weightCharge = weight * 5;
      int itemPrice = int.tryParse(sendParcelPrice.text.trim()) ?? 0;
      double totalAmount = itemPrice + deliveryBaseFee + weightCharge;
      String trackingId = "TRK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
      await FirebaseFirestore.instance.collection('parcels').add({
        'sender_name': sendParcelUsername.text.trim(),
        'sender_phone': sendParcelPhoneNUmber.text.trim(),
        'sender_address': sendParcelAddress.text.trim(),
        'sender_email': sendParcelEmail.text.trim(),
        'weight': weight,

        'receiver_name': receiverParcelUsername.text.trim(),
        'receiver_phone': receiverParcelPhoneNumber.text.trim(),
        'receiver_address': receiverParcelAddress.text.trim(),
        'receiver_email': receiverParcelEmail.text.trim(),

        'item_price': itemPrice,
        'delivery_area': address.contains('dhaka') ? 'Inside Dhaka' : 'Outside Dhaka',
        'delivery_fee': deliveryBaseFee,
        'weight_charge': weightCharge,
        'total_amount': totalAmount,

        'tracking_id': trackingId,
        'parcel_type': homeController.selectedType.value,
        'status': 'received at warehouse',
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      clearParcelFields();
      Get.snackbar('Success', 'Parcel Sent! ID: $trackingId',
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', '$e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
//helper function
  void clearParcelFields(){
    sendParcelUsername.clear();
    sendParcelPhoneNUmber.clear();
    sendParcelAddress.clear();
    sendParcelEmail.clear();
    sendParcelWeight.clear();
    sendParcelPrice.clear();
    receiverParcelUsername.clear();
    receiverParcelPhoneNumber.clear();
    receiverParcelAddress.clear();
    receiverParcelEmail.clear();
  }

}