import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';




class RiderFindOrder extends StatelessWidget {
  RiderFindOrder({super.key});
  final firebaseController=Get.put(FirebaseController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top section
            Container(
              height: MediaQuery.of(context).size.height * 0.18,
              width: double.infinity,
              decoration: BoxDecoration(
               color: Colors.blue,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 10, spreadRadius: 10, offset: const Offset(0, 0))],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 7, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 27)),
                    const SizedBox(height: 7),
                    Text('Find order', style: GoogleFonts.numans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5),
                    Text('Best delivery', style: GoogleFonts.numans(color: Colors.grey.shade300, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(

              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('parcels')
                    .where('status', isEqualTo: 'received at warehouse')
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
                          Icon(Icons.card_giftcard,color: Colors.grey,size: 60,),
                          const SizedBox(height: 4,),
                          Text("No parcels found", style: GoogleFonts.numans(
                              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var parcel = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 5,right: 5,top: 15),
                        child: Container(
                          margin: const EdgeInsets.only( left: 5, right: 5,bottom: 0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.blue.withOpacity(.2),width: 0.5),
                            color: Colors.white.withOpacity(.7),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                                  child: const Icon(Icons.local_shipping, color: Colors.blue),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'To: ${parcel['receiver_name']}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.numans(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                    Text(
                                      parcel['createdAt'] != null
                                          ? DateFormat('d MMM, yyyy').format((parcel['createdAt'] as Timestamp).toDate())
                                          : '',
                                      style: GoogleFonts.numans(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text('ID: ${parcel['tracking_id']}', style: GoogleFonts.numans(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                                    const Divider(height: 20),
                                    Text('Sender: ${parcel['sender_name']} (${parcel['sender_phone']})',
                                        overflow: TextOverflow.ellipsis, maxLines: 1,
                                        style: GoogleFonts.numans(fontSize: 12, color: Colors.black87)),
                                    Text('Pick up: ${parcel['sender_address']}',
                                        overflow: TextOverflow.ellipsis, maxLines: 1,
                                        style: GoogleFonts.numans(fontSize: 12, color: Colors.grey)),
                                    const SizedBox(height: 2),
                                    Text('Receiver Phone: ${parcel['receiver_phone']}', style: GoogleFonts.numans(fontSize: 12)),
                                    Text('Receiver Address: ${parcel['receiver_address']}', overflow: TextOverflow.ellipsis, maxLines: 1, style: GoogleFonts.numans(fontSize: 12, color: Colors.blueGrey)),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
                                          child: Text('${parcel['weight']} KG', style: GoogleFonts.numans(fontSize: 11, fontWeight: FontWeight.w600)),
                                        ),
                                        const SizedBox(width: 15),
                                        Text('Type: ${parcel['parcel_type']}', style: GoogleFonts.numans(fontSize: 11, color: Colors.blue)),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  '৳${parcel['total_amount']}',
                                  style: GoogleFonts.numans(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 5,
                                            backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                        onPressed: () {
                                          // Using doc ID from Frestore
                                          String docId = snapshot.data!.docs[index].id;
                                          firebaseController.acceptOrder(docId);
                                        },
                                        child: Text("Accept", style: GoogleFonts.numans(color: Colors.white, fontSize: 12)),
                                      ),
                                    ),
                                  ],
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