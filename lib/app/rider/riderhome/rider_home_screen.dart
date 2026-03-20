import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/rider/riderhome/rider_drawer/rider_drawer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class RiderHomeScreen extends StatelessWidget {
  RiderHomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseController controller = Get.put(FirebaseController());

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
      drawer: RiderDrawerScreen(),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              height: MediaQuery.of(context).size.height * 0.16,
              width: double.infinity,
              decoration: BoxDecoration(
              color: Colors.blue,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10)
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () => _scaffoldKey.currentState!.openDrawer(),
                        child: const Icon(Icons.menu_open, color: Colors.white, size: 33)),
                    const SizedBox(height: 10),
                    Text("Check point",
                      style: GoogleFonts.numans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Parcel List Section
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('parcels')
                    .where('rider_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.blue));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty,color: Colors.grey,size: 60,),
                          const SizedBox(height: 4,),
                          Text("No parcel for delivery ", style: GoogleFonts.numans(
                              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }

                  var activeParcels = snapshot.data!.docs.where((doc) => doc['status'].toString().toLowerCase() != 'delivery complete').toList();

                  return ListView.builder(
                    itemCount: activeParcels.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var parcel = activeParcels[index];
                      final data = parcel.data() as Map<String, dynamic>;

                      String currentStatus = data['status'] ?? 'Pending';
                      String displayAddress = data['receiver_address'] ?? data['address'] ?? "Address not provided";
                      String pickupAddress = data['pickup_address'] ?? data['sender_address'] ?? "Pickup point";

                      return Padding(
                        padding: const EdgeInsets.only(left: 5,right: 5,top: 15),
                        child: Container(
                           margin: const EdgeInsets.only( left: 5, right: 5,bottom: 0),
                            padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.blue.withOpacity(.2),width: 0.5),
                            color: Colors.white.withOpacity(.7),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Id: ${data['tracking_id'] ?? 'N/A'}",
                                      style: GoogleFonts.numans(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                  Text(currentStatus,
                                      style: GoogleFonts.numans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                                ],
                              ),
                              const Divider(height: 20),
                                  Text("Pickup: $pickupAddress", style: GoogleFonts.numans(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 5),
                              Text("To: ${data['receiver_name'] ?? 'Unknown'}", style: GoogleFonts.numans(fontWeight: FontWeight.bold)),
                             GestureDetector(
                               onTap: (){
                                 controller.makePhoneCall(data['receiver_phone'] ?? "");
                               },
                               child: Row(
                                 children: [
                                   Text("Phone: ${data['receiver_phone'] ?? 'N/A'}", style: GoogleFonts.numans(fontSize: 12)),
                                   const SizedBox(width: 5,),
                                   Icon(CupertinoIcons.phone,color: Colors.green,size: 12,),
                                   const Spacer(),
                                   Text(
                                     parcel['createdAt'] != null
                                         ? DateFormat('d MMM, yyyy h:mm a')
                                         .format((parcel['createdAt'] as Timestamp).toDate())
                                         : '',
                                     style: GoogleFonts.numans(
                                       fontSize: 10,
                                       color: Colors.grey,
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                              Text("Address: $displayAddress", style: GoogleFonts.numans(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 15),

                              Row(
                                children: [
                                  if (currentStatus.toLowerCase() != 'delivered')
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade700,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        onPressed: () => controller.goToNavigation(displayAddress),
                                        icon: const Icon(CupertinoIcons.reply_all, size: 16, color: Colors.white),
                                        label: Text("Route", style: GoogleFonts.numans(color: Colors.white, fontSize: 12)),
                                      ),
                                    ),
                                  if (currentStatus.toLowerCase() != 'delivered') const SizedBox(width: 10),

                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        backgroundColor: currentStatus.toLowerCase() == 'delivered' ? Colors.green : Colors.blue,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () => controller.updateParcelStatus(parcel.id, currentStatus),
                                      child: Obx(() => controller.isLoading.value
                                          ? const SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                          : Text(
                                        currentStatus.toLowerCase() == 'delivered' ? "Delivery Complete" : "Mark as Delivered",
                                        style: GoogleFonts.numans(color: Colors.white, fontSize: 11),
                                      )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}