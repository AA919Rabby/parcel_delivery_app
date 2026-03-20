import 'package:app_name/app/controllers/firebase/firebase_controller.dart';
import 'package:app_name/app/rider/riderhome/rider_drawer/rider_find_order.dart';
import 'package:app_name/app/widgets/custom_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



class RiderDrawerScreen extends StatelessWidget {
   RiderDrawerScreen({super.key});
  final firebaseController=Get.put(FirebaseController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height:280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(17),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: Offset(0,0)
                  )
                ],
              ),
              ///TODO profile section
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60,),
                  GestureDetector(
                    onTap: (){
                      //firebaseController.pickImage();
                    },
                    child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.02),
                                blurRadius: 10,
                                spreadRadius: 10,
                                offset: Offset(0,0)
                            )
                          ],
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(CupertinoIcons.photo_fill,
                                color: Colors.grey,size: 100,),
                              Icon(CupertinoIcons.add,
                                color: Colors.black.withOpacity(.4),size: 40,),
                            ],
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: (){
                      changeName();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(child: Icon(Icons.edit,color: Colors.grey.shade300,size: 25,)),
                          const SizedBox(width: 45,),
                          Text('Rabbi',style: GoogleFonts.numans(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),),
                        ],),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8,left: 17,right: 17),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white.withOpacity(.7),
                  border: Border.all(color: Colors.blue.withOpacity(.2),width: 0.5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.03),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: Offset(0,0)
                    )
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: (){
                        Get.to(()=>RiderFindOrder());
                      },
                      leading: Icon(Icons.bookmark_border,color: Colors.blue,),
                      title: Text('Find order',style: GoogleFonts.numans(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      ),
                      subtitle: Text('Easy delivery',style: GoogleFonts.numans(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8,left: 17,right: 17),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blue.withOpacity(.2),width: 0.5),
                  color: Colors.white.withOpacity(.7),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.03),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: Offset(0,0)
                    )
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: (){
                        logout();
                      },
                      leading: Icon(Icons.logout,color: Colors.red,),
                      title: Text('Logout',style: GoogleFonts.numans(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      ),
                      subtitle: Text('Logout your account',style: GoogleFonts.numans(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 17,),
          ],
        ),
      ),
    );
  }

  //helper widget for logout
  logout(){
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey.shade200,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Logout ?',style: GoogleFonts.numans(
                color: Colors.black,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 10,),
              Text('After logout you can login back.',style: GoogleFonts.numans(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 7,left: 20,right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: ()=>Get.back(),
                child: Text('No',style: GoogleFonts.numans(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              GestureDetector(
                onTap: (){
                 firebaseController.riderLogout();
                },
                child: Text('Yes',style: GoogleFonts.numans(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

//helper widget for change name
  changeName(){
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey.shade200,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15,),
              Text('Enter new username',style: GoogleFonts.numans(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 20,),
              CustomAuth(labelText: 'Username',
                  prefixIcon: Icon(Icons.person,color: Colors.black,),
                  hintText: 'New username'),
              const SizedBox(height: 10,),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 7,left: 20,right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: ()=>Get.back(),
                child: Text('Back',style: GoogleFonts.numans(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              Text('Confirm',style: GoogleFonts.numans(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
        ),
      ),
    );
  }

}
