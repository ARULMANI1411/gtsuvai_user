import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:five_pointed_star/five_pointed_star.dart';
class feedback extends StatefulWidget {
  const feedback({super.key});

  @override
  State<feedback> createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  int mycount = 0;
  //double rating=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 100),
          //   child:
          //   // Container(
          //   //   height: 100,
          //   //   width: 300,
          //   //   child: FivePointedStar(
          //   //     size: Size(40, 40),
          //   //     color: Colors.grey,
          //   //     selectedColor: Colors.yellow,
          //   //     onChange: (count) {
          //   //       setState(() {
          //   //         mycount = count;
          //   //       });
          //   //     },
          //   //   ),
          //   // ),
          // ),
          //Text(mycount.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 100,),
          Container(
              height: 200,
              width: 300,
              child: Expanded(child: TextField())),
          ElevatedButton(onPressed: (){
            openAlertBox();
          }, child: Text("ok")),
          Text(mycount.toString(),style: TextStyle(fontWeight: FontWeight.bold),),

        ],

      ),
    );
  }
  openAlertBox() {
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
                  Row(
                    children: [
                      Text("Rate"),
                      FivePointedStar(
                        size: Size(40, 40),
                        color: Colors.grey,
                        selectedColor: Colors.yellow,
                        onChange: (count) {
                          setState(() {
                            mycount = count;
                          });
                        },
                      ),
                    ],
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
                      decoration: InputDecoration(
                        hintText: "Add Review",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
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
