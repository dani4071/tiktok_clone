import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../profile_controller.dart';
import '../profile_screen.dart';



class followersScreen extends StatefulWidget {
  String visitedProfileUserID;
  followersScreen({super.key, required this.visitedProfileUserID});

  @override
  State<followersScreen> createState() => _followersScreenState();
}

class _followersScreenState extends State<followersScreen> {
  List<String> followersKeysList = [];
  List followersUsersDataList = [];
  ProfileController controller = Get.put(ProfileController());

  getFollowersListKeys() async {
    var followersDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.visitedProfileUserID)
        .collection("followers")
        .get();

    for (int i = 0; i < followersDocument.docs.length; i++) {
      followersKeysList.add(followersDocument.docs[i].id);
    }
    getFollowersKeysDataFromUserCollection(followersKeysList);
  }

  getFollowersKeysDataFromUserCollection(
      List<String> listOfFollowersKeys) async {
    var allUserDocument =
    await FirebaseFirestore.instance.collection("users").get();

    for (int i = 0; i < allUserDocument.docs.length; i++) {
      for (int j = 0; j < listOfFollowersKeys.length; j++) {
        if (((allUserDocument.docs[i].data() as dynamic)["uid"]) ==
            listOfFollowersKeys[j]) {
          followersUsersDataList.add((allUserDocument.docs[i].data()));
        }
      }
    }

    setState(() {
      followersUsersDataList;
    });
  }


  @override
  void initState() {
    getFollowersListKeys();
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
              "Followers ${controller.userMap["totalFollowers"]}",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: followersUsersDataList.isEmpty
          ? const Center(
          child: Icon(
            Icons.person_off,
            color: Colors.white,
            size: 60,
          ))
          : ListView.builder(
        itemCount: followersUsersDataList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
            child: Card(
              color: Colors.black54,
              child: InkWell(
                onTap: () {
                  Get.to(() => profileScreen(
                    visitedId: followersUsersDataList[index]["uid"],
                  ));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        followersUsersDataList[index]["image"]
                            .toString()),
                  ),
                  title: Text(
                    followersUsersDataList[index]["name"].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  subtitle: Text(
                    followersUsersDataList[index]["email"].toString(),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() => profileScreen(
                        visitedId: followersUsersDataList[index]
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
