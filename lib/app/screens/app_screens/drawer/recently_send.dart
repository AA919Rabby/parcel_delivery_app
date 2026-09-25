import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecentlySend extends StatelessWidget {
  RecentlySend({super.key});

  final firebaseController = Get.put(FirebaseController());

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
                      Text('Recently Send', style: GoogleFonts.numans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      Text('Secure & Safe Delivery History', style: GoogleFonts.numans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('parcels')
                      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                            Icon(Icons.inventory_2_outlined, color: Colors.grey.shade400, size: 80),
                            const SizedBox(height: 15),
                            Text("No parcels found", style: GoogleFonts.numans(color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        var parcel = snapshot.data!.docs[index];
                        String rawStatus = parcel['status'].toString().toLowerCase();

                        String displayStatus = (rawStatus == 'received at warehouse') ? 'Pending' : parcel['status'];

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
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                          child: const Icon(Icons.local_shipping_outlined, color: Colors.blueAccent),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('ID: ${parcel['tracking_id']}', style: GoogleFonts.numans(fontSize: 14, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                                            Text(
                                              parcel['createdAt'] != null ? DateFormat('d MMM, yyyy').format((parcel['createdAt'] as Timestamp).toDate()) : '',
                                              style: GoogleFonts.numans(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('৳${parcel['total_amount']}', style: GoogleFonts.numans(fontWeight: FontWeight.w900, color: Colors.black87, fontSize: 18)),
                                        Text(parcel['receiver_address'].toString().toLowerCase().contains('dhaka') ? '+৳60 Fee' : '+৳120 Fee',
                                          style: GoogleFonts.numans(fontSize: 10, color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
                                ),
                                Text('To: ${parcel['receiver_name']}', overflow: TextOverflow.ellipsis, maxLines: 1, style: GoogleFonts.numans(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 5),
                                Text('Pickup: ${parcel['sender_address']}', overflow: TextOverflow.ellipsis, maxLines: 1, style: GoogleFonts.numans(fontSize: 13, color: Colors.grey.shade600)),
                                Text('Pickup Phone: ${parcel['sender_phone']}', overflow: TextOverflow.ellipsis, maxLines: 1, style: GoogleFonts.numans(fontSize: 13, color: Colors.grey.shade600)),
                                Text('Receiver: ${parcel['receiver_address']}', overflow: TextOverflow.ellipsis, maxLines: 1, style: GoogleFonts.numans(fontSize: 13, color: Colors.black87)),
                                const SizedBox(height: 15),

                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                                      child: Text('${parcel['weight']} KG', style: GoogleFonts.numans(fontSize: 11, fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                      child: Text('Type: ${parcel['parcel_type']}', style: GoogleFonts.numans(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: rawStatus == 'pending' || rawStatus == 'received at warehouse' ? Colors.orange.withOpacity(0.1)
                                            : rawStatus.contains('deliver') ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Status: $displayStatus',
                                        style: GoogleFonts.numans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: rawStatus == 'pending' || rawStatus == 'received at warehouse' ? Colors.orange.shade700
                                              : rawStatus.contains('deliver') ? Colors.green.shade700 : Colors.blueAccent,
                                        ),
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        // USING DYNAMIC FIREBASE LOGIC ONLY
                                        GestureDetector(
                                          onTap: () => firebaseController.makePhoneCall(parcel['rider_phone'] ?? ""),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            margin: const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(CupertinoIcons.phone_fill, color: Colors.green, size: 14),
                                                const SizedBox(width: 4),
                                                Text('Call Rider', style: GoogleFonts.numans(color: Colors.green.shade700, fontWeight: FontWeight.w700, fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                        ),

                                        if (rawStatus == 'pending' || rawStatus == 'received at warehouse')
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  title: Text('Cancel Order?', style: GoogleFonts.numans(fontWeight: FontWeight.bold)),
                                                  content: Text('Are you sure you want to cancel and remove this order?', style: GoogleFonts.numans()),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text('No', style: GoogleFonts.numans(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.redAccent,
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        await FirebaseFirestore.instance.collection('parcels').doc(parcel.id).delete();
                                                        Get.snackbar('Cancelled', 'Order has been successfully cancelled and removed.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.redAccent, colorText: Colors.white, margin: const EdgeInsets.all(10));
                                                      },
                                                      child: Text('Yes, Cancel', style: GoogleFonts.numans(color: Colors.white, fontWeight: FontWeight.bold)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 14),
                                                  const SizedBox(width: 4),
                                                  Text('Cancel', style: GoogleFonts.numans(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}