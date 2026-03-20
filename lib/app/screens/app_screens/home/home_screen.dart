import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/screens/app_screens/drawer/drawer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final firebaseController = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      drawer: DrawerScreen(),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 7, left: 20, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () => _scaffoldKey.currentState!.openDrawer(),
                          child: const Icon(Icons.menu_open, color: Colors.white, size: 33)),
                      const SizedBox(height: 20),
                      Container(
                        height: 47,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Obx(() => TextField(
                          controller: firebaseController.searchController,
                          style: GoogleFonts.numans(color: Colors.black, fontSize: 17),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10, top: 10),
                            border: InputBorder.none,
                            hintText: 'Enter tracker id',
                            prefixIcon: const Icon(Icons.track_changes, color: Colors.black),
                            suffixIcon: GestureDetector(
                              onTap: () => firebaseController.isSearchPerformed.value
                                  ? firebaseController.clearSearch()
                                  : firebaseController.searchParcels(),
                              child: Icon(
                                firebaseController.isSearchPerformed.value ? Icons.close : CupertinoIcons.search,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: Obx(() {
                  if (firebaseController.isLoading.value) return const Center(child: CircularProgressIndicator());
                  if (!firebaseController.isSearchPerformed.value) {
                    return Center(child: Text("Search for a parcel",style: GoogleFonts.numans(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),));
                  }

                  var data = firebaseController.searchResult;
                  String status = (data['status'] ?? "").toString().toLowerCase().trim();

                  return Card(
                    elevation: 3,
                    color: Colors.white.withOpacity(.7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow("Sender", "${data['sender_name']}"),
                          InfoRow("Pick up", "${data['sender_address']}"),
                          InfoRow("Receiver", "${data['receiver_name']}"),
                          InfoRow("Address", "${data['receiver_address']}"),
                          const Divider(),
                          SizedBox(height: 2,),
                          Row(
                            children: [
                              Text("Tracking Status", style: GoogleFonts.numans(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Icon(CupertinoIcons.phone,color: Colors.green,size: 16,),
                              const SizedBox(width: 5,),
                              Text('Call Rider',style: GoogleFonts.numans(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),)
                            ],
                          ),
                          SizedBox(height: 2,),
                          const SizedBox(height: 10),


                          TrackStep("Received at warehouse", true),


                          TrackStep(
                              "Handed over to Rider",
                              status == "handed over to rider" || status == "delivery to rider" || status == "delivered" || status == "delivery complete"),

                          TrackStep(
                              "Delivered",
                              status == "delivered" || status == "delivery complete"),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          )),
    );
  }

  Widget InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(text: TextSpan(style: GoogleFonts.numans(color: Colors.black, fontSize: 13),
          children: [
        TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: value),
      ])),
    );
  }

  TrackStep(String title, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? Colors.green : Colors.grey, size: 20),
          const SizedBox(width: 10),
          Text(title, style: GoogleFonts.numans(fontSize: 12, color: isDone ? Colors.black : Colors.grey)),
        ],
      ),
    );
  }
}