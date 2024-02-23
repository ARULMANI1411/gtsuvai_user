import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mainServices.dart';
import 'dart:developer' as dev;

class DropdownServices {
  static String baseURL = Services.baseURL;

  static Map<String, String> header = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  };

  DropdownServices._();

  static httpPost(String url, dynamic body) async {
    var res;
    if (body != null) {
      res = await Future.any([
        http.post(Uri.parse(url), headers: header, body: body),
        Future.delayed(const Duration(seconds: 5))
      ]);
    } else {
      res = await Future.any([
        http.post(Uri.parse(url), headers: header),
        Future.delayed(const Duration(seconds: 5))
      ]);
    }
    if (res == null) {
      return "{}";
    } else if (res.statusCode == 200) {
      return res.body;
    }
  }

  static httpGet(String url) async {
    var res = await Future.any([
      http.get(Uri.parse(url), headers: header),
      Future.delayed(const Duration(seconds: 5))
    ]);
    if (res == null) {
      return "{}";
    }
    if (res.statusCode == 200) {
      return res.body;
    }
  }

  ///Get All States
  static Future<List> getAllCity() async {
    List list = [];
    var data = await httpGet("${baseURL}getcity");
    data = jsonDecode(data);
    if (data["success"] == true && data["districtList"] is List) {
      list = (data["districtList"] as List);
    }
    return list;
  }

  /// getmusttry details
  static Future<List> getMustTry() async {
      List list = [];
      var data = await httpGet("${baseURL}Master/GetMustTryDishesDtls");
      data = jsonDecode(data);
      if (data["success"] == true && data["mustTryDishesDtls"] is List) {
        list = (data["mustTryDishesDtls"] as List);
      }
      print(list.toString() + "musttry");
      return list;
    }


  static Future<List> getOffers() async {
    List list = [];
    var data = await httpGet("${baseURL}User/GetOfferForUserApp?Lat=11.031323834579881&Long=76.95693531757718");
    data = jsonDecode(data);
    if (data["success"] == true && data["offerDtls"] is List) {
      list = (data["offerDtls"] as List);
    }
    return list;
  }


  ///Get All Sub Districts
  // static Future<List> getItem() async {
  //   List list = [];
  //   var data = await httpGet("${baseURL}getrestaurant");
  //   data = jsonDecode(data);
  //   for (var restaurantData in data) {
  //     List itemDetails = restaurantData["item_details"];
  //     list.addAll(itemDetails);
  //     print(list.length.toString() + " 1");
  //     list = list.toSet().toList();
  //     print(list.length.toString() + " 2");
  //   }
  //   print(list);
  //   return list;
  // }

  static Future<List> getItem() async {
    List list = [];
    var data = await httpGet("${baseURL}getrestaurant");
    data = jsonDecode(data);
    Map<String, dynamic> uniqueItemsMap = {};

    for (var restaurantData in data) {
      List itemDetails = restaurantData["item_details"];
      for (var item in itemDetails) {
        String itemName = item["item_name"];
        if (!uniqueItemsMap.containsKey(itemName)) {
          uniqueItemsMap[itemName] = item;
        }
      }
    }
    list = uniqueItemsMap.values.toList();
    return list;
  }

// ///get restaurant
//   static Future<List> getRestaurant(double lat, long) async {
//     print("gfhgf");
//     List list = [];
//     var data = await httpPost("${baseURL}getuserrestaurant",
//       jsonEncode({
//         "item_name": "",
//         "lat": lat,
//         "long": long
//       })
//     );
//     print("${baseURL}getallrestaurants" +
//         jsonEncode({
//           "item_name": "",
//           "lat": lat,
//           "long": long
//         }));
//     data = jsonDecode(data);
//     print(data);
//     list = data as List;
//     return list;
//   }
  static Future<List> getuserreview(int restaurantId,int itemId) async {
    List list = [];
    var data = await httpPost("${baseURL}getallitemreview",
        jsonEncode({
          "restaurantId": restaurantId,
          "itemId":itemId

        })
    );
    print("${baseURL}getallitemreview"+
        jsonEncode({
          "restaurantId": restaurantId,
          "itemId":itemId

        }));
    // print("${baseURL}getuserrestaurantdist" +
    //     jsonEncode({
    //       "item_name": item_name,
    //       "lat": lat,
    //       "long": long
    //     }));
    data = jsonDecode(data);
    print(data);
    list = data as List;
    print(list);
    return list;
  }

  ///get nearby restaurant
  static Future<List> getNearbyRestaurant(String lat, String long) async {
    dev.log("fgf");
    List list = [];
    var data = await httpPost("${baseURL}getuserrestaurantdist",
        jsonEncode({
          "item_name": "",
          "lat": lat,
          "long": long
        })
    );
    print("${baseURL}getuserrestaurantdist" +
        jsonEncode({
          "item_name": "",
          "lat": lat,
          "long": long
        }));
    data = jsonDecode(data);
    list = data as List;
    print(list);
    return list;
  }

  static Future<List> getRestaurant(String item_name, double lat,double long) async {
    List list = [];
    var data = await httpPost("${baseURL}getuserrestaurantdist",
        jsonEncode({
          "item_name": item_name,
          "lat": lat,
          "long": long
        })
    );
    print("${baseURL}getuserrestaurantdist" +
        jsonEncode({
          "item_name": item_name,
          "lat": lat,
          "long": long
        }));
    data = jsonDecode(data);
    print(data);
    list = data as List;
    print(list);
    return list;
  }

  ///get restaurantItem
  static Future<List> getRestaurantItem(int restaurantId) async {
    List list = [];
    try {
      var data = await httpPost("${baseURL}getuseritems",
          jsonEncode({
            "item_name": "",
            "restaurantId": restaurantId
          })
      );
      List responseList = jsonDecode(data);

      for (var item in responseList) {
        if (item.containsKey("item_details")) {
          if (item["item_details"] is List) {
            list.addAll((item["item_details"]));
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    print(list);
    return list;
  }

  ///get low to high
  static Future<List> getlowtohigh(String item_name, double lat,double long,String sortOrder) async {
    List list = [];
    var data = await httpPost("${baseURL}getuserrestaurantprice",
        jsonEncode({
          "item_name": item_name,
          "lat": lat,
          "long": long,
          "sortOrder":"lowtohigh"
        })
    );
    print("${baseURL}getuserrestaurantprice" +
        jsonEncode({
          "item_name": item_name,
          "lat": lat,
          "long": long,
          "sortOrder":"lowtohigh"
        }));
    data = jsonDecode(data);
    // print(data);
    list = data as List;
    print(list);
    return list;
  }

  ///get ratingwise
  static Future<List> getrating(String item_name, double lat,double long) async {
    List list = [];
    var data = await httpPost("${baseURL}getuserrestaurantrating",
        jsonEncode({
          "item_name": item_name,
          "lat": lat,
          "long": long,
        })
    );
    print("${baseURL}getuserrestaurantrating" +
        jsonEncode({
          "item_name": item_name,
          "lat": lat,
          "long": long,
          // "sortOrder":"lowtohigh"
        }));
    data = jsonDecode(data);
    print(data);
    list = data as List;
    print(list);
    return list;
  }

  static Future<List> viewItemDtls(String key, lat, long) async {
    print("asdf");
    List list = [];
    print("${baseURL}User/GetItem_ResDtlsByUser?Key=$key&Lat=$lat&Long=$long");
    var data = await httpGet("${baseURL}User/GetItem_ResDtlsByUser?Key=$key&Lat=$lat&Long=$long");
    print("${baseURL}User/GetItem_ResDtlsByUser?Key=$key&Lat=$lat&Long=$long");
    data = jsonDecode(data);
    print(data);
    if(data["success"] == true && data["restaurantDtls"] is List) {
      list = data["restaurantDtls"] as List;
    }
    print(list);
    return list;
  }

}

class Restaurant {
  late int restaurantId;
  late String restaurant_name, restaurant_address, restaurant_type, pincode, restaurant_photo;
  late double distance;
  Restaurant(this.restaurantId, this.restaurant_name, this.restaurant_address, this.restaurant_type,
      this.pincode, this.restaurant_photo);

  Restaurant.fromMap(Map<String, dynamic> d) {
    restaurantId = int.tryParse(d["restaurantId"].toString()) ?? 0;
    restaurant_name = d["restaurant_name"].toString();
    restaurant_address = d["restaurant_address"].toString();
    restaurant_type = d["restaurant_type"].toString();
    pincode = d["pincode"].toString();
    restaurant_photo = d["restaurant_photo"].toString();
    distance = double.parse(d["distance"].toString());
  }
}
