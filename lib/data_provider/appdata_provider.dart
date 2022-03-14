import 'package:flutter/cupertino.dart';
import 'package:uberdummy/datamodel/address_model.dart';

class AppData extends ChangeNotifier {
  Address? pickupAddress;
  Address? dropAddress;
  updatePickupAddress(Address newAddress) {
    pickupAddress = newAddress;
    notifyListeners();
  }

  updateDropAddress(Address newAddress) {
    dropAddress = newAddress;
    notifyListeners();
  }
}
