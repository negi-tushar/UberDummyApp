import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberdummy/data_provider/appdata_provider.dart';
import 'package:uberdummy/datamodel/address_model.dart';
import 'package:uberdummy/datamodel/predection_model.dart';
import 'package:uberdummy/globalvariables.dart';
import 'package:uberdummy/helpers/helper_methods.dart';
import 'package:uberdummy/helpers/request_helper.dart';
import 'package:uberdummy/widgets/progressdialog.dart';

class predection_tile extends StatelessWidget {
  final Predections predections;

  const predection_tile({
    required this.predections,
    Key? key,
  }) : super(key: key);

  void setDropLocation(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const ProgressDialog(
            status: "Please wait...",
          );
        });
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=${predections.placeId}&key=$apiKey";
    var response = await Requesthelper.getresposnse(url);
    if (response == 'failed') {
      return;
    }
    if (response['status'] == "OK") {
      Address address = Address(
        placeName: response['result']['address_components'][1]['long_name'],
        formatedAddress: response['result']['formatted_address'],
        lat: response['result']['geometry']['location']['lat'],
        long: response['result']['geometry']['location']['lng'],
        placeId: predections.placeId,
      );
      Navigator.pop(context);
      Provider.of<AppData>(context, listen: false).updateDropAddress(address);
      print(address.formatedAddress);
      Navigator.pop(context, 'dropAddress');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setDropLocation(context);
      },
      child: ListTile(
        leading: const Icon(Icons.location_city),
        title: Text(predections.main_text),
        subtitle: Text(predections.secondary_text),
      ),
    );
  }
}
