import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uberdummy/constants.dart';
import 'package:uberdummy/data_provider/appdata_provider.dart';
import 'package:uberdummy/datamodel/direction_model.dart';
import 'package:uberdummy/globalvariables.dart';
import 'package:uberdummy/helpers/helper_methods.dart';
import 'package:uberdummy/screens/bookCabScreen.dart';
import 'package:uberdummy/screens/search_screen.dart';
import 'package:uberdummy/widgets/button.dart';
import 'package:uberdummy/widgets/divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uberdummy/widgets/progressdialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  double searchSheetheight = Platform.isIOS ? 300 : 275;
  double rideSheetheight = 0;
  double bookCabHeight = 0;
  DirectionDetails _fetchedDirectionDetails = DirectionDetails(
      distanceText: '',
      distanceValue: 0,
      durationText: '',
      durationValue: 0,
      encodedPoints: '');
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  double mapBottomPadding = 0;
  List<LatLng> polylineCordinates = [];
  Set<Polyline> _polylines = {};
  Set<Circle> _circle = {};
  Set<Marker> _marker = {};
  bool showDrawer = true;
  void showBottomSheet() async {
    await getDirections();
    setState(() {
      showDrawer = false;
      searchSheetheight = 0;
      rideSheetheight = Platform.isIOS ? 240 : 220;
      mapBottomPadding = Platform.isIOS ? 240 : 220;
    });
  }

  void showCabBookSheet() {
    setState(() {
      showDrawer = true;
      rideSheetheight = 0;
      bookCabHeight = Platform.isIOS ? 220 : 195;
      mapBottomPadding = Platform.isIOS ? 200 : 190;
    });
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(
      target: pos,
      zoom: 14,
    );
    // ignore: avoid_print

    //print('pos-->${position.latitude}');

    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    String address =
        await HelperMethods.getCoordinatedString(position, context);
    print('address---> $address');
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(50.601521, 22.732516),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HelperMethods.getUserDetails();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        color: Colors.white,
        width: 220,
        child: Drawer(
            child: ListView(
          children: [
            SizedBox(
              height: 150,
              child: DrawerHeader(
                child: Row(
                  children: [
                    Image.asset(
                      'images/user_icon.png',
                      height: 60,
                      width: 60,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Tushar Negi',
                          style: TextStyle(fontFamily: 'Brand-Bold'),
                        ),
                        Text('View Profile'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const divider(),
            const SizedBox(
              height: 20,
            ),
            const myListTile(
                icon: Icon(Icons.card_giftcard_outlined), title: 'Free Rides'),
            const myListTile(icon: Icon(Icons.payment), title: 'Payments'),
            const myListTile(icon: Icon(Icons.history), title: 'Rides History'),
            const myListTile(
                icon: Icon(Icons.support_agent_outlined), title: 'Support'),
          ],
        )),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationEnabled: true,
            polylines: _polylines,
            myLocationButtonEnabled: true,
            markers: _marker,
            circles: _circle,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            compassEnabled: true,

            // myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              setState(() {
                mapBottomPadding = searchSheetheight;
              });
              getCurrentLocation();
            },
          ),
          //menuButton

          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: AnimatedSize(
              // vsync: this,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                height: searchSheetheight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20.0,
                        spreadRadius: 0.5,
                        //offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nice to see you ${currentuser!.fname},',
                        style: const TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Where are you going?',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: (() async {
                          var response = await Navigator.of(context)
                              .pushNamed(SearchScreen.id);
                          if (response == 'dropAddress') {
                            showBottomSheet();
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                )
                              ]),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.search,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Search destination',
                                style: TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.home_outlined,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Your home location',
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      const divider(),
                      const SizedBox(
                        height: 7.0,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.work_outlined,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Work',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                'Your work location',
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 20,
            child: GestureDetector(
              onTap: () {
                if (showDrawer) {
                  scaffoldKey.currentState?.openDrawer();
                } else {
                  resetMap();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10.0,
                        spreadRadius: 0.3,
                        offset: Offset(0.5, 0.3),
                      )
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    showDrawer ? Icons.menu : Icons.arrow_back_ios_new_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            // top: 0,
            child: AnimatedSize(
              // vsync: this,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: rideSheetheight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: const Color.fromARGB(172, 158, 252, 174),
                          child: ListTile(
                            leading: const Icon(
                              Icons.car_rental_rounded,
                              size: 40,
                              color: Colors.blue,
                            ),
                            title: const Text(
                              'Taxi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle:
                                Text(_fetchedDirectionDetails.distanceText),
                            trailing: Text(
                              '₹ ${HelperMethods.getEstimatedFares(_fetchedDirectionDetails)}'
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //    dense: true,
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Row(
                          children: const [
                            Icon(Icons.money),
                            Text('Cash'),
                            Icon(CupertinoIcons.down_arrow),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 33, 172, 105),
                            ),
                            onPressed: () {
                              showCabBookSheet();
                              setRideRequest(context);
                            },
                            child: const Text('Request Cab'))
                      ]),
                ),
              ),
            ),
          ),

          Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 0,
              child: BookCab(
                reset: () {
                  resetMap();
                },
                height: bookCabHeight,
              )),
        ],
      ),
    );
  }

  resetMap() {
    setState(() {
      polylineCordinates.clear();
      _polylines.clear();
      _marker.clear();
      _circle.clear();
      rideSheetheight = 0;
      bookCabHeight = 0;
      searchSheetheight = Platform.isIOS ? 300 : 275;
      mapBottomPadding = Platform.isIOS ? 280 : 270;
      showDrawer = true;
    });
  }

  Future<void> getDirections() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ProgressDialog(status: 'Finding the shortest path...');
        });
    final pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    final drop = Provider.of<AppData>(context, listen: false).dropAddress;
    var pickupLatLang = LatLng(pickup!.lat, pickup.long);
    var dropLatLang = LatLng(drop!.lat, drop.long);
    var fetchedDetails =
        await HelperMethods.getDirectionDetails(pickupLatLang, dropLatLang);

    setState(() {
      _fetchedDirectionDetails = fetchedDetails!;
    });
    // print(fetchedDetails!.distanceText);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(fetchedDetails!.encodedPoints);
    polylineCordinates.clear();
    if (results.isNotEmpty) {
      for (var element in results) {
        polylineCordinates.add(LatLng(element.latitude, element.longitude));
      }
      Navigator.of(context).pop();

      setState(() {
        Polyline polyline = Polyline(
          polylineId: const PolylineId('polyid'),
          color: const Color.fromARGB(255, 176, 79, 255),
          width: 4,
          points: polylineCordinates,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          //geodesic: true,
        );

        _polylines.clear();
        _polylines.add(polyline);
      });
      //make polyline to fit into the Map.

      LatLngBounds bounds;
      if (pickupLatLang.latitude > dropLatLang.latitude &&
          pickupLatLang.longitude > dropLatLang.longitude) {
        bounds = LatLngBounds(southwest: dropLatLang, northeast: pickupLatLang);
      } else if (pickupLatLang.longitude > dropLatLang.longitude) {
        bounds = LatLngBounds(
            southwest: LatLng(pickupLatLang.latitude, dropLatLang.longitude),
            northeast: LatLng(dropLatLang.latitude, pickupLatLang.longitude));
      } else if (pickupLatLang.latitude > dropLatLang.latitude) {
        bounds = LatLngBounds(
          southwest: LatLng(dropLatLang.latitude, pickupLatLang.longitude),
          northeast: LatLng(pickupLatLang.latitude, dropLatLang.longitude),
        );
      } else {
        bounds = LatLngBounds(southwest: pickupLatLang, northeast: dropLatLang);
      }
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

      //create circles and markers

      Marker pickupmarker = Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLatLang,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
      );

      Marker dropkupmarker = Marker(
        markerId: const MarkerId('drop'),
        position: dropLatLang,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: drop.placeName, snippet: 'Drop Location'),
      );
      Circle pickupCircle = Circle(
          circleId: const CircleId('pickupCircle'),
          strokeColor: Colors.green,
          strokeWidth: 3,
          radius: 12,
          center: pickupLatLang,
          fillColor: Colors.blue);
      Circle dropCircle = Circle(
          circleId: const CircleId('dropCircle'),
          strokeColor: Colors.red,
          strokeWidth: 3,
          radius: 12,
          center: dropLatLang,
          fillColor: Colors.blue);
      setState(() {
        _marker.add(pickupmarker);
        _marker.add(dropkupmarker);
        _circle.add(pickupCircle);
        _circle.add(dropCircle);
      });
    }
  }

  void setRideRequest(BuildContext context) {
    rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var drop = Provider.of<AppData>(context, listen: false).dropAddress;

    Map pickupLocation = {
      'latitude': pickup!.lat,
      'longitude': pickup.long,
    };
    Map dropLocation = {
      'latitude': drop!.lat,
      'longitude': drop.long,
    };

    Map rideDetails = {
      'TimeStamp': DateTime.now().toIso8601String(),
      'User_id': currentuser?.id,
      'UseName': currentuser?.fname,
      'PickupAddress': pickup.placeName,
      'DropAddress': drop.placeName,
      'PayentMethod': 'Cash',
      'DriverId': 'waiting',
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
    };
    rideRef.set(rideDetails);
  }
}

// ignore: camel_case_types
class myListTile extends StatelessWidget {
  const myListTile({
    required this.icon,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: icon,
        title: Text(
          title,
          style: kstyleRegularFont,
        ));
  }
}
