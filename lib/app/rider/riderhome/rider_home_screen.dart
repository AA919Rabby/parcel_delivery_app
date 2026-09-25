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
            // Header Section with Gradient
            Container(
              height: MediaQuery.of(context).size.height * 0.16,
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty_rounded, color: Colors.grey.shade400, size: 80),
                          const SizedBox(height: 15),
                          Text("No parcel for delivery", style: GoogleFonts.numans(
                              color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }

                  var activeParcels = snapshot.data!.docs.where((doc) => doc['status'].toString().toLowerCase() != 'delivery complete').toList();

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
                                        color: currentStatus.toLowerCase() == 'delivered' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text(currentStatus.toUpperCase(),
                                        style: GoogleFonts.numans(fontSize: 10, fontWeight: FontWeight.bold,
                                            color: currentStatus.toLowerCase() == 'delivered' ? Colors.green.shade700 : Colors.orange.shade700)),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.my_location, size: 16, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text("Pickup: $pickupAddress", style: GoogleFonts.numans(fontSize: 13, color: Colors.grey.shade700))),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text("Drop: $displayAddress", style: GoogleFonts.numans(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600))),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("To: ${data['receiver_name'] ?? 'Unknown'}", style: GoogleFonts.numans(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(
                                    parcel['createdAt'] != null
                                        ? DateFormat('d MMM, h:mm a').format((parcel['createdAt'] as Timestamp).toDate())
                                        : '',
                                    style: GoogleFonts.numans(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => controller.makePhoneCall(data['receiver_phone'] ?? ""),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(CupertinoIcons.phone_circle_fill, color: Colors.green, size: 20),
                                      const SizedBox(width: 8),
                                      Text("${data['receiver_phone'] ?? 'N/A'}", style: GoogleFonts.numans(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  if (currentStatus.toLowerCase() != 'delivered')
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
                                  if (currentStatus.toLowerCase() != 'delivered') const SizedBox(width: 10),

                                  Expanded(
                                    flex: 3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        backgroundColor: currentStatus.toLowerCase() == 'delivered' ? Colors.green : Colors.blueAccent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => controller.updateParcelStatus(parcel.id, currentStatus),
                                      child: Obx(() => controller.isLoading.value
                                          ? const SizedBox(height: 18, width: 18, child: SpinKitCircle(color: Colors.white, size: 18.0))
                                          : Text(
                                        currentStatus.toLowerCase() == 'delivered' ? "Delivery Complete" : "Mark Delivered",
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