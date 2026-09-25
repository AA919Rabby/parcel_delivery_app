import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:app_name/app/screens/app_screens/drawer/pricing_screen.dart';
import 'package:app_name/app/screens/app_screens/drawer/recently_send.dart';
import 'package:app_name/app/screens/app_screens/drawer/send_parcel.dart';

class AppDrawerController extends GetxController {
  // -1 means no item selected by default
  var selectedItemIndex = (-1).obs;

  void selectItem(int index) {
    selectedItemIndex.value = index;
  }

  void clearSelection() {
    selectedItemIndex.value = -1;
  }

  // Handles 'Send Parcel' navigation & auto-resets when returning
  Future<void> goToSendParcel() async {
    selectedItemIndex.value = 0;
    await Get.to(() => SendParcel());
    clearSelection();
  }

  // Handles 'Recently send' navigation & auto-resets when returning
  Future<void> goToRecentlySend() async {
    selectedItemIndex.value = 1;
    await Get.to(() => RecentlySend());
    clearSelection();
  }

  // Handles 'Pricing' navigation & auto-resets when returning
  Future<void> goToPricing() async {
    selectedItemIndex.value = 2;
    await Get.to(() => PricingScreen());
    clearSelection();
  }

  // Handles 'Logout' click
  void selectLogout() {
    selectedItemIndex.value = 3;
  }
}


