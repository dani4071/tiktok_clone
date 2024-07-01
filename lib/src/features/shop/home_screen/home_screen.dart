// import 'package:flutter/material.dart';
// import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   bool isClicked = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: isClicked ? GestureDetector(
//           onTap: () {
//           },
//           child: Container(
//             child: ElevatedButton(
//               child: Text('Login'),
//               onPressed: () {
//                 setState(() {
//                   isClicked = false;
//                 });
//               },
//             ),
//           ),
//         ) : Container(
//           child: const SimpleCircularProgressBar(
//             progressColors: [
//               Colors.green,
//               Colors.pink,
//               Colors.yellow,
//               Colors.pink,
//               Colors.purple,
//             ],
//             animationDuration: 3,
//             backColor: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/src/features/shop/following/following_video_screen.dart';
import 'package:tiktok_clone/src/features/shop/for_you/for_you_screen.dart';
import 'package:tiktok_clone/src/features/shop/profile/profile_screen.dart';
import 'package:tiktok_clone/src/features/shop/search_screen/searchScreen.dart';
import 'package:tiktok_clone/src/features/shop/upload_video/upload_video_screen.dart';

import '../upload_video/upload_custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int screenIndex = 0;
  List screenList = [const forYouScreen(), const searchScreen(), const uploadVideoScreen(), const followingsVideoScreen(), profileScreen(visitedId: currentUserId,)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white12,
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Discover"
          ),
          BottomNavigationBarItem(
              icon: UploadCustomIcon(),
              label: "Upload"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.indeterminate_check_box),
              label: "Following"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Me"
          ),
        ],

      ),
      body: screenList[screenIndex],
    );
  }
}
