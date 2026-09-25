import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RiderFindOrder extends StatelessWidget {
  RiderFindOrder({super.key});
  final firebaseController = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
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
                    Text('Find order', style: GoogleFonts.numans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Text('Best delivery service', style: GoogleFonts.numans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('parcels')
                    .where('status', isEqualTo: 'received at warehouse')
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                    child: const Icon(Icons.local_shipping_outlined, color: Colors.blueAccent, size: 28),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'To: ${parcel['receiver_name']}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.numans(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                              ),
                                            ),
                                            Text(
                                              parcel['createdAt'] != null
                                                  ? DateFormat('d MMM, yyyy').format((parcel['createdAt'] as Timestamp).toDate())
                                                  : '',
                                              style: GoogleFonts.numans(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text('ID: ${parcel['tracking_id']}', style: GoogleFonts.numans(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Sender', style: GoogleFonts.numans(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
                                        Text('${parcel['sender_name']}', overflow: TextOverflow.ellipsis, style: GoogleFonts.numans(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
                                        Text('${parcel['sender_phone']}', style: GoogleFonts.numans(fontSize: 12, color: Colors.black87)),
                                        Text('${parcel['sender_address']}', overflow: TextOverflow.ellipsis, maxLines: 2, style: GoogleFonts.numans(fontSize: 12, color: Colors.grey.shade600)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Receiver', style: GoogleFonts.numans(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
                                        Text('${parcel['receiver_phone']}', style: GoogleFonts.numans(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
                                        Text('${parcel['receiver_address']}', overflow: TextOverflow.ellipsis, maxLines: 2, style: GoogleFonts.numans(fontSize: 12, color: Colors.grey.shade600)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                                        child: Text('${parcel['weight']} KG', style: GoogleFonts.numans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                        child: Text('${parcel['parcel_type']}', style: GoogleFonts.numans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '৳${parcel['total_amount']}',
                                    style: GoogleFonts.numans(fontWeight: FontWeight.w900, color: Colors.green.shade600, fontSize: 20),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  onPressed: () {
                                    String docId = snapshot.data!.docs[index].id;
                                    firebaseController.acceptOrder(docId);
                                  },
                                  child: Text("Accept Order", style: GoogleFonts.numans(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
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