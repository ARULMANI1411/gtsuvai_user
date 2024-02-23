import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class Services {

  // static String baseURL = "http://92.205.109.210:8005/";
  // static String BaseUrls = "http://92.205.109.210:8005/";

  // sic String BaseUrls = "http://208.109.34.247:8097/";
  ///Live
  //       static String baseURL = "http://gtsatest.gtgym.in/";

  ///Test
  static String baseURL = "http://208.109.34.247:8097/";
  // static String baseURL = "http://92.205.109.210:8098/";
  static String BaseUrls="http://208.109.34.247:8097/";

  static Map<String, String> header = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  };

  Services._();

  static get dev => null;


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


  ///saveitemreview
  static Future<bool> insertReview(int restid, itemid, reviewid,
      String itemreview,double itemrating,String reviewphoto

      ) async {
    var data = await httpPost("${baseURL}saveitemreview",
        jsonEncode({
          "restaurantId": restid,
          "itemId":itemid,
          "item_reviewId": reviewid,
          "item_review": itemreview,
          "item_rating": itemrating,
          "reviewer_item_photo":reviewphoto,

        })
    );
    print("${baseURL}saveitemreview" +
        jsonEncode({
          "restaurantId": restid,
          "itemId":itemid,
          "item_reviewId": reviewid,
          "item_review": itemreview,
          "item_rating": itemrating,
          "reviewer_item_photo":reviewphoto,

        }));
    print(data);

    if(data == "ItemReview Saved Successfully...") {
      return true;
    }
    else {
      return false;
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




}
///Post
class Post {
  late String url, inoutObj;
  late List<String> files;

  Post(this.url, this.inoutObj, this.files);

  @override
  String toString() =>
      "URL : $url\nPayload : $inoutObj\nFiles: $files";
}