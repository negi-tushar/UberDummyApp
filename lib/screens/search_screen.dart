import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:uberdummy/brand_colors.dart';
import 'package:uberdummy/data_provider/appdata_provider.dart';
import 'package:uberdummy/datamodel/predection_model.dart';
import 'package:uberdummy/globalvariables.dart';
import 'package:uberdummy/helpers/request_helper.dart';
import 'package:uberdummy/widgets/predection_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const String id = 'SearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickupController = TextEditingController();

  TextEditingController dropController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool focus = false;
  setFocus() {
    if (!focus) {
      FocusScope.of(context).requestFocus(focusNode);
      focus = true;
    }
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropController.dispose();
    super.dispose();
  }

  List<Predections> predectionsList = [];

  void searchPlaces(String value) async {
    if (value.length > 2) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$apiKey&components=country:in";
      var response = await Requesthelper.getresposnse(url);
      if (response == 'failed') {
        // print(response);
        return;
      }
      if (response['status'] == 'OK') {
        //  print(response);

        var d = response['predictions'] as List;
        List<Predections> dd = [];
        d.forEach((element) {
          dd.add(Predections(
              main_text: element['structured_formatting']['main_text'],
              placeId: element['place_id'],
              secondary_text: element['structured_formatting']
                  ['secondary_text']));
        });
        setState(() {
          predectionsList = dd.toList();
        });

        // print(predectionsList.last.main_text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    setFocus();
    String address = Provider.of<AppData>(context).pickupAddress == null
        ? ''
        : Provider.of<AppData>(context).pickupAddress!.placeName;
    pickupController.text = address;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 0.5,
                offset: Offset(
                  0.7,
                  0.7,
                ),
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      const Center(
                        child: Text(
                          'Set Destination',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.green,
                      ),
                      Expanded(
                          child: TextField(
                        controller: pickupController,
                        decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            hintText: 'Pickup Location',
                            fillColor: BrandColors.colorLightGrayFair,
                            border: InputBorder.none),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          controller: dropController,
                          decoration: const InputDecoration(
                              filled: true,
                              isDense: true,
                              hintText: 'Drop Location',
                              fillColor: BrandColors.colorLightGrayFair,
                              border: InputBorder.none),
                          onChanged: (value) {
                            searchPlaces(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: predectionsList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) {
                return predection_tile(predections: predectionsList[index]);
              }),
            ),
          ),

          //  const predection_tile(),
        ]),
      ),
    );
  }
}
