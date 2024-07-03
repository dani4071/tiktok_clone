import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/src/features/shop/profile/profile_controller.dart';

import '../profile_screen.dart';

class followingScreen extends StatefulWidget {
  String visitedProfileUserID;

  followingScreen({super.key, required this.visitedProfileUserID});

  @override
  State<followingScreen> createState() => _followingScreenState();
}

class _followingScreenState extends State<followingScreen> {
  List<String> followingKeysList = [];
  List followingUsersDataList = [];
  ProfileController controller = Get.put(ProfileController());

  getFollowingListKeys() async {
    var followingDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.visitedProfileUserID)
        .collection("following")
        .get();

    for (int i = 0; i < followingDocument.docs.length; i++) {
      followingKeysList.add(followingDocument.docs[i].id);
    }
    getFollowingKeysDataFromUserCollection(followingKeysList);
  }

  getFollowingKeysDataFromUserCollection(
      List<String> listOfFollowingKeys) async {
    var allUserDocument =
        await FirebaseFirestore.instance.collection("users").get();

    for (int i = 0; i < allUserDocument.docs.length; i++) {
      for (int j = 0; j < listOfFollowingKeys.length; j++) {
        if (((allUserDocument.docs[i].data() as dynamic)["uid"]) ==
            listOfFollowingKeys[j]) {
          followingUsersDataList.add((allUserDocument.docs[i].data()));
        }
      }
    }

    setState(() {
      followingUsersDataList;
    });
  }

  @override
  void initState() {
    getFollowingListKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Text(
              controller.userMap['userName'],
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "Following ${controller.userMap["totalFollowings"]}",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: followingUsersDataList.isEmpty
          ? const Center(
              child: Icon(
              Icons.person_off,
              color: Colors.white,
              size: 60,
            ))
          : ListView.builder(
              itemCount: followingUsersDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
                  child: Card(
                    color: Colors.black54,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => profileScreen(
                              visitedId: followingUsersDataList[index]["uid"],
                            ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              followingUsersDataList[index]["image"]
                                  .toString()),
                        ),
                        title: Text(
                          followingUsersDataList[index]["name"].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        subtitle: Text(
                          followingUsersDataList[index]["email"].toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Get.to(() => profileScreen(
                                  visitedId: followingUsersDataList[index]
                                      ["uid"],
                                ));
                          },
                          icon: const Icon(
                            Icons.navigate_next_outlined,
                            size: 24,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
