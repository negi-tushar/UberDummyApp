import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:uberdummy/data_provider/appdata_provider.dart';
import 'package:uberdummy/datamodel/address_model.dart';
import 'package:uberdummy/datamodel/direction_model.dart';
import 'package:uberdummy/globalvariables.dart';
import 'package:uberdummy/helpers/request_helper.dart';

class HelperMethods {
  static Future<String> getCoordinatedString(
      Position position, BuildContext context) async {
    String pickAdress = '';
    // ignore: unrelated_type_equality_checks
    // if (ConnectivityResult != ConnectivityResult.mobile &&
    //     ConnectivityResult != ConnectivityResult.wifi) {
    //   return pickAdress;
    // }
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

    var response = await Requesthelper.getresposnse(url);
    if (response != 'failed') {
      pickAdress = response['results'][0]['formatted_address'];

      Address pickupAddress = Address(
          placeName: pickAdress,
          formatedAddress: pickAdress,
          lat: position.latitude,
          long: position.longitude,
          placeId: pickAdress.substring(1, 6));

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    }
    // print('pickAdress--->$pickAdress');
    return pickAdress;
  }

  static Future<DirectionDetails?> getDirectionDetails(
      LatLng startPostion, LatLng destinationPosition) async {
    var url =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${destinationPosition.latitude},${destinationPosition.longitude}&origin=${startPostion.latitude},${startPostion.longitude}&key=$apiKey&mode=driving";
    var response = await Requesthelper.getresposnse(url);
    if (response == 'failed') {
      return null;
    }
    DirectionDetails dd = DirectionDetails(
        distanceText: response['routes'][0]['legs'][0]['distance']['text'],
        distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
        durationText: response['routes'][0]['legs'][0]['duration']['text'],
        durationValue: response['routes'][0]['legs'][0]['duration']['value'],
        encodedPoints: response['routes'][0]['overview_polyline']['points']);
    return dd;
  }

  static int getEstimatedFares(DirectionDetails details) {
    //basefare = 20 RS
    //timefare = 1 Rs
    //distanceFare = 15 Rs
    double basefare = 20;
    double timefare = 1;
    double distanceFare = (details.distanceValue / 1000) * 10;
    var totalFare = basefare + timefare + distanceFare;
    // var totalFare =
    //     20 + (details.durationValue) + ((details.distanceValue / 1000) * 12);
    return totalFare.truncate();
  }
}
