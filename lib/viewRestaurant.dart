import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Services/dropdownservices.dart';
import 'Services/mainServices.dart';
import 'constants.dart';
import 'utility.dart';

class viewRestaurant extends StatefulWidget {
  const viewRestaurant({super.key});

  @override
  State<viewRestaurant> createState() => _viewRestaurantState();
}

class _viewRestaurantState extends State<viewRestaurant> {
  int mycount = 0;
  LocationData? _locationData;
  Location location = Location();
  bool _serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  bool isLoading = false;

  TextEditingController search = TextEditingController();

  late Future<List> _future;

  List restaurantList = [];
  List filRestaurant = [];
  List restaurant = [];
  String from = "";
  String key = "";

  List selItemList = [];
  String selItem = "";

  //List filRestaurant = [];
  final List<String> items = ['By Distance', 'By Price', 'By Rating'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    key = "";
    _future = _initializeData();
  }

  Future<List> _initializeData() async {
    await Future.wait([locationInit()]);
    // from = "By Distance";
    return getRestaurants();
  }


  Future<List> getRestaurants() async {
    restaurantList.clear();
    restaurantList.addAll(await DropdownServices.viewItemDtls(
        key, _locationData!.latitude, _locationData!.longitude));
    // setState(() {
    filRestaurant.clear();
    filRestaurant.addAll(restaurantList);
    filRestaurant = filRestaurant.toSet().toList();
    // });
    print(filRestaurant);
    return filRestaurant;
  }

  /// Location Initial
  Future locationInit() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) _serviceEnabled = await location.requestService();

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied ||
          _permissionGranted == PermissionStatus.deniedForever) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Get.back();
          Util.toast("Location Permission Must Be Granted to View This Page");
        }
      }
      if (_permissionGranted == PermissionStatus.granted) {
        _locationData = await location.getLocation();
        if (mounted) setState(() {});
        location.changeSettings(
            accuracy: LocationAccuracy.balanced, interval: 5);
        location.onLocationChanged.listen((LocationData currentLocation) {
          _locationData = currentLocation;
          if (mounted) setState(() {});
        });

        print(_locationData!.latitude.toString());
        print(_locationData!.longitude.toString());
      }
    } catch (r) {
      print(r);
    }
  }

  ///Get RestaurantDetails
  Future<List> getRestaurantDetails() async {
    restaurantList.clear();
    try {
      restaurantList.addAll(await DropdownServices.getRestaurant(
          "",
          double.parse(_locationData!.latitude.toString()),
          double.parse(_locationData!.longitude.toString())));
    } catch (e) {
      print("Error fetching data: $e");
    }
    filRestaurant.addAll(restaurantList);
    filRestaurant = filRestaurant.toSet().toList();
    return filRestaurant;
  }

  Future
  ///Search Restaurant and Item
  searchRestaurants(String query) async {
    print(query.toString() + " Query");
    print(restaurantList.toString() + " restaurantList");
    filRestaurant.clear();
    // print(restaurantList);
    setState(() {
      print("abcd");
      print(restaurantList.length);
      filRestaurant.addAll(restaurantList.where((e) =>
          e["restaurant_name"].toString().toLowerCase().contains(query) ||
          e["item_details"].any((item) => item["item_name"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))));
      // filRestaurant.addAll(restaurantList);
      print(filRestaurant);
      filRestaurant = filRestaurant.toSet().toList();
      print("dnsdncdn");
      print(filRestaurant);
      print(filRestaurant.length);
    });
  }

  Future<void> _refresh() async {
    Future.delayed(const Duration(milliseconds: 1));
    setState(() {
      filRestaurant.clear();
      _future = _initializeData();
    });
  }

  ///Google map navigation
  Future<void> _launchGoogleMapsDirections(
      double endLatitude, double endLongitude) async {
    LocationData currentLocation = await Location().getLocation();
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=$endLatitude,$endLongitude";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
        //Util.checkInternetManagerWidget(


          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Column(
              children: [
                Container(
                  height: 70,
                  width: 120,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/gtsuvailogo.png"),
                          fit: BoxFit.fill)),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    height: 60,
                    child: TextFormField(
                      controller: search,
                      onChanged: (query) {
                        setState(() {
                          key = query;
                          _refresh();
                        });
                        // filRestaurant = _getFilteredSuggestions(value);
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade200),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade200),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          label: Text("Search"),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 18),
                          focusColor: Colors.grey,
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.black45,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List>(
                      future: _future,
                      builder: (BuildContext context,
                          AsyncSnapshot<List> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.red,
                          ));
                        } else {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                              'Error: ${snapshot.error}',
                            ));
                          } else {
                            return RefreshIndicator(
                                color: Colors.red,
                                backgroundColor: mThemeColor,
                                edgeOffset: 0,
                                displacement: 100,
                                onRefresh: _refresh,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filRestaurant.length,
                                    itemBuilder: (context, int index) {
                                      return key != "" &&
                                              filRestaurant[index][
                                                      "isRestaurantORItem"] ==
                                                  "Item"
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration:
                                                        BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        170,
                                                                    width:
                                                                        160,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                                              Colors.transparent,
                                                                              Colors.black
                                                                            ]),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.5),
                                                                                spreadRadius: 5,
                                                                                blurRadius: 7,
                                                                                offset: Offset(0, 3),
                                                                              ),
                                                                            ],
                                                                            //color: Colors.white,
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            image: DecorationImage(image: NetworkImage(Services.baseURL + filRestaurant[index]["itemImage"].toString()), fit: BoxFit.fill)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Text(
                                                                      filRestaurant[index]
                                                                          [
                                                                          "itemName"],
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 20,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Text(
                                                                          "Restaurant Name :" +
                                                                      filRestaurant[index]
                                                                          ["restaurantName"],
                                                                      style: TextStyle(
                                                                          color: Colors.black54,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          Text(
                                                                    "Distance: " +
                                                                        filRestaurant[index]["distance"].toString() +
                                                                        "Km",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ))
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Visibility(
                                                                visible: filRestaurant[index]["itemRating"] != null,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.stars,
                                                                            color: Colors.green,
                                                                          ),
                                                                          Text(
                                                                            filRestaurant[index]["itemRating"].toString(),
                                                                            style: TextStyle(
                                                                              color: Colors.green,
                                                                              fontSize: 18,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Text(
                                                                      "\u20b9" +
                                                                          filRestaurant[index]["price"].toString(),
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40,
                                                                      width:
                                                                          80,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(13),
                                                                          color: Colors.green),
                                                                      child: IconButton(
                                                                          onPressed: () {
                                                                            _launchGoogleMapsDirections(double.parse(filRestaurant[index]["latitude"].toString()), double.parse(filRestaurant[index]["longtitude"].toString())); // Replace with your starting and ending latitude and longitude
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.directions,
                                                                            size: 30,
                                                                            color: Colors.white,
                                                                          )),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                  child: Container(
                                                    decoration:
                                                        BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  filRestaurant[index]["restaurantImage"] == null || filRestaurant[index]["itemImage"] == null ||
                                                                      (filRestaurant[index]["restaurantImage"].isEmpty &&
                                                                          filRestaurant[index]["itemImage"].isEmpty)
                                                                      ? Container(
                                                                          height: 170,
                                                                          width: 180,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                                                    Colors.transparent,
                                                                                    Colors.black
                                                                                  ]),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.grey.withOpacity(0.5),
                                                                                      spreadRadius: 5,
                                                                                      blurRadius: 7,
                                                                                      offset: Offset(0, 3),
                                                                                    ),
                                                                                  ],
                                                                                  //color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  image: DecorationImage(image: AssetImage("assets/gtsuvai.png"), fit: BoxFit.fill)),
                                                                        )
                                                                      : Container(
                                                                          height: 170,
                                                                          width: 180,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                                                    Colors.transparent,
                                                                                    Colors.black
                                                                                  ]),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.grey.withOpacity(0.5),
                                                                                      spreadRadius: 5,
                                                                                      blurRadius: 7,
                                                                                      offset: Offset(0, 3),
                                                                                    ),
                                                                                  ],
                                                                                  //color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  image: DecorationImage(image: NetworkImage(filRestaurant[index]["restaurantImage"].toString().isNotEmpty ? Services.baseURL + filRestaurant[index]["restaurantImage"].toString() : Services.baseURL + filRestaurant[index]["itemImage"].toString()), fit: BoxFit.fill)),
                                                                        ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    8.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        filRestaurant[index]["itemName"].isNotEmpty
                                                                            ? filRestaurant[index]["itemName"].toString().trim()
                                                                            : filRestaurant[index]["restaurantName"],
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text( " Restaurant Name : " +
                                                                        filRestaurant[index]["restaurantName"],
                                                                        style: TextStyle(
                                                                            color: Colors.black54,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Text(
                                                                      "Distance: " +
                                                                          filRestaurant[index]["distance"].toString() +
                                                                          "Km",
                                                                      style: TextStyle(
                                                                          color: Colors.red,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w500),
                                                                    ))
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      10,
                                                                ),
                                                                Visibility(
                                                                  visible: filRestaurant[index]["itemRating"] != null,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.stars,
                                                                              color: Colors.green,
                                                                            ),
                                                                            Text(
                                                                              filRestaurant[index]["itemRating"].toString(),
                                                                              style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontSize: 18,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Visibility(
                                                                            visible: filRestaurant[index][
                                                                            "isRestaurantORItem"] ==
                                                                                "Item",
                                                                            child: Text(
                                                                        "\u20b9" +
                                                                              filRestaurant[index]["price"].toString(),
                                                                        style:
                                                                              TextStyle(color: Colors.black, fontSize: 16),
                                                                      ),
                                                                          ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          15,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            80,
                                                                        decoration:
                                                                            BoxDecoration(borderRadius: BorderRadius.circular(13), color: Colors.green),
                                                                        child: IconButton(
                                                                            onPressed: () {
                                                                              _launchGoogleMapsDirections(double.parse(filRestaurant[index]["latitude"].toString()), double.parse(filRestaurant[index]["longtitude"].toString())); // Replace with your starting and ending latitude and longitude
                                                                            },
                                                                            icon: Icon(
                                                                              Icons.directions,
                                                                              size: 30,
                                                                              color: Colors.white,
                                                                            )),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                    }));
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
        //   () {
        //     _refresh();
        //   },
        // ),
      ),
    );
  }
}
