import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';

class Util {
  static width() => MediaQuery.of(Get.context!).size.width;

  static height() => MediaQuery.of(Get.context!).size.height;

  static toast(String m) => ScaffoldMessenger.of(Get.context!)
      .showSnackBar(SnackBar(content: Text(m)));
  static toastError(String m) => ScaffoldMessenger.of(Get.context!)
      .showSnackBar(SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          m,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
    duration: const Duration(seconds: 2),
  ))
      .toString();
  static toastSuccess(String m) => ScaffoldMessenger.of(Get.context!)
      .showSnackBar(SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          m,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
    duration: const Duration(seconds: 2),
  ))
      .toString();
  static statusBarHeight() => MediaQuery.of(Get.context!).padding.top;

  static Future<String> getFilePath(String path) async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory?.path != null) return "${directory?.path}/$path";
    return "";
  }

  static Widget checkInternetManagerWidget(Widget child, Function onRefresh) {
    return FutureBuilder(
      future: InternetConnectionChecker().hasConnection,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data == true) {
          return child;
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200, shape: BoxShape.circle),
                      child:  Icon(
                        Icons.signal_wifi_off_outlined,
                        size: 80,
                      )),
                  const SizedBox(height: 20),
                  Text("No Network !",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text("Turn on Wi-Fi or mobile data",
                      style:
                      TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("Try Again",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () => onRefresh())
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
