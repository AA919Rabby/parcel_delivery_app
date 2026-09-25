import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/rider/riderhome/rider_drawer/rider_drawer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      drawer: RiderDrawerScreen(),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with Gradient (Prevents overflow)
            Container(
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () => _scaffoldKey.currentState!.openDrawer(),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.menu, color: Colors.white, size: 28)
                        )),
                    const SizedBox(height: 15),
                    Text("Check point",
                      style: GoogleFonts.numans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                    return const Center(child: SpinKitCircle(color: Colors.blueAccent, size: 30.0));
                  }

                  // FILTERS OUT BOTH 'delivered' AND 'delivery complete' IMMEDIATELY
                  var activeParcels = [];
                  if (snapshot.hasData) {
                    activeParcels = snapshot.data!.docs.where((doc) {
                      String status = doc['status'].toString().toLowerCase().trim();
                      return status != 'delivered' && status != 'delivery complete';
                    }).toList();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty || activeParcels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, color: Colors.grey.shade400, size: 80),
                          const SizedBox(height: 15),
                          Text("Checkpoint is empty", style: GoogleFonts.numans(
                              color: Colors.grey.shade700, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("No parcels assigned for delivery.", style: GoogleFonts.numans(
                              color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: activeParcels.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      var parcel = activeParcels[index];
                      final data = parcel.data() as Map<String, dynamic>;

                      String currentStatus = data['status'] ?? 'Pending';
                      String displayAddress = data['receiver_address'] ?? data['address'] ?? "Address not provided";
                      String pickupAddress = data['pickup_address'] ?? data['sender_address'] ?? "Pickup point";

                      String senderPhone = data['sender_phone'] ?? "";
                      String receiverPhone = data['receiver_phone'] ?? "";

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ID: ${data['tracking_id'] ?? 'N/A'}",
                                      style: GoogleFonts.numans(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueAccent)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text(currentStatus.toUpperCase(),
                                        style: GoogleFonts.numans(fontSize: 10, fontWeight: FontWeight.bold,
                                            color: Colors.orange.shade700)),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
                              ),

                              // SENDER / PICKUP DETAILS
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.my_location, size: 16, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Sender: $pickupAddress", style: GoogleFonts.numans(fontSize: 13, color: Colors.grey.shade700)),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () => controller.makePhoneCall(senderPhone),
                                          child: Row(
                                            children: [
                                              const Icon(CupertinoIcons.phone_circle_fill, color: Colors.blueAccent, size: 16),
                                              const SizedBox(width: 4),
                                              Text(senderPhone.isNotEmpty ? senderPhone : 'N/A', style: GoogleFonts.numans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),

                              // RECEIVER / DROP DETAILS
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Drop: $displayAddress", style: GoogleFonts.numans(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("To: ${data['receiver_name'] ?? 'Unknown'}", style: GoogleFonts.numans(fontWeight: FontWeight.bold, fontSize: 13)),
                                            Text(
                                              parcel['createdAt'] != null
                                                  ? DateFormat('d MMM, h:mm a').format((parcel['createdAt'] as Timestamp).toDate())
                                                  : '',
                                              style: GoogleFonts.numans(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: () => controller.makePhoneCall(receiverPhone),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: Colors.green.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(CupertinoIcons.phone_circle_fill, color: Colors.green, size: 18),
                                                const SizedBox(width: 6),
                                                Text(receiverPhone.isNotEmpty ? receiverPhone : 'N/A', style: GoogleFonts.numans(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // ACTION BUTTONS (Single Click "Mark Delivered")
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade50,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => controller.goToNavigation(displayAddress),
                                      icon: const Icon(CupertinoIcons.location_fill, size: 18, color: Colors.blueAccent),
                                      label: Text("Route", style: GoogleFonts.numans(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  Expanded(
                                    flex: 3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => controller.updateParcelStatus(parcel.id, currentStatus),
                                      child: Obx(() => controller.isLoading8.value
                                          ? const SizedBox(height: 18, width: 18, child: SpinKitCircle(color: Colors.white, size: 18.0))
                                          : Text(
                                        "Mark Delivered",
                                        style: GoogleFonts.numans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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