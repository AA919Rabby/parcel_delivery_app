import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class HomeController extends GetxController{

  var selectedType='Document'.obs;
  var totalCost=0.obs;
  final weightController=TextEditingController();

  List<String> parcelTypes=[
    'Document',
    'Electronics',
    'Medicine',
    'Clothing',
    'Fragile',
  ];

updateSelectedType(String value){
  selectedType.value=value;
}

calculateFinalPrice(String city,String weightText){
  int baseRate=city.toLowerCase().contains('dhaka')?60:120;
  double w=double.tryParse(weightText)??1.0;
  if(w>1.0){
    totalCost.value=(baseRate+(w-1)*15).toInt();
  }else{
    totalCost.value=baseRate;
  }
}




}