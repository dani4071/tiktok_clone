import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/src/features/shop/upload_video/video_model.dart';

class ControllerForYou extends GetxController {
  final Rx<List<videoModel>> forYourVideoList = Rx<List<videoModel>>([]);

  List<videoModel> get forYouAllVideoList => forYourVideoList.value;

  @override
  void onInit() {
    super.onInit();

    forYourVideoList.bindStream(FirebaseFirestore.instance
        .collection("videos")
        .orderBy("totalComments", descending: true)
        .snapshots()
        .map((QuerySnapshot snapshotQuery) {
      List<videoModel> vidoesList = [];

      for (var eachVideo in snapshotQuery.docs) {
        vidoesList.add(videoModel.fromDocumentSnapshot(eachVideo));
      }
      return vidoesList;
    }));
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