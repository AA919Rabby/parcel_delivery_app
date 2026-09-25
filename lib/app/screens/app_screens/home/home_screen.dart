import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/screens/app_screens/drawer/drawer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      drawer: DrawerScreen(),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with Gradient
            Container(
              height: MediaQuery.of(context).size.height * 0.22,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _scaffoldKey.currentState!.openDrawer(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        Text(
                          "Track Parcel",
                          style: GoogleFonts.numans(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ), // Balance for center alignment
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Obx(
                        () => TextField(
                          controller: firebaseController.searchController,
                          style: GoogleFonts.numans(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 14),
                            border: InputBorder.none,
                            hintText: 'Enter Tracker ID...',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            prefixIcon: const Icon(
                              Icons.track_changes,
                              color: Colors.blueAccent,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () =>
                                  firebaseController.isSearchPerformed.value
                                  ? firebaseController.clearSearch()
                                  : firebaseController.searchParcels(),
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      firebaseController.isSearchPerformed.value
                                      ? Colors.red.withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  firebaseController.isSearchPerformed.value
                                      ? Icons.close
                                      : CupertinoIcons.search,
                                  color:
                                      firebaseController.isSearchPerformed.value
                                      ? Colors.redAccent
                                      : Colors.blueAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Obx(() {
                if (firebaseController.isLoading.value)
                  return const Center(
                    child: SpinKitCircle(color: Colors.blueAccent, size: 40.0),
                  );
                if (!firebaseController.isSearchPerformed.value) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.search_rounded,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Search for a parcel ID\nto view tracking status.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.numans(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var data = firebaseController.searchResult;
                String status = (data['status'] ?? "")
                    .toString()
                    .toLowerCase()
                    .trim();

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(
                          Icons.person_outline,
                          "Sender",
                          "${data['sender_name']}",
                        ),
                        InfoRow(
                          Icons.my_location,
                          "Pick up",
                          "${data['sender_address']}",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Color(0xFFEEEEEE)),
                        ),
                        InfoRow(
                          Icons.person_pin_circle_outlined,
                          "Receiver",
                          "${data['receiver_name']}",
                        ),
                        InfoRow(
                          Icons.location_on_outlined,
                          "Drop",
                          "${data['receiver_address']}",
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Color(0xFFEEEEEE)),
                        ),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.timeline,
                                color: Colors.blueAccent,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Tracking Status",
                              style: GoogleFonts.numans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),

                            // Customer explicitly calling default number: 01402977919
                            GestureDetector(
                              onTap: () => firebaseController.makePhoneCall(
                                '01402977919',
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.phone_fill,
                                      color: Colors.green,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Call Rider',
                                      style: GoogleFonts.numans(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Correctly ordered track step logic
                        TrackStep("Pending / Received", true, isLast: false),

                        TrackStep(
                          "Handed over to Rider",
                          status == "delivery to rider" ||
                              status == "delivered" ||
                              status == "delivery complete",
                          isLast: false,
                        ),

                        TrackStep(
                          "Delivered",
                          status == "delivered" ||
                              status == "delivery complete",
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget InfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.numans(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget TrackStep(String title, bool isDone, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone ? Colors.green : Colors.grey.shade300,
                    width: 2,
                  ),
                  color: isDone ? Colors.green : Colors.white,
                ),
                child: Icon(
                  Icons.check,
                  color: isDone ? Colors.white : Colors.transparent,
                  size: 12,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? Colors.green : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                title,
                style: GoogleFonts.numans(
                  fontSize: 14,
                  fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                  color: isDone ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
