import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.grey.shade50, // very clean light background
      body: SafeArea(
          child: Column(
            children: [
              // Top Section Gradient
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
                      Text('Pricing & Info', style: GoogleFonts.numans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      Text('Transparent & Lowest Charge', style: GoogleFonts.numans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Center aligned for elegance
                      children: [
                        Text(
                          'Ideal 360 Logistics',
                          style: GoogleFonts.numans(color: Colors.blue.shade800, fontSize: 26, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
                          ),
                          child: Lottie.asset('assets/anime/warehouse.json',
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'We ensure your parcels reach safely with the best rates in Bangladesh. From important documents to emergency medicine, our dedicated team handles every delivery with maximum care and speed to provide you with the lowest cost and most reliable service in the country.\n\nWhether you are sending a gift to a loved one or moving critical business inventory, our real-time tracking system keeps you updated at every step. We bridge the distance between all 64 districts, bringing a seamless logistics experience right to your doorstep with guaranteed security and 24/7 support.',
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.numans(color: Colors.grey.shade800, fontSize: 15, height: 1.6, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 50),

                        _buildFeatureHighlight(context, 'assets/images/success.png', '100K+ Delivery Success'),
                        const SizedBox(height: 40),
                        _buildFeatureHighlight(context, 'assets/images/prize.png', 'No.1 Delivery app in BD'),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildFeatureHighlight(BuildContext context, String imagePath, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.contain),
        ),
        const SizedBox(height: 20),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.numans(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}