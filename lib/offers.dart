import 'package:flutter/material.dart';
import 'package:foodie_user_app/utility.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Services/dropdownservices.dart';
import 'Services/mainServices.dart';
import 'constants.dart';
class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List offerList = [];
  late Future<List> _future;
  bool isLoading = false;

  void initState(){
    super.initState();
    _future = getRestaurants();
  }


  Future<void> _refresh() async {
    Future.delayed(const Duration(milliseconds: 1));
    setState(() {
      offerList.clear();
      _future = getRestaurants();
    });
  }

  Future<List> getRestaurants() async {
    offerList.clear();
    offerList.addAll(await DropdownServices.getOffers());
    setState(() {
      offerList = offerList.toSet().toList();
    });
    return offerList;
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
                        Container(
                          height: 70,
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
                                        child:  offerList.isNotEmpty ? ListView.builder(
                                            itemCount: offerList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        _launchGoogleMapsDirections(double.parse(offerList[index]["res_Latitude"].toString()),double.parse( offerList[index]["res_Longitude"].toString()));
                                                      },
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 300,
                                                              width: 400,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20),
                                                                image: DecorationImage(
                                                                  image: NetworkImage(Services.baseURL +offerList[index]["offerImage"].toString().replaceAll("\\", "/")),
                                                                  fit: BoxFit.fill
                                                                )
                                                              ),
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 23),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child: Text(offerList[index]["res_Name"],style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w500),)
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 15),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(Icons.stars,color: Colors.green,),
                                                                        Text(offerList[index]["res_Rating"].toString(),style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w500)),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 25),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child: Text(offerList[index]["description"],style: TextStyle(color: Colors.black54,fontSize: 20),)),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 15),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(offerList[index]["distance"].toString(),style: TextStyle(color: Colors.black54,fontSize: 20),),
                                                                        Text("Km")
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            }
                                        ) : Center(
                                          child: Text("No Records Found",style: TextStyle(color: Colors.red,fontSize: 20),),
                                        )
                                    );
                                  }
                                }
                              }),
                        ),
                      ],
                    ),
                  )
              // ),
              //     () {
              //   _refresh();
              // },
            // )
        )
    );
  }
}
