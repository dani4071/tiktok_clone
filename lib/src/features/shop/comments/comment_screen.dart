import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/src/features/shop/comments/comment_controller.dart';
import 'package:timeago/timeago.dart' as tAgo;

class commentScreen extends StatelessWidget {
  final String videoId;

  commentScreen({super.key, required this.videoId});

  TextEditingController commentTextEditingController = TextEditingController();
  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {

    commentController.updateCurrentVideoId(videoId);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: commentController.listOfComments.length,
                    itemBuilder: (context, index) {

                      final eachCommentInfo = commentController.listOfComments[index];

                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          color: Colors.cyan,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(eachCommentInfo.userProfileImaage.toString()),
                                backgroundColor: Colors.yellow,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eachCommentInfo.userName.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 4,),
                                  
                                  
                                  Text(
                                    eachCommentInfo.commentText.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ), 
                                  const SizedBox(height: 6,),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    tAgo.format(eachCommentInfo.publishedDateTime.toDate()),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),

                                  Text(" ${eachCommentInfo.commentLikesList!.length} Likess",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  commentController.likeAndUnlikeComment(eachCommentInfo.commentId.toString());
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: eachCommentInfo.commentLikesList!
                                      .contains(FirebaseAuth.instance.currentUser!.uid)
                                      ? Colors.red
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              Container(
                color: Colors.white24,
                child: ListTile(
                  title: TextFormField(
                    controller: commentTextEditingController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                        labelText: "Add a comment Here",
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      if (commentTextEditingController.text.isNotEmpty) {
                        commentController.saveNewCommentToDatabase(
                            commentTextEditingController.text.trim());
                        commentTextEditingController.clear();
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 40,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
