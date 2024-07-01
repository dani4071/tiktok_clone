import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/src/authentication/user.dart';
import 'package:tiktok_clone/src/features/shop/profile/profile_screen.dart';
import 'package:tiktok_clone/src/features/shop/search_screen/search_controller.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  searchController controllerSearch = Get.put(searchController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          titleSpacing: 6,
          backgroundColor: Colors.black,
          title: TextFormField(
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.white70, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.white70, width: 2.0),
                ),
                hintText: "Search here boss...",
                hintStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
            onFieldSubmitted: (textInput) {
              controllerSearch.searchForUser(textInput);
            },
          ),
        ),
        body: controllerSearch.userSearchedList.isEmpty
            ? Center(
                child: Image.asset(
                  "assets/search.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              )
            : ListView.builder(
                itemCount: controllerSearch.userSearchedList.length,
                itemBuilder: (context, index) {
                  UserModel eachSearchedUserRecord =
                      controllerSearch.userSearchedList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
                    child: Card(
                      color: Colors.black54,
                      child: InkWell(
                        onTap: (){
                          Get.to(() => profileScreen(visitedId: eachSearchedUserRecord.uid.toString(),));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(eachSearchedUserRecord.image.toString()),
                          ),
                          title: Text(
                            eachSearchedUserRecord.name.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          subtitle: Text(
                            eachSearchedUserRecord.email.toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {

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
      ),
    );
  }
}
