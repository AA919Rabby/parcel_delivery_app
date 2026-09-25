import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../riderhome/rider_drawer/rider_find_order.dart';

class RiderController extends GetxController {
  var selectedItemIndex = (-1).obs;

  void selectItem(int index) {
    selectedItemIndex.value = index;
  }

  void clearSelection() {
    selectedItemIndex.value = -1;
  }

  // Handles 'Find order' click: sets blue bar, navigates, resets when you return
  Future<void> goToFindOrder() async {
    selectedItemIndex.value = 0;
    await Get.to(() => RiderFindOrder());
    clearSelection();
  }

  // Handles 'Logout' click
  void selectLogout() {
    selectedItemIndex.value = 1;
  }
}


