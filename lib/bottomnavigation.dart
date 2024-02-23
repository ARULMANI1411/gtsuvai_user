// import 'package:flutter/material.dart';
// import 'package:foodie_user_app/viewRestaurant.dart';
//
// import 'must try.dart';
// import 'offers.dart';
// //import 'package:gtsuvai_user/viewRestaurant.dart';
// class bottomnavigation extends StatefulWidget {
//   const bottomnavigation({super.key});
//
//   @override
//   State<bottomnavigation> createState() => _bottomnavigationState();
// }
//
// class _bottomnavigationState extends State<bottomnavigation> {
//   int _currentIndex = 0;
//   final List<Widget> _children = [
//     viewRestaurant(),
//     mustTry(),
//     OffersPage(),
//   ];
//
//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _children[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: onTabTapped,
//         currentIndex: _currentIndex,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.recommend_sharp),
//             label: 'Must Try',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_offer),
//             label: 'Offers',
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.chat),
//           //   label: 'Chats',
//           // ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:foodie_user_app/viewRestaurant.dart';

import 'must try.dart';
import 'offers.dart';
class bottomnavigation extends StatefulWidget {
  const bottomnavigation({super.key});

  @override
  State<bottomnavigation> createState() => _bottomnavigationState();
}

class _bottomnavigationState extends State<bottomnavigation> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    viewRestaurant(),
    OffersPage(),
    mustTry(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            label: 'Must try',
          ),
        ],
      ),
    );
  }
}


