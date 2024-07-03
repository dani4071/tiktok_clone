import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/src/features/shop/upload_video/video_model.dart';

class ControllerFollowingVideos extends GetxController {
  final Rx<List<videoModel>> followingVideoList = Rx<List<videoModel>>([]);
  List<videoModel> get followingAllVideoList => followingVideoList.value;

  List<String> followingKeysList = [];

  @override
  void onInit() {
    super.onInit();
    getFollowingListKeys();
  }

  getFollowingListKeys() async {
    var followingDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .collection("following")
        .get();

    for (int i = 0; i < followingDocument.docs.length; i++) {
      followingKeysList.add(followingDocument.docs[i].id);
    }

    // 2. get videos of the following people
    followingVideoList.bindStream(
      FirebaseFirestore.instance
          .collection("videos")
          .orderBy("publishedDateTime", descending: true)
          .snapshots()
          .map((QuerySnapshot snapshotVideo)
      {
        List<videoModel> followingPersonVideos = [];

        for(var eachVideo in snapshotVideo.docs){
          for(int i=0; i<followingKeysList.length; i++){
            String followingPersonID = followingKeysList[i];


            if(eachVideo["userID"] == followingPersonID){
              followingPersonVideos.add(videoModel.fromDocumentSnapshot(eachVideo));
            }
          }
        }

        return followingPersonVideos;
      }),
    );
  }


  likeOrUnlikeVideos(String videoId) async {
    // get user id
    var currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();

    // get the video id
    DocumentSnapshot snapshotDoc = await FirebaseFirestore.instance
        .collection("videos")
        .doc(videoId)
        .get();

    // if already liked
    if ((snapshotDoc.data() as dynamic)['likesList']
        .contains(currentUserId)) {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoId)
          .update({
        'likesList': FieldValue.arrayRemove([currentUserId])
      });
    }

    // if not liked
    else {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoId)
          .update({
        'likesList': FieldValue.arrayUnion([currentUserId])
      });
    }
  }
}