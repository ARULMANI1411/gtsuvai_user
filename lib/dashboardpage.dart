
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'utility.dart';

class dashboardPage extends StatefulWidget {
  const dashboardPage({super.key});

  @override
  State<dashboardPage> createState() => _dashboardPageState();
}

class _dashboardPageState extends State<dashboardPage> {

  LocationData? _locationData;
  Location location =  Location();
  bool _serviceEnabled = false;
  late PermissionStatus _permissionGranted;

  TextEditingController search = TextEditingController();

  List restaurantList = [];
  List filRestaurant = [];
  List selItemList = [];
  String selItem = "";


  @override
  void initState(){
    super.initState();
    Future.wait([locationInit()]);
  }

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
      }
    } catch (r) {}
  }

  getRestaurant(String query) async {
    restaurantList.clear();
    // restaurantList.addAll(await DropdownServices.getRestaurant());
    setState(() {
      filRestaurant.clear();
      filRestaurant.addAll(restaurantList.where((e) => e["restaurant_name"].toString().toLowerCase().contains(query) ||
          e["item_details"].any((item) => item["item_name"].toString().toLowerCase().contains(query))));
      filRestaurant = filRestaurant.toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.white54,
                Colors.white
              ]
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("Welcome to GTSuvai",style: TextStyle(
                  fontSize: 30,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 10,),
            // Padding(
            //   padding: const EdgeInsets.all(15),
            //   child: Theme(
            //     data: ThemeData(
            //         textTheme: TextTheme(
            //             subtitle1: TextStyle(color: Colors.green)),
            //         iconTheme: IconThemeData(color: Colors.green)),
            //     child: DropdownSearch<dynamic>(
            //       mode: Mode.DIALOG,
            //       onFind: (String? filter) async {
            //         var response =
            //         await DropdownServices.getItem();
            //         return response;
            //       },
            //       selectedItem: selItemList.isNotEmpty
            //           ? selItemList[0]
            //           : null,
            //       dropdownSearchDecoration: InputDecoration(
            //         filled: true,
            //         fillColor: Colors.transparent,
            //         contentPadding: const EdgeInsets.symmetric(
            //             horizontal: 10, vertical: 5),
            //         hintText: 'Select Items',
            //         hintStyle: TextStyle(color: Colors.black),
            //         prefixIcon: Icon(
            //           Icons.search,color: Colors.black,
            //         ),
            //         errorMaxLines: 3,
            //         enabledBorder: OutlineInputBorder(
            //             borderSide: BorderSide(color: Colors.black12)),
            //         disabledBorder: OutlineInputBorder(
            //             borderSide: BorderSide(color: Colors.black12)),
            //         border: OutlineInputBorder(
            //             borderSide: BorderSide(color: Colors.black12)),
            //       ),
            //       validator: (value) {
            //         if (value == null) {
            //           return 'Please select items';
            //         }
            //         return null;
            //       },
            //       itemAsString: (u) => u["item_name"],
            //       onChanged: (data) {
            //         setState(() {
            //           selItem = data["item_name"];
            //           // Area = data["SubdistrictName"];
            //           selItemList.add(data);
            //           getRestaurant(selItem);
            //         });
            //         print(selItem.toString() + "  sel Item");
            //       },
            //       showSearchBox: true,
            //     ),
            //   ),
            // ),
            TextFormField(
              controller: search,
              // style: const TextStyle(color: mWhiteColor),
              onChanged: (value) {
                getRestaurant(value);
              },
              decoration: InputDecoration(
                // fillColor: mFillColor,
                filled: true,
                labelText: "Search",
                // labelStyle: mLabelTextStyle,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10,),
            // Center(child: Text("WHAT'S ON YOUR MIND?",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),)),
            // Container(
            //   height:150,
            //   width: double.infinity,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       Container(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             children: [
            //               GestureDetector(
            //                 onTap: (){
            //                   getRestaurant("Chicken Biryani");
            //                 },
            //                 child: Container(
            //                   height: 100,
            //                   width: 120,
            //                   decoration:BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     image: DecorationImage(
            //                         image: AssetImage("assets/biriyani.jpg"),
            //                         fit: BoxFit.fill
            //                     ),
            //                   ) ,
            //                 ),
            //               ),
            //               Text("Biriyani"),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             children: [
            //               GestureDetector(
            //                 onTap: (){
            //                   getRestaurant("Parotta");
            //                 },
            //                 child: Container(
            //                   height: 100,
            //                   width: 120,
            //                   decoration:BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     image: DecorationImage(
            //                         image: AssetImage("assets/parota.jpg"),
            //                         fit: BoxFit.fill
            //                     ),
            //                   ) ,
            //                 ),
            //               ),
            //               Text("Parota"),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             children: [
            //               GestureDetector(
            //                 onTap: (){
            //                   getRestaurant("Chicken");
            //                 },
            //                 child: Container(
            //                   height: 100,
            //                   width: 120,
            //                   decoration:BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     image: DecorationImage(
            //                         image: AssetImage("assets/chicken.jpg"),
            //                         fit: BoxFit.fill
            //                     ),
            //                   ) ,
            //                 ),
            //               ),
            //               Text("Chicken"),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             children: [
            //               GestureDetector(
            //                 onTap: (){
            //                   getRestaurant("Panneer");
            //                 },
            //                 child: Container(
            //                   height: 100,
            //                   width: 120,
            //                   decoration:BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     image: DecorationImage(
            //                         image: AssetImage("assets/panner.jpg"),
            //                         fit: BoxFit.fill
            //                     ),
            //                   ) ,
            //                 ),
            //               ),
            //               Text("Panner"),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             children: [
            //               GestureDetector(
            //                 onTap: (){
            //                   getRestaurant(" Noodles");
            //                 },
            //                 child: Container(
            //                   height: 100,
            //                   width: 120,
            //                   decoration:BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     image: DecorationImage(
            //                         image: AssetImage("assets/noodles.jpg"),
            //                         fit: BoxFit.fill
            //                     ),
            //                   ) ,
            //                 ),
            //               ),
            //               Text("Noodles"),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             children: [
            //               GestureDetector(
            //                 onTap: (){
            //                   getRestaurant("Veg Fried Rice");
            //                 },
            //                 child: Container(
            //                   height: 100,
            //                   width: 120,
            //                   decoration:BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     image: DecorationImage(
            //                         image: AssetImage("assets/friedrice.jpg"),
            //                         fit: BoxFit.fill
            //                     ),
            //                   ) ,
            //                 ),
            //               ),
            //               Text("FriedRice"),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Center(child: Text("NEARBY EXPLORES",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),)),
            // filRestaurant.isNotEmpty ?
            Container(
              height: 400,
              width: 450,
              child: ListView.builder(
                  itemCount: filRestaurant.length,
                  itemBuilder: (context, int index) {
                    return
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [

                            Container(
                              height: 200,
                              width:440,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //border: Border.all(color: Colors.black),
                                //borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Card(
                                    child: Container(
                                      height: 200,
                                      width: 180,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(image: AssetImage("assets/food2.jpg"),fit: BoxFit.fill)),
                                    ),
                                  ),
                                  Container(
                                    height: 150,
                                    width: 241,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(filRestaurant[index]["restaurant_name"],
                                          style: TextStyle(
                                              fontSize: 30,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold),),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.green),
                                          child: Icon(Icons.star,color: Colors.white,size:6),
                                        ),
                                        Row(
                                          children: [
                                            Text("Distance:",style: TextStyle(backgroundColor: Colors.grey),),
                                            Text(
                                              filRestaurant[index]["distance"].toString(),
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),),
                                            SizedBox(width: 2,),
                                            RichText(text: TextSpan(
                                                text: "Km",style: TextStyle(fontSize: 16, color: Colors.black54)
                                            ),),
                                          ],
                                        ),
                                        Container(
                                          height: 30,
                                          width: 200,
                                          decoration: BoxDecoration(gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              colors: [
                                                Colors.purple.shade100,Colors.white
                                              ])),
                                          child: Row(
                                            children: [
                                              Icon(Icons.forward,color: Colors.purple,),
                                              SizedBox(width: 30,),
                                              Text("Feedback",style: TextStyle(color: Colors.black),),
                                            ],
                                          ),
                                        )


                                      ],
                                    ),

                                    // child: ListTile(
                                    //    title: Text(filRestaurant[index]["restaurant_name"], style: TextStyle(
                                    //        fontSize: 16, color: Colors.green),),
                                    //    subtitle: Column(
                                    //      children: [
                                    //        Text(
                                    //          filRestaurant[index]["restaurant_address"],
                                    //          style: TextStyle(
                                    //              fontSize: 14, color: Colors.black54),),
                                    //       Row(
                                    //         children: [
                                    //           RichText(text: TextSpan(
                                    //             text: "DISTANCE :",style: TextStyle(fontSize: 16, color: Colors.green)
                                    //           ),),
                                    //           SizedBox(width: 6,),
                                    //           Text(
                                    //             filRestaurant[index]["distance"].toString(),
                                    //             style: TextStyle(
                                    //                 fontSize: 16, color: Colors.black54),),
                                    //           SizedBox(width: 6,),
                                    //           RichText(text: TextSpan(
                                    //               text: "Km",style: TextStyle(fontSize: 16, color: Colors.black54)
                                    //           ),),
                                    //         ],
                                    //       )
                                    //
                                    //      ],
                                    //    ),
                                    //    trailing: Icon(Icons.arrow_forward),
                                    //  ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                  }
              ),
            )


          ],
        ),
      ),
    );
  }
}
