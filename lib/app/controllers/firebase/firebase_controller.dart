import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:app_name/app/rider/riderhome/rider_home_screen.dart';
import 'package:app_name/app/screens/auths/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';



class FirebaseController extends GetxController{

  final searchController=TextEditingController();
  final db=FirebaseFirestore.instance;
  final auth=FirebaseAuth.instance;

  var isLoading=false.obs;
  var searchResult={}.obs;
  var isSearchPerformed=false.obs;
  var selectedImage=''.obs;
  //rider login
  var riderPhoneNumber=TextEditingController();
  final riderKey=GlobalKey<FormState>();
  //rider otp
  final otp=TextEditingController();
  var verificationId=''.obs;
  final otpKey=GlobalKey<FormState>();

  //rider login
  final riderLogin=TextEditingController();
  final riderPassword=TextEditingController();
  final riderLoginKey=GlobalKey<FormState>();



  // List<TextEditingController> otpDigitControllers =
  // List.generate(6, (index) => TextEditingController());
  // String get combinedOtp => otpDigitControllers.map((e) => e.text).join();



  // pick image
  void pickImage()async{
    final image=await ImagePicker().pickImage(source:ImageSource.gallery,imageQuality: 50);
    if(image!=null){
      selectedImage.value=image.path;
    }
  }


  goToNavigation(String address) async {
    if (address.isEmpty) {
      Get.snackbar("Error", "No address found for this parcel");
      return;
    }

    try {
      isLoading.value = true;

      final coords = await getCoordinatesFromAddress(address);

      if (coords != null) {

        final double lat = coords['lat']!;
        final double lng = coords['lng']!;

        final Uri googleMapsIntent = Uri.parse("google.navigation:q=$lat,$lng&mode=d");

        final Uri fallbackUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

        if (await canLaunchUrl(googleMapsIntent)) {
          await launchUrl(googleMapsIntent, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
        }
      } else {

        final Uri addressSearchUrl = Uri.parse(
            "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}");
        await launchUrl(addressSearchUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar("Error", "Could not open map: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    if (address.isEmpty) return null;
    try {
      String cleanAddress = address.trim();

      if (!cleanAddress.toLowerCase().contains('bangladesh')) {
        cleanAddress = "$cleanAddress, Bangladesh";
      }

      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search'
              '?q=${Uri.encodeComponent(cleanAddress)}'
              '&format=json&limit=1&addressdetails=1&namedetails=1'
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'BD_Tracking_App_Rider',
      });

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          return {
            'lat': double.parse(data[0]['lat']),
            'lng': double.parse(data[0]['lon']),
          };
        }
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
    return null;
  }

  //make calls
  makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      Get.snackbar("Error", "Phone number is missing");
      return;
    }

    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        Get.snackbar("Error", "Could not open dialer");
      }
    } catch (e) {
      Get.snackbar("Error", "Launcher error: $e");
    }
  }


  ///TODO rider login
  loginAsRider() async {
    try {
      isLoading.value = true;
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: riderLogin.text.trim(),
        password: riderPassword.text.trim(),
      );

      String uid = credential.user!.uid;
      var riderDoc = await db.collection('users').doc(uid).get();

      await db.collection('users').doc(uid).set({
        'uid': uid,
        'email': riderLogin.text.trim(),
        'role': 'rider',
        'lat': 23.8103,
        'lng': 90.4125,
        'status': 'active',
      });


      Get.offAll(() => RiderHomeScreen());
      Get.snackbar('Welcome back', 'Login as ${riderLogin.text.trim()}');

      riderLogin.clear();
      riderPassword.clear();
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }





  acceptOrder(String docId) async {
    try {
      isLoading.value = true;

      String currentRiderUid = auth.currentUser!.uid;

      await db.collection('parcels').doc(docId).update({
        'status': 'delivery to rider',
        'rider_id': auth.currentUser!.uid,
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar('Success', 'Order accepted successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept order: $e');
    } finally {
      isLoading.value = false;
    }
  }



  updateParcelStatus(String docId, String currentStatus) async {
    String nextStatus;
    String status = currentStatus.toLowerCase().trim();

    if (status == "delivered") {
      nextStatus = "Delivery Complete";
    } else if (status == "delivery complete") {
      return;
    } else {
      nextStatus = "Delivered";
    }

    try {
      isLoading.value = true;
      await db.collection('parcels').doc(docId).update({
        'status': nextStatus,
      });
      Get.snackbar('Success', 'Status updated to $nextStatus');
    } catch (e) {
      Get.snackbar('Error', 'Update failed: $e');
    } finally {
      isLoading.value = false;
    }
  }


//logout
  riderLogout() async {
    try {
      isLoading.value = true;
      await auth.signOut();
      searchResult.clear();
      isSearchPerformed.value = false;
      riderPhoneNumber.clear();
      Get.offAll(() => Auth());

      Get.snackbar(
        'Logout',
        'Logout Successfully.',
      );
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: $e');
    } finally {
      isLoading.value = false;
    }
  }


//searchcontroller
  searchParcels()async{
    String query=searchController.text.trim();
    if(query.isEmpty){
      return ;
    }
    try{
      isLoading.value=true;
      FirebaseFirestore.instance
          .collection('parcels')
          .where('tracking_id', isEqualTo: query)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          searchResult.value = snapshot.docs.first.data();
          isSearchPerformed.value = true;
        } else {
          Get.snackbar('Not found', 'No parcels found with this Id');
        }
      }
      );
    }catch(e){
      Get.snackbar('Error','$e');
    }finally{
      isLoading.value=false;
    }
  }

  void clearSearch(){
    searchController.clear();
    searchResult.clear();
    isSearchPerformed.value=false;
  }

}