import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/src/common/circular_image_animation.dart';
import 'package:tiktok_clone/src/common/custom_video_player.dart';
import 'package:tiktok_clone/src/features/shop/comments/comment_screen.dart';
import 'package:tiktok_clone/src/features/shop/profile/video_controller_profile.dart';

class videoPlayerProfile extends StatefulWidget {

  String clickedVideoID;

  videoPlayerProfile({super.key, required this.clickedVideoID});

  @override
  State<videoPlayerProfile> createState() => _videoPlayerProfileState();
}

class _videoPlayerProfileState extends State<videoPlayerProfile> {

  final VideoControllerProfile controllerVideoProfile = Get.put(VideoControllerProfile());

  @override
  Widget build(BuildContext context) {

    controllerVideoProfile.setVideoId(widget.clickedVideoID.toString());

    return Scaffold(
        backgroundColor: Colors.green,
        body: Obx(() {
          return PageView.builder(
            itemCount: controllerVideoProfile.clickedVideoFile.length,
            controller: PageController(viewportFraction: 1, initialPage: 0),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {

              final eachVideoInfo = controllerVideoProfile.clickedVideoFile[index];

              return Stack(
                children: [
                  customVideoPlayer(
                    videoFilePath: eachVideoInfo.videoUrl.toString(),
                  ),

                  /// Left panels for usernames and hashTags
                  Column(
                    children: [

                      const SizedBox(
                        height: 100,
                      ),

                      /// left right - panels
                      Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              /// left panel
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // username
                                      Text(
                                        "@${eachVideoInfo.userName}",
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 6,
                                      ),

                                      Text(
                                        eachVideoInfo.descriptionTags.toString(),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 6,
                                      ),

                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/musicLogo.png",
                                            width: 20,
                                            color: Colors.white,
                                          ),
                                          Expanded(
                                              child: Text(" ${eachVideoInfo.artistSongName}",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16, color: Colors.white),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),



                              /// Right panel
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height / 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //profile
                                    SizedBox(
                                      width: 62,
                                      height: 62,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 4,
                                            child: Container(
                                              width: 52,
                                              height: 52,
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(25),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(25),
                                                child: Image(
                                                  image: NetworkImage(
                                                    eachVideoInfo.userProfileImage
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    Column(
                                      children: [
                                        // likes button
                                        IconButton(
                                            onPressed: () {
                                              controllerVideoProfile.likeOrUnlikeVideos(eachVideoInfo.videoID.toString());
                                            },
                                            icon: Icon(
                                              Icons.favorite_rounded,
                                              size: 40,
                                              color: eachVideoInfo.likesList!
                                                  .contains(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                                  ? Colors.red
                                                  : Colors.white,
                                            )),
                                        Text(
                                          eachVideoInfo.likesList!.length
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.white),
                                        ),

                                        // Comment button
                                        IconButton(
                                            onPressed: () {
                                              Get.to(() => commentScreen(videoId: eachVideoInfo.videoID.toString()));
                                            },
                                            icon: const Icon(
                                              Icons.comment,
                                              size: 40,
                                              color: Colors.white,
                                            )),
                                        Text(
                                          eachVideoInfo.totalComments.toString(),
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.white),
                                        ),

                                        // Share button
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.share,
                                              size: 40,
                                              color: Colors.white,
                                            )),
                                        Text(
                                          eachVideoInfo.totalShares.toString(),
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.white),
                                        ),


                                        // profile circle animation
                                        circularImageAnimation(
                                          widgetAnimation: SizedBox(
                                            width: 62,
                                            height: 62,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(12),
                                                  height: 52,
                                                  width: 52,
                                                  decoration: BoxDecoration(
                                                      gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Colors.grey,
                                                            Colors.white,
                                                          ]),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(25),
                                                    child: Image(
                                                      image: NetworkImage(
                                                        eachVideoInfo.userProfileImage.toString(),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  )
                ],
              );
            },
          );
        }));
  }
}
