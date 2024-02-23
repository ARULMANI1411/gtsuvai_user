import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Services/dropdownservices.dart';
import 'Services/mainServices.dart';
import 'constants.dart';
class mustTry extends StatefulWidget {
  const mustTry({super.key});

  @override
  State<mustTry> createState() => _mustTryState();
}

class _mustTryState extends State<mustTry> {

  List mustTryList = [];
  late Future<List> _future;
  bool isLoading = false;

void initState(){
  super.initState();
  _future = getRestaurants();
}


  Future<void> _refresh() async {
    Future.delayed(const Duration(milliseconds: 1));
    setState(() {
      mustTryList.clear();
      _future = getRestaurants();
    });
  }

 Future<List> getRestaurants() async {
    mustTryList.clear();
    mustTryList.addAll(await DropdownServices.getMustTry());
   setState(() {
     mustTryList = mustTryList.toSet().toList();
   });
    return mustTryList;
  }


  Future<void> _launchGoogleMapsDirections(double endLatitude, double endLongitude) async {
    LocationData currentLocation = await Location().getLocation();
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=$endLatitude,$endLongitude";

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
          // Util.checkInternetManagerWidget(
          //   LoadingOverlay(
          //       isLoading: isLoading,
          //       color: mThemeColor,
          //       opacity: .3,
          //       child:
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        height: 80,
                        width: 120,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/gtsuvailogo.png"),fit: BoxFit.fill)
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
                                      child: mustTryList.isNotEmpty ?  ListView.builder(
                                          itemCount: mustTryList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              children: [
                                                SizedBox(height: 30,),
                                                Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.grey.shade400)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(3),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(5,5,0,5),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        height: 25,
                                                                        width: 25,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors.red),
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                        ),
                                                                        child: Icon(Icons.arrow_drop_up,size: 25,
                                                                          color: Colors.red,),
                                                                      ),
                                                                      SizedBox(width: 10,),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.rectangle
                                                                        ),
                                                                        height: 30,
                                                                        width: 85,
                                                                        child: MaterialButton(
                                                                          onPressed: () {  },
                                                                          color:Colors.redAccent ,
                                                                          child: Text("Must Try",
                                                                            style: TextStyle(fontSize: 13,
                                                                                color: Colors.white),),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(mustTryList[index]["itemName"], style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.bold),),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(mustTryList[index]["restaurantName"], style: TextStyle(
                                                                            color: Colors.black54,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold),),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Visibility(
                                                                    visible: mustTryList[index]["itemRating"] != null,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(mustTryList[index]["itemRating"].toString() + "  Ratings" , style: TextStyle(
                                                                            color: Colors.green, fontSize: 18,),),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text("\u20b9" + mustTryList[index]["price"].toString(), style: TextStyle(
                                                                            color: Colors.red,
                                                                            fontSize: 16),),
                                                                      ),
                                                                      Expanded(
                                                                        child: Container(
                                                                          height: 40,
                                                                          width: 80,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(13),
                                                                              color: Colors.green
                                                                          ),
                                                                          child: IconButton(
                                                                              onPressed: () {
                                                                                _launchGoogleMapsDirections(double.parse(mustTryList[index]["latitude"].toString()),double.parse( mustTryList[index]["longtitude"].toString())); // Replace with your starting and ending latitude and longitude
                                                                              },
                                                                              icon: Icon(Icons.directions,size: 30,color: Colors.white,)),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                mustTryList[index]["itemImage"].isNotEmpty ?
                                                                Container(
                                                                  height: 150,
                                                                  width: 160,
                                                                  decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                          begin: Alignment.topCenter,
                                                                          end: Alignment.bottomCenter,
                                                                          colors: [
                                                                            Colors.transparent, Colors.black
                                                                          ]
                                                                      ),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.grey.withOpacity(0.5),
                                                                          spreadRadius: 3,
                                                                          blurRadius: 5,
                                                                          offset: Offset(0, 3),
                                                                        ),
                                                                      ],
                                                                      //color: Colors.white,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      image: DecorationImage(image: NetworkImage(Services.baseURL + mustTryList[index]["itemImage"].toString()),fit: BoxFit.fill)),
                                                                )  :   Container(
                                                                  height: 150,
                                                                  width: 160,
                                                                  decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                          begin: Alignment.topCenter,
                                                                          end: Alignment.bottomCenter,
                                                                          colors: [
                                                                            Colors.transparent, Colors.black
                                                                          ]
                                                                      ),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.grey.withOpacity(0.5),
                                                                          spreadRadius: 3,
                                                                          blurRadius: 5,
                                                                          offset: Offset(0, 3),
                                                                        ),
                                                                      ],
                                                                      //color: Colors.white,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      image: DecorationImage(image:AssetImage("assets/gtsuvai.png"),fit: BoxFit.fill)),
                                                                ) ,
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                      ) : Center(child: Text("No Records Found",style: TextStyle(color: Colors.red,fontSize: 20),))
                                  );
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                ),
          //       () {
          //     _refresh();
          //   },
          // )
        )
    );
  }
}


