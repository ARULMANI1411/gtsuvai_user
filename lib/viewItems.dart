import 'dart:math';

import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'Services/dropdownservices.dart';
import 'Services/mainServices.dart';

class ViewItems extends StatefulWidget {
  final int restaurantId;
  // final int itemId;
  final String restaurantName;

  const ViewItems(this.restaurantId, this.restaurantName,{Key? key})
      : super(key: key);

  // get itemId => this.restaurantId;



  @override
  _ViewItemsState createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 600,
            child: Container(
              height: 100,
              width: double.infinity,
              child: filReview.isNotEmpty ?
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: filReview.length,
                  itemBuilder: (context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Container(
                        height: 200,
                        width: 400,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: 100,),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text("Reviewer Id:",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Outfit',fontSize: 20),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      filReview[index]["item_reviewId"]
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 20,
                                        overflow: TextOverflow.ellipsis,
                                        //    fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    filReview[index]["item_rating"]
                                        .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                      //    fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Icon(Icons.star,color: Colors.amber,size: 25,)
                                ],
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 10,),
                              child: Expanded(
                                child: Text(
                                  filReview[index]["item_review"]
                                      .toString(),
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                    //    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
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
                    );
                  }) :
              Center(
                child:
                Text("No records found"),
              ),
            )
        );
      },
    );
  }
  TextEditingController searchItem = TextEditingController();
  TextEditingController review=TextEditingController();
  bool isLoading=false;

  late Future<List> _future;
  List ItemList = [];
  List filItem = [];
  int mycount = 0;

  List reviewList=[];
  List filReview=[];

  getReview(itemId) async {
    print("ghfdg");
    reviewList.clear();
    reviewList.addAll(
        await DropdownServices.getuserreview(widget.restaurantId, itemId));
    setState(() {
      filReview.clear();
      filReview.addAll(reviewList);
    });

    filReview = filReview.toSet().toList();
    return filReview;
  }

  Future<List> getItems() async {
    ItemList.clear();
    ItemList.addAll(
        await DropdownServices.getRestaurantItem(widget.restaurantId));
    setState(() {
      filItem.clear();
      filItem.addAll(ItemList);
      print(filItem);
    });

    filItem = filItem.toSet().toList();
    // print(Services.BaseUrls + filItem[0]["item_photo"]);
    // print(filItem);
    return filItem;
  }

  searchrestItem(String query) async {
    print(query);
    filItem.clear();
    setState(() {
      filItem.addAll(ItemList.where(
              (e) => e["item_name"].toString().toLowerCase().contains(query)));
      filItem = filItem.toSet().toList();
    });
  }

  Future<void> _refresh() async {
    Future.delayed(const Duration(milliseconds: 20));
    setState(() {
      filItem.clear();
      _future = getItems();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.restaurantId);
    _future = getItems();
    // _future = getreview();

    // _scrollController = ScrollController()
    //   ..addListener(() {
    //     setState(() {
    //       _textColor = _isSliverAppBarExpanded ? Colors.white : Colors.black;
    //     });
    //   });
  }

  // bool get _isSliverAppBarExpanded {
  //   return _scrollController.hasClients &&
  //       _scrollController.offset > kExpandedHeight - kToolbarHeight;
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Color(0xffe9eaef),
          backgroundColor: Color(0xffe9eaef),
          leading: IconButton(onPressed: (){
            Get.back();
          }, icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Card(
                child: Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    //border: Border.all(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      // Text("${snapshot.error}")
                      widget.restaurantName,
                      //filItem"item_name".toString(),
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 380,
                child: TextFormField(
                  controller: searchItem,
                  onChanged: (value) {
                    searchrestItem(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),

                    filled: true,
                    fillColor: Color(0xffe9eaef),
                    label: Center(child: Text("Search for dishes")),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    focusColor: Colors.grey,
                  ),
                ),
              ),
              FutureBuilder<List>(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                    return Container(
                      height: 800,
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filItem.length,
                          itemBuilder: (context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 200,
                                    width: 440,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Container(
                                            height: 150,
                                            width: 241,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                // Text(
                                                //   filItem[index]["item_type"].toString(),
                                                //   style: TextStyle(
                                                //     fontFamily: 'Outfit',
                                                //     fontSize: 20,
                                                //     overflow:
                                                //     TextOverflow.ellipsis,
                                                //     //    fontWeight: FontWeight.bold
                                                //   ),
                                                // ),
                                                Text(
                                                  filItem[index]["item_name"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Outfit',
                                                    fontSize: 20,
                                                    overflow: TextOverflow.ellipsis,
                                                    //    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(20),
                                                          color: Colors.green),
                                                      child: Icon(Icons.star,
                                                          color: Colors.white,
                                                          size: 12),
                                                    ),
                                                    Text(
                                                      filItem[index]["avg_rating"]
                                                          .toString().isNotEmpty ?
                                                      double.parse(filItem[index]["avg_rating"].toStringAsFixed(1)).toString() : "0"
                                                      ,
                                                      style: TextStyle(
                                                          fontFamily: 'Outfit',
                                                          fontSize: 20,
                                                          color: Colors.green,
                                                          overflow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.currency_rupee_outlined,
                                                      size: 25,
                                                      weight: 300,
                                                    ),
                                                    Text(
                                                      filItem[index]["item_price"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        fontSize: 20,
                                                        overflow: TextOverflow.ellipsis,
                                                        //    fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.centerLeft,
                                                          colors: [
                                                            Color(0xffd6f0ef),
                                                            Colors.white
                                                          ])),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      openAlertBox(filItem[index]["itemId"]);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.forward,
                                                          color: Color(0xff5d3cc8),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        Text(
                                                          "Feedback",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Color(0xff5d3cc8)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                // Row(
                                                //   children: [
                                                //     Text("Distance:",
                                                //       style: TextStyle(
                                                //           backgroundColor: Colors
                                                //               .grey),),
                                                //     Text(
                                                //       "0.29",
                                                //       //filRestaurant[index]["distance"].toString(),
                                                //       style: TextStyle(
                                                //           fontSize: 20,
                                                //           color: Colors
                                                //               .black,
                                                //           fontWeight: FontWeight
                                                //               .bold),),
                                                //     SizedBox(width: 2,),
                                                //     RichText(text: TextSpan(
                                                //         text: "Km",
                                                //         style: TextStyle(
                                                //             fontSize: 16,
                                                //             color: Colors
                                                //                 .black54)
                                                //     ),),
                                                //   ],
                                                // ),
                                                // Container(
                                                //   height: 30,
                                                //   width: 200,
                                                //   decoration: BoxDecoration(gradient: LinearGradient(
                                                //       begin: Alignment.centerLeft,
                                                //       colors: [
                                                //         Color(0xffd6f0ef),Colors.white
                                                //       ])),
                                                //   child: GestureDetector(
                                                //     onTap: (){
                                                //       Get.offAll(openAlertBox());
                                                //
                                                //     },
                                                //     child: Row(
                                                //       children: [
                                                //         Icon(Icons.forward,color: Color(0xff5d3cc8),),
                                                //         SizedBox(width: 30,),
                                                //         Text("Feedback",style: TextStyle(fontWeight:FontWeight.bold,color: Color(0xff5d3cc8)),),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // )
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
                                        ),
                                        Card(
                                          child: Stack(
                                            //  children:
                                            children: [
                                              Container(
                                                height: 150,
                                                width: 180,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.black
                                                        ]),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
                                                    //color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          //"assets/friedrice.jpg"
                                                            Services.BaseUrls +
                                                                filItem[index]
                                                                ["item_photo"]),
                                                        fit: BoxFit.fill)),
                                              ),
                                              Positioned(
                                                  top: 3,
                                                  left: 5,
                                                  child: IconButton(onPressed: (){
                                                    print("khjgjsd");
                                                    print(filItem[index]
                                                    ["restaurantId"].toString() + " ");
                                                    print(filItem[index]
                                                    ["itemId"].toString() + " itemId");
                                                    getReview(int.parse(filItem[index]
                                                    ["itemId"].toString())).whenComplete(() {
                                                      _showBottomSheet(context);
                                                    });
                                                  },icon:Icon( Icons.reviews_outlined,size: 20,)))
                                              // Positioned(
                                              //   bottom: 1
                                              //   , child: Container(
                                              //   height: 100,
                                              //   width: 179,
                                              //   decoration: BoxDecoration(
                                              //       borderRadius: BorderRadius
                                              //           .circular(15),
                                              //       gradient: LinearGradient(
                                              //           begin: Alignment
                                              //               .topCenter,
                                              //           end: Alignment
                                              //               .bottomCenter,
                                              //           colors: [
                                              //             Colors
                                              //                 .transparent,
                                              //             Colors.black
                                              //           ])
                                              //   ),
                                              //   child: Center(
                                              //     child: Row(
                                              //       children: [
                                              //         Icon(Icons
                                              //             .currency_rupee,
                                              //           color: Colors.white,
                                              //           weight: 30,
                                              //           size: 25,),
                                              //         Text("100 Off",
                                              //           style: TextStyle(
                                              //               fontFamily: 'Outfit',
                                              //               fontSize: 20,
                                              //               fontWeight: FontWeight
                                              //                   .w900,
                                              //               color: Colors
                                              //                   .white),),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  })
            ],
          ),
        ));

    // NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //   return <Widget>[
    //
    //     SliverAppBar(
    //       // show and hide SliverAppBar Title
    //       backgroundColor: Color(0xffe9eaef),
    //       title: _isSliverAppBarExpanded
    //           ? Row(
    //
    //         children: [
    //           IconButton(onPressed: (){
    //             Get.back();
    //           }, icon: Icon(Icons.arrow_back)),
    //           Padding(
    //             padding:  EdgeInsets.only(left: 50),
    //             child: Text(
    //               'A2B-Adayar Anandhabhavan Hotel',
    //               style: TextStyle(fontSize: 15,
    //                   color: Colors.black,
    //                   fontFamily: 'Outfit',
    //                   fontWeight: FontWeight.w900
    //               ),
    //             ),
    //           ),
    //         ],
    //       )
    //           : null,
    //       pinned: false,
    //       snap: false,
    //       floating: true,
    //       expandedHeight: kExpandedHeight,
    //
    //       // show and hide FlexibleSpaceBar title
    //       flexibleSpace: _isSliverAppBarExpanded
    //           ? null
    //           : FlexibleSpaceBar(
    //         centerTitle: true,
    //         title: Card(
    //           child: Container(
    //             height:120,
    //             width: 300,
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               //border: Border.all(),
    //               borderRadius: BorderRadius.circular(15),
    //             ),
    //             child: Center(
    //               child: Text(
    //                 'A2B-Adayar Anandhabhavan Hotel',
    //                 textScaleFactor: 1,
    //                 style: TextStyle(
    //                     color: Colors.black,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 15),
    //               ),
    //             ),
    //           ),
    //         ),
    //
    //         // background: Card(
    //         //   child: Center(
    //         //     child: Text('A2B-Adayar Anandhabhavan Hotel',
    //         //       textScaleFactor: 1,
    //         //       style: TextStyle(
    //         //           color: Colors.black,
    //         //           fontWeight: FontWeight.bold,
    //         //           fontSize: 20),),
    //         //   ),
    //         // ),
    //       ),
    //     ),
    //   ];
    //   },
    //   body: Column(
    //     children: [
    //       SizedBox(
    //         height: 30,
    //       ),
    //
    //       Container(
    //         height: 40,
    //         width: 380,
    //         child: TextFormField(
    //           //controller: search,
    //           onChanged: (value) {
    //            // searchRestaurant(value);
    //           },
    //           decoration: InputDecoration(
    //             focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(10),
    //               borderSide: BorderSide(color: Colors.transparent),
    //             ),
    //             enabledBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(10),
    //               borderSide: BorderSide(color: Colors.transparent),
    //             ),
    //             errorBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(10),
    //               borderSide: BorderSide(color: Colors.transparent),
    //             ),
    //
    //             filled: true,
    //             fillColor: Color(0xffe9eaef),
    //             // prefixIcon: IconButton(
    //             //     onPressed: (){
    //             //       Get.back();
    //             //     },
    //             //     icon: Icon(Icons.arrow_back_ios,color: Colors.red,size: 18,)),
    //             //
    //             label: Center(child: Text("Search for dishes")),
    //             labelStyle: TextStyle(color: Colors.grey,fontSize: 18),
    //             focusColor: Colors.grey,
    //           ),
    //         ),
    //       ),
    //
    //   ListView.builder(
    //       shrinkWrap: true,
    //       itemCount: 5,
    //       itemBuilder: (context, int index) {
    //         return
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               children: [
    //
    //                 Container(
    //                   height: 230,
    //                   width:440,
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     //border: Border.all(color: Colors.black),
    //                     //borderRadius: BorderRadius.circular(10),
    //                   ),
    //                   child: Row(
    //                     children: [
    //
    //                       Padding(
    //                         padding:  EdgeInsets.only(left: 5),
    //                         child: Container(
    //                           height: 150,
    //                           width: 241,
    //                           child:Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Text("Panner Butter Masala",
    //                                 style: TextStyle (fontFamily: 'Outfit',
    //                                   fontSize: 20,
    //                                   overflow: TextOverflow.ellipsis,
    //                                   //    fontWeight: FontWeight.bold
    //                                 ),),
    //                               Row(
    //                                 children: [
    //                                   Container(
    //                                     height: 20,
    //                                     width: 20,
    //                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.green),
    //                                     child: Icon(Icons.star,color: Colors.white,size:12),
    //                                   ),
    //                                   Text("(4.4)",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900),)
    //                                 ],
    //                               ),
    //                               Row(
    //                                 children: [
    //                                   Text("Distance:",style: TextStyle(backgroundColor: Colors.grey),),
    //                                   Text(
    //                                     "0.29",
    //                                     //filRestaurant[index]["distance"].toString(),
    //                                     style: TextStyle(
    //                                         fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),),
    //                                   SizedBox(width: 2,),
    //                                   RichText(text: TextSpan(
    //                                       text: "Km",style: TextStyle(fontSize: 16, color: Colors.black54)
    //                                   ),),
    //                                 ],
    //                               ),
    //                               // Container(
    //                               //   height: 30,
    //                               //   width: 200,
    //                               //   decoration: BoxDecoration(gradient: LinearGradient(
    //                               //       begin: Alignment.centerLeft,
    //                               //       colors: [
    //                               //         Color(0xffd6f0ef),Colors.white
    //                               //       ])),
    //                               //   child: GestureDetector(
    //                               //     onTap: (){
    //                               //       Get.offAll(openAlertBox());
    //                               //
    //                               //     },
    //                               //     child: Row(
    //                               //       children: [
    //                               //         Icon(Icons.forward,color: Color(0xff5d3cc8),),
    //                               //         SizedBox(width: 30,),
    //                               //         Text("Feedback",style: TextStyle(fontWeight:FontWeight.bold,color: Color(0xff5d3cc8)),),
    //                               //       ],
    //                               //     ),
    //                               //   ),
    //                               // )
    //
    //
    //                             ],
    //                           ),
    //
    //                           // child: ListTile(
    //                           //    title: Text(filRestaurant[index]["restaurant_name"], style: TextStyle(
    //                           //        fontSize: 16, color: Colors.green),),
    //                           //    subtitle: Column(
    //                           //      children: [
    //                           //        Text(
    //                           //          filRestaurant[index]["restaurant_address"],
    //                           //          style: TextStyle(
    //                           //              fontSize: 14, color: Colors.black54),),
    //                           //       Row(
    //                           //         children: [
    //                           //           RichText(text: TextSpan(
    //                           //             text: "DISTANCE :",style: TextStyle(fontSize: 16, color: Colors.green)
    //                           //           ),),
    //                           //           SizedBox(width: 6,),
    //                           //           Text(
    //                           //             filRestaurant[index]["distance"].toString(),
    //                           //             style: TextStyle(
    //                           //                 fontSize: 16, color: Colors.black54),),
    //                           //           SizedBox(width: 6,),
    //                           //           RichText(text: TextSpan(
    //                           //               text: "Km",style: TextStyle(fontSize: 16, color: Colors.black54)
    //                           //           ),),
    //                           //         ],
    //                           //       )
    //                           //
    //                           //      ],
    //                           //    ),
    //                           //    trailing: Icon(Icons.arrow_forward),
    //                           //  ),
    //                         ),
    //                       ),
    //                       Card(
    //
    //                         child: Stack(
    //                           //  children:
    //                           children: [
    //                             Container(
    //                               height: 210,
    //                               width: 180,
    //                               decoration: BoxDecoration(
    //                                   gradient: LinearGradient(
    //                                       begin: Alignment.topCenter,
    //                                       end: Alignment.bottomCenter,
    //                                       colors: [
    //                                         Colors.transparent,Colors.black
    //                                       ]
    //                                   ),
    //                                   boxShadow: [
    //                                     BoxShadow(
    //                                       color: Colors.grey.withOpacity(0.5),
    //                                       spreadRadius: 5,
    //                                       blurRadius: 7,
    //                                       offset: Offset(0, 3),
    //                                     ),
    //                                   ],
    //                                   //color: Colors.white,
    //                                   borderRadius: BorderRadius.circular(15),
    //                                   image: DecorationImage(image: AssetImage("assets/food2.jpg"),fit: BoxFit.fill)),
    //                             ),
    //                             Positioned(
    //                               bottom: 1
    //                               ,child: Container(
    //                               height: 100,
    //                               width: 179,
    //                               decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(15),
    //                                   gradient: LinearGradient(begin: Alignment.topCenter,
    //                                       end: Alignment.bottomCenter,
    //                                       colors: [Colors.transparent,Colors.black])
    //                               ),
    //                               child: Center(
    //                                 child: Row(
    //                                   children: [
    //                                     Icon(Icons.currency_rupee,color: Colors.white,weight: 30,size: 25,),
    //                                     Text("100 Off",style: TextStyle(fontFamily: 'Outfit',fontSize: 20,fontWeight: FontWeight.w900,color: Colors.white),),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Divider(color: Colors.grey.shade300,),
    //               ],
    //             ),
    //           );
    //       }
    //   ),
    //
    //     ],
    //   ),)C

    // Container(
    //   height: double.infinity,
    //   child: CustomScrollView(controller: _scrollController, slivers: <Widget>[
    //     SliverAppBar(
    //       // show and hide SliverAppBar Title
    //       backgroundColor: Color(0xffe9eaef),
    //       title: _isSliverAppBarExpanded
    //           ? Padding(
    //         padding: EdgeInsets.only(left: 50),
    //         child: Text(
    //           widget.restaurantName,
    //           style: TextStyle(
    //               fontSize: 15,
    //               color: Colors.black,
    //               fontFamily: 'Outfit',
    //               fontWeight: FontWeight.w900),
    //         ),
    //       )
    //           : null,
    //       pinned: true,
    //       snap: true,
    //       floating: true,
    //       expandedHeight: kExpandedHeight,
    //
    //       // show and hide FlexibleSpaceBar title
    //       flexibleSpace: _isSliverAppBarExpanded
    //           ? null
    //           : FlexibleSpaceBar(
    //         centerTitle: true,
    //         title: Card(
    //           child: Container(
    //             height: 80,
    //             width: 300,
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               //border: Border.all(),
    //               borderRadius: BorderRadius.circular(15),
    //             ),
    //             child: Center(
    //               child: Text(
    //                  // Text("${snapshot.error}")
    //                 widget.restaurantName,
    //                 //filItem"item_name".toString(),
    //                 textScaleFactor: 1,
    //                 style: TextStyle(
    //                     color: Colors.black,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 15),
    //               ),
    //             ),
    //           ),
    //         ),
    //
    //         // background: Card(
    //         //   child: Center(
    //         //     child: Text('A2B-Adayar Anandhabhavan Hotel',
    //         //       textScaleFactor: 1,
    //         //       style: TextStyle(
    //         //           color: Colors.black,
    //         //           fontWeight: FontWeight.bold,
    //         //           fontSize: 20),),
    //         //   ),
    //         // ),
    //       ),
    //     ),
    //     SliverList(
    //       delegate:
    //       SliverChildBuilderDelegate(semanticIndexOffset: 1, childCount: 1, (
    //           _,
    //           int index,
    //           ) {
    //         return Column(
    //           children: [
    //             SizedBox(
    //               height: 30,
    //             ),
    //             Container(
    //               height: 40,
    //               width: 380,
    //               child: TextFormField(
    //                 controller: searchItem,
    //                 onChanged: (value) {
    //                   searchrestItem(value);
    //                 },
    //                 decoration: InputDecoration(
    //                   focusedBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(10),
    //                     borderSide: BorderSide(color: Colors.transparent),
    //                   ),
    //                   enabledBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(10),
    //                     borderSide: BorderSide(color: Colors.transparent),
    //                   ),
    //                   errorBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(10),
    //                     borderSide: BorderSide(color: Colors.transparent),
    //                   ),
    //
    //                   filled: true,
    //                   fillColor: Color(0xffe9eaef),
    //                   // prefixIcon: IconButton(
    //                   //     onPressed: (){
    //                   //       Get.back();
    //                   //     },
    //                   //     icon: Icon(Icons.arrow_back_ios,color: Colors.red,size: 18,)),
    //                   //
    //                   label: Center(child: Text("Search for dishes")),
    //                   labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
    //                   focusColor: Colors.grey,
    //                 ),
    //               ),
    //             ),
    //             FutureBuilder<List>(
    //                 future: _future,
    //                 builder:
    //                     (BuildContext context, AsyncSnapshot<List> snapshot) {
    //                   return ListView.builder(
    //                      shrinkWrap: true,
    //                       itemCount: filItem.length,
    //                       itemBuilder: (context, int index) {
    //                         return Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: Column(
    //                             children: [
    //                               Container(
    //                                 height: 200,
    //                                 width: 440,
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.white,
    //                                   //border: Border.all(color: Colors.black),
    //                                   //borderRadius: BorderRadius.circular(10),
    //                                 ),
    //                                 child: Row(
    //                                   children: [
    //                                     Padding(
    //                                       padding: EdgeInsets.only(left: 5),
    //                                       child: Container(
    //                                         height: 150,
    //                                         width: 241,
    //                                         child: Column(
    //                                           crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                           children: [
    //                                             // Text(
    //                                             //   filItem[index]["item_type"].toString(),
    //                                             //   style: TextStyle(
    //                                             //     fontFamily: 'Outfit',
    //                                             //     fontSize: 20,
    //                                             //     overflow:
    //                                             //     TextOverflow.ellipsis,
    //                                             //     //    fontWeight: FontWeight.bold
    //                                             //   ),
    //                                             // ),
    //                                             Text(
    //                                               filItem[index]["item_name"].toString(),
    //                                               style: TextStyle(
    //                                                 fontFamily: 'Outfit',
    //                                                 fontSize: 20,
    //                                                 overflow:
    //                                                 TextOverflow.ellipsis,
    //                                                 //    fontWeight: FontWeight.bold
    //                                               ),
    //                                             ),
    //                                             Row(
    //                                               children: [
    //                                                 Container(
    //                                                   height: 20,
    //                                                   width: 20,
    //                                                   decoration: BoxDecoration(
    //                                                       borderRadius:
    //                                                       BorderRadius
    //                                                           .circular(20),
    //                                                       color: Colors.green),
    //                                                   child: Icon(Icons.star,
    //                                                       color: Colors.white,
    //                                                       size: 12),
    //                                                 ),
    //                                                 Text(
    //                                                   "(4.4)",
    //                                                   style: TextStyle(
    //                                                       color: Colors.green,
    //                                                       fontWeight:
    //                                                       FontWeight.w900),
    //                                                 )
    //                                               ],
    //                                             ),
    //                                             Row(
    //                                               children: [
    //                                                 Icon(Icons.currency_rupee_outlined,size: 25,weight: 300,),
    //                                                 Text(
    //                                                   filItem[index]["item_price"].toString(),
    //                                                   style: TextStyle(
    //                                                     fontFamily: 'Outfit',
    //                                                     fontSize: 20,
    //                                                     overflow:
    //                                                     TextOverflow.ellipsis,
    //                                                     //    fontWeight: FontWeight.bold
    //                                                   ),
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                             Container(
    //                                               height: 30,
    //                                               width: 200,
    //                                               decoration: BoxDecoration(gradient: LinearGradient(
    //                                                   begin: Alignment.centerLeft,
    //                                                   colors: [
    //                                                     Color(0xffd6f0ef),Colors.white
    //                                                   ])),
    //                                               child: GestureDetector(
    //                                                 onTap: (){
    //                                                   Get.offAll(openAlertBox());
    //
    //                                                 },
    //                                                 child: Row(
    //                                                   children: [
    //                                                     Icon(Icons.forward,color: Color(0xff5d3cc8),),
    //                                                     SizedBox(width: 30,),
    //                                                     Text("Feedback",style: TextStyle(fontWeight:FontWeight.bold,color: Color(0xff5d3cc8)),),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                             )
    //                                             // Row(
    //                                             //   children: [
    //                                             //     Text("Distance:",
    //                                             //       style: TextStyle(
    //                                             //           backgroundColor: Colors
    //                                             //               .grey),),
    //                                             //     Text(
    //                                             //       "0.29",
    //                                             //       //filRestaurant[index]["distance"].toString(),
    //                                             //       style: TextStyle(
    //                                             //           fontSize: 20,
    //                                             //           color: Colors
    //                                             //               .black,
    //                                             //           fontWeight: FontWeight
    //                                             //               .bold),),
    //                                             //     SizedBox(width: 2,),
    //                                             //     RichText(text: TextSpan(
    //                                             //         text: "Km",
    //                                             //         style: TextStyle(
    //                                             //             fontSize: 16,
    //                                             //             color: Colors
    //                                             //                 .black54)
    //                                             //     ),),
    //                                             //   ],
    //                                             // ),
    //                                             // Container(
    //                                             //   height: 30,
    //                                             //   width: 200,
    //                                             //   decoration: BoxDecoration(gradient: LinearGradient(
    //                                             //       begin: Alignment.centerLeft,
    //                                             //       colors: [
    //                                             //         Color(0xffd6f0ef),Colors.white
    //                                             //       ])),
    //                                             //   child: GestureDetector(
    //                                             //     onTap: (){
    //                                             //       Get.offAll(openAlertBox());
    //                                             //
    //                                             //     },
    //                                             //     child: Row(
    //                                             //       children: [
    //                                             //         Icon(Icons.forward,color: Color(0xff5d3cc8),),
    //                                             //         SizedBox(width: 30,),
    //                                             //         Text("Feedback",style: TextStyle(fontWeight:FontWeight.bold,color: Color(0xff5d3cc8)),),
    //                                             //       ],
    //                                             //     ),
    //                                             //   ),
    //                                             // )
    //                                           ],
    //                                         ),
    //
    //                                         // child: ListTile(
    //                                         //    title: Text(filRestaurant[index]["restaurant_name"], style: TextStyle(
    //                                         //        fontSize: 16, color: Colors.green),),
    //                                         //    subtitle: Column(
    //                                         //      children: [
    //                                         //        Text(
    //                                         //          filRestaurant[index]["restaurant_address"],
    //                                         //          style: TextStyle(
    //                                         //              fontSize: 14, color: Colors.black54),),
    //                                         //       Row(
    //                                         //         children: [
    //                                         //           RichText(text: TextSpan(
    //                                         //             text: "DISTANCE :",style: TextStyle(fontSize: 16, color: Colors.green)
    //                                         //           ),),
    //                                         //           SizedBox(width: 6,),
    //                                         //           Text(
    //                                         //             filRestaurant[index]["distance"].toString(),
    //                                         //             style: TextStyle(
    //                                         //                 fontSize: 16, color: Colors.black54),),
    //                                         //           SizedBox(width: 6,),
    //                                         //           RichText(text: TextSpan(
    //                                         //               text: "Km",style: TextStyle(fontSize: 16, color: Colors.black54)
    //                                         //           ),),
    //                                         //         ],
    //                                         //       )
    //                                         //
    //                                         //      ],
    //                                         //    ),
    //                                         //    trailing: Icon(Icons.arrow_forward),
    //                                         //  ),
    //                                       ),
    //                                     ),
    //                                     Card(
    //                                       child: Stack(
    //                                         //  children:
    //                                         children: [
    //                                           Container(
    //                                             height: 150,
    //                                             width: 180,
    //                                             decoration: BoxDecoration(
    //                                                 gradient: LinearGradient(
    //                                                     begin:
    //                                                     Alignment.topCenter,
    //                                                     end: Alignment
    //                                                         .bottomCenter,
    //                                                     colors: [
    //                                                       Colors.transparent,
    //                                                       Colors.black
    //                                                     ]),
    //                                                 boxShadow: [
    //                                                   BoxShadow(
    //                                                     color: Colors.grey
    //                                                         .withOpacity(0.5),
    //                                                     spreadRadius: 5,
    //                                                     blurRadius: 7,
    //                                                     offset: Offset(0, 3),
    //                                                   ),
    //                                                 ],
    //                                                 //color: Colors.white,
    //                                                 borderRadius:
    //                                                 BorderRadius.circular(15),
    //                                                 image: DecorationImage(
    //                                                     image: NetworkImage(
    //                                                         //"assets/friedrice.jpg"
    //                                                        Services.BaseUrls + filItem[index]["item_photo"]
    //                                                     ),
    //                                                     fit: BoxFit.fill)),
    //                                           ),
    //                                           // Positioned(
    //                                           //   bottom: 1
    //                                           //   , child: Container(
    //                                           //   height: 100,
    //                                           //   width: 179,
    //                                           //   decoration: BoxDecoration(
    //                                           //       borderRadius: BorderRadius
    //                                           //           .circular(15),
    //                                           //       gradient: LinearGradient(
    //                                           //           begin: Alignment
    //                                           //               .topCenter,
    //                                           //           end: Alignment
    //                                           //               .bottomCenter,
    //                                           //           colors: [
    //                                           //             Colors
    //                                           //                 .transparent,
    //                                           //             Colors.black
    //                                           //           ])
    //                                           //   ),
    //                                           //   child: Center(
    //                                           //     child: Row(
    //                                           //       children: [
    //                                           //         Icon(Icons
    //                                           //             .currency_rupee,
    //                                           //           color: Colors.white,
    //                                           //           weight: 30,
    //                                           //           size: 25,),
    //                                           //         Text("100 Off",
    //                                           //           style: TextStyle(
    //                                           //               fontFamily: 'Outfit',
    //                                           //               fontSize: 20,
    //                                           //               fontWeight: FontWeight
    //                                           //                   .w900,
    //                                           //               color: Colors
    //                                           //                   .white),),
    //                                           //       ],
    //                                           //     ),
    //                                           //   ),
    //                                           // ),
    //                                           // )
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Divider(
    //                                 color: Colors.grey.shade300,
    //                               ),
    //                             ],
    //                           ),
    //                         );
    //                       });
    //                 })
    //           ],
    //         );
    //         //         },
    //         //         childCount: 20,
    //         //       ),
    //         //     ),
    //         //   ],
    //         //
    //         // ),
    //       }),
    //     )
    //   ]),
    // ));
  }

  openAlertBox(int itemId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: FivePointedStar(
                      size: Size(40, 40),
                      color: Colors.grey,
                      selectedColor: Colors.yellow,
                      onChange: (count) {
                        setState(() {
                          mycount = count;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      controller: review,
                      decoration: InputDecoration(

                        hintText: "Add Review",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      EasyLoading.show(status: "Loading...");
                      if(await Services.insertReview(
                          widget.restaurantId,
                          itemId,
                          0,
                          review.text,
                          double.parse(mycount.toString()),
                          "")) {

                        EasyLoading.showSuccess("Review added successfully");
                        Get.back();
                        _refresh();
                      }
                      else {
                        EasyLoading.showError("Failed");
                      }
                    },


                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "Rate Product",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
