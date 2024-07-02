import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/src/features/shop/profile/profile_controller.dart';
import 'package:tiktok_clone/src/features/shop/profile/video_player_profile.dart';
import 'package:tiktok_clone/src/features/shop/settings/settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class profileScreen extends StatefulWidget {
  final String? visitedId;

  const profileScreen({super.key, required this.visitedId});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  ProfileController controllerProfile = Get.put(ProfileController());
  bool isFollowingUser = false;

  @override
  void initState() {
    super.initState();

    /// passing the user id once the page is called
    controllerProfile.updateCurrentUserId(widget.visitedId.toString());
    getIsFollowingValue();
  }

  getIsFollowingValue() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.visitedId)
        .collection("followers")
        .doc(currentUserId).get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isFollowingUser = true;
        });
      } else {
        setState(() {
          isFollowingUser = false;
        });
      }
    });
  }

  /// for social media linkings
  Future<void> launchUserSocialProfile(String socialLink) async {
    if (!await launchUrl(Uri.parse("https://$socialLink"))) {
      throw Exception("Could not launch $socialLink");
    }
  }

  /// App bar logout and settings Function
  handleClickEvent(String choiceClicked) {
    switch (choiceClicked) {
      case "Settings":
        Get.to(const settingsScreen());
        break;

      case "Logout":
        FirebaseAuth.instance.signOut();
        Get.snackbar("Logged Out", "You have successfully logged out",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
        break;
    }
  }


  //// basically this just gets all the video info once it matches the videoID(that can make you  get the whole document), its easy to understand, video 94
  readClickedThumbnailInfo(String clickedThumbnailUrl) async {

    var allvideosDocs = await FirebaseFirestore.instance
        .collection("videos")
        .get();

    for(int i=0; i<allvideosDocs.docs.length; i++){
      if(((allvideosDocs.docs[i].data() as dynamic)["thumbnailUrl"]) == clickedThumbnailUrl){
        Get.to(() => videoPlayerProfile(clickedVideoID: (allvideosDocs.docs[i].data() as dynamic)["videoID"]));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controllerProfile) {
        if (controllerProfile.userMap.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return Scaffold(
            backgroundColor: Colors.black,

            /// AppBar
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              leading: widget.visitedId == currentUserId
                  ? const SizedBox()
                  : IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: Get.back,
                    ),
              title: Text(
                controllerProfile.userMap["userName"],
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                widget.visitedId == currentUserId
                    ? PopupMenuButton<String>(
                        onSelected: handleClickEvent,
                        itemBuilder: (BuildContext context) {
                          return {"Settings", "Logout"}
                              .map((String choiceClicked) {
                            return PopupMenuItem(
                              value: choiceClicked,
                              child: Text(choiceClicked),
                            );
                          }).toList();
                        },
                      )
                    : const SizedBox()
              ],
            ),

            /// Body
            body: SingleChildScrollView(
              child: Column(
                children: [
                  /// profile image
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          NetworkImage(controllerProfile.userMap["userImage"]),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  /// username
                  Center(
                    child: Text(
                      "@${controllerProfile.userMap["userName"]}",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  /// Following - Followers - Likes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap["totalFollowings"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            const Text(
                              "Following",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.yellow,
                        width: 1,
                        height: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap["totalFollowers"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            const Text(
                              "Followers",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.yellow,
                        width: 1,
                        height: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap["totalLikes"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            const Text(
                              "Likes",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  /// Social Links - facebook - youtube - instagram - twitter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap["userFacebook"] == "") {
                            Get.snackbar("Facebook",
                                "Facebook not yet linked! proceed to settings.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white);
                          } else {
                            launchUserSocialProfile(
                                controllerProfile.userMap["userFacebook"]);
                          }
                        },
                        child: Image.asset("assets/facebook.png"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap["userInstagram"] ==
                              "") {
                            Get.snackbar("Instagram",
                                "Instagram not yet linked! proceed to settings.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white);
                          } else {
                            launchUserSocialProfile(
                                controllerProfile.userMap["userInstagram"]);
                          }
                        },
                        child: Image.asset("assets/instagram.png"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap["userYoutube"] == "") {
                            Get.snackbar("Youtube",
                                "Youtube not yet linked! proceed to settings.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white);
                          } else {
                            launchUserSocialProfile(
                                controllerProfile.userMap["userYoutube"]);
                          }
                        },
                        child: Image.asset("assets/youtube.png"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap["userTwitter"] == "") {
                            Get.snackbar("Twitter",
                                "Twitter not yet linked! proceed to settings.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white);
                          } else {
                            launchUserSocialProfile(
                                controllerProfile.userMap["userTwitter"]);
                          }
                        },
                        child: Image.asset("assets/twitter2.png"),
                      ),
                    ],
                  ),

                  /// Follow - Unfollow - Sign Out

                  ElevatedButton(
                    onPressed: () {
                      // if user views his/her own profile:
                      // signOut button
                      if (widget.visitedId.toString() == currentUserId) {
                        FirebaseAuth.instance.signOut();
                        Get.snackbar(
                            "Successfull", 'You have successfully Signed Out');
                      }

                      // user views someone elses profile
                      // follow - unfollow button
                      else {
                        // if already current user is following the other user
                        // unfollow btn
                        if (isFollowingUser == true) {
                          setState(() {
                            isFollowingUser == false;
                          });
                        }
                        // if not-already current user is following the other user
                        // follow btn
                        else {
                          setState(() {
                            isFollowingUser == true;
                          });
                        }
                        controllerProfile.followUnfollowUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        shape: widget.visitedId.toString() == currentUserId
                            ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: const BorderSide(color: Colors.yellow),
                              )
                            : isFollowingUser == true
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: const BorderSide(color: Colors.green),
                                  )
                                : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: const BorderSide(color: Colors.pink),
                                  )),
                    child: Text(
                      widget.visitedId.toString() == currentUserId
                          ? "Sign Out"
                          : isFollowingUser == true
                              ? "Unfollow"
                              : "follow",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controllerProfile.userMap["thumbnailList"].length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index){
                      String eachThumbnail = controllerProfile.userMap["thumbnailList"][index];
                      return GestureDetector(
                        onTap: () {
                          readClickedThumbnailInfo(eachThumbnail);
                        },
                        child: Image.network(
                          eachThumbnail,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                ],
              ),
            ));
      },
    );
  }
}
