import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/src/features/shop/comments/comment_model.dart';

class CommentController extends GetxController {
  String currentVideoId = "";
  final Rx<List<commentModel>> commentsList = Rx<List<commentModel>>([]);

  List<commentModel> get listOfComments => commentsList.value;

  updateCurrentVideoId(String videoId) {
    currentVideoId = videoId;
    retrieveComments();
  }

  saveNewCommentToDatabase(String commentTextData) async {
    try {
      /// getting a unique id to use as a unique id for the comment
      String commentId = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

      /// getting current user id
      DocumentSnapshot snapshotUserDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      ///
      commentModel commentmodel = commentModel(
        userName: (snapshotUserDocument.data() as dynamic)["name"],
        userId: FirebaseAuth.instance.currentUser!.uid,
        userProfileImaage: (snapshotUserDocument.data() as dynamic)["image"],
        commentText: commentTextData,
        commentId: commentId,
        commentLikesList: [],
        publishedDateTime: DateTime.now(),
      );

      /// save the comment in a new path using the video id
      /// save new comment in the database
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoId)
          .collection("comments")
          .doc(commentId)
          .set(commentmodel.toJson());

      /// updating total comments by getting the video id
      DocumentSnapshot currentvideoIdToUpdateComment = await FirebaseFirestore
          .instance
          .collection("videos")
          .doc(currentVideoId)
          .get();

      /// updating the total comment itself
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoId)
          .update({
        "totalComments":
        (currentvideoIdToUpdateComment.data() as dynamic)["totalComments"] +
            1,
      });
    } catch (e) {
      Get.snackbar("Error in posting new comment", "Error: $e");
    }
  }


  retrieveComments() async {
    commentsList.bindStream(FirebaseFirestore.instance
        .collection("videos")
        .doc(currentVideoId)
        .collection("comments")
        .orderBy("publishedDateTime", descending: true)
        .snapshots()
        .map((QuerySnapshot commentsSnapshot) {
      List<commentModel> commentsListOfVideo = [];


      for (var eachComment in commentsSnapshot.docs) {
        commentsListOfVideo.add(commentModel.fromDocumentSnapshot(eachComment));
      }
      return commentsListOfVideo;
    }));
  }


  likeAndUnlikeComment(String commentId) async {
    DocumentSnapshot commentDocummentSnapshot = await FirebaseFirestore.instance
        .collection("videos")
        .doc(currentVideoId)
        .collection("comments")
        .doc(commentId)
        .get();


    /// unlike comment feature - red heart button
    if ((commentDocummentSnapshot.data() as dynamic)["commentLikesList"]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoId)
          .collection("comments")
          .doc(commentId).update({
        "commentLikesList": FieldValue.arrayRemove(
            [FirebaseAuth.instance.currentUser!.uid]),
      });
    }
    /// like comment feature - white heart button
    else {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoId)
          .collection("comments")
          .doc(commentId).update({
        "commentLikesList": FieldValue.arrayUnion(
            [FirebaseAuth.instance.currentUser!.uid]),
      });
    }
  }
}