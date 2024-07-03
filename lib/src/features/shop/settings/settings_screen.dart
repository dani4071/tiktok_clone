import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/src/common/input_text_widget.dart';
import 'package:tiktok_clone/src/features/shop/profile/profile_controller.dart';


class settingsScreen extends StatefulWidget {
  const settingsScreen({super.key});

  @override
  State<settingsScreen> createState() => _settingsScreenState();
}

class _settingsScreenState extends State<settingsScreen> {

  ProfileController profileController = Get.put(ProfileController());
  String facebook = "";
  String youtube = "";
  String instagram = "";
  String twitter = "";
  String userImageUrl = "";

  TextEditingController facebookTextEditingController = TextEditingController();
  TextEditingController youtubeTextEditingController = TextEditingController();
  TextEditingController instagramTextEditingController = TextEditingController();
  TextEditingController twitterTextEditingController = TextEditingController();

  getCurrentUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .get();

    facebook = snapshot["facebook"];
    youtube = snapshot["youtube"];
    instagram = snapshot["instagram"];
    twitter = snapshot["twitter"];
    userImageUrl = snapshot["image"];


    setState(() {
      facebookTextEditingController.text = facebook ?? "";
      youtubeTextEditingController.text = youtube ?? "";
      instagramTextEditingController.text = instagram ?? "";
      twitterTextEditingController.text = twitter ?? "";
    });
  }


  @override
  void initState() {
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (profileController){
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  /// profile image
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                      NetworkImage(profileController.userMap["userImage"]),
                    ),
                  ),

                  const SizedBox(height: 30,),

                  const Text(
                    "Update your profile social links",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.pink
                    ),
                  ),

                  const SizedBox(height: 10,),

                  /// facebook
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController: facebookTextEditingController,
                      labelString: "Facebook.com/username",
                      assetReference: "assets/facebook.png",
                      isObscure: false,
                    ),
                  ),

                  const SizedBox(height: 10,),

                  /// youtube
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController: youtubeTextEditingController,
                      labelString: "youtube.com/profile",
                      assetReference: "assets/youtube.png",
                      isObscure: false,
                    ),
                  ),

                  const SizedBox(height: 10,),

                  /// instagram
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController: instagramTextEditingController,
                      labelString: "instagram.com/username",
                      assetReference: "assets/instagram.png",
                      isObscure: false,
                    ),
                  ),

                  const SizedBox(height: 10,),

                  /// twitter
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController: twitterTextEditingController,
                      labelString: "twitter.com/username",
                      assetReference: "assets/twitter2.png",
                      isObscure: false,
                    ),
                  ),

                  const SizedBox(height: 10,),

                  ElevatedButton(
                    onPressed: (){
                      profileController.updateUserSocialAccountLinks(
                          facebookTextEditingController.text,
                          youtubeTextEditingController.text,
                          twitterTextEditingController.text,
                          instagramTextEditingController.text,
                      );
                    },
                    child: const Text(
                      "Update"
                    ),
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
