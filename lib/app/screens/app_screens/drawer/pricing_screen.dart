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
        backgroundColor: Colors.blue,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
          child: Column(
            children: [
              //top section
              Container(
                height:MediaQuery.of(context).size.height*0.18,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: Offset(0,0)
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 7,left: 20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back,color: Colors.white,size: 27,)),
                      const SizedBox(height: 7,),
                      Text('Pricing',style: GoogleFonts.numans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),),
                      const SizedBox(height: 5,),
                      Text('Lowest Charge',style: GoogleFonts.numans(
                        color: Colors.grey.shade300,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                ),

              ),
              const SizedBox(height: 30,),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Ideal 360',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.numans(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                            const SizedBox(height: 30,),
                          Lottie.asset('assets/anime/warehouse.json',
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: double.infinity,),
                           const SizedBox(height: 10,),
                          Text(
                            'We ensure your parcels reach safely with the best rates in Bangladesh. From important documents to emergency medicine, our dedicated team handles every delivery with maximum care and speed to provide you with the lowest cost and most reliable service in the country. '
                                'Whether you are sending a gift to a loved one or moving critical business inventory, our real-time tracking system keeps you updated at every step. We bridge the distance between all 64 districts, bringing a seamless logistics experience right to your doorstep with guaranteed security and 24/7 support.',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.numans(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 120,),

                          Center(child: Image.asset('assets/images/success.png',
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )),
                          const SizedBox(height: 15,),
                          Center(
                            child: Text(
                              '100K+ Delivery Success',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.numans(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100,),
                         Center(child: Image.asset('assets/images/prize.png',
                           width: 160,
                           height: 160,
                         fit: BoxFit.cover,
                         )),
                          const SizedBox(height: 15,),
                          Center(
                            child: Text(
                               'No.1 Delivery app in Bangladesh',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.numans(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
