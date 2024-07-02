import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/src/features/shop/upload_video/video_model.dart';

class VideoControllerProfile extends GetxController {
  final Rx<List<videoModel>> videoFileList = Rx<List<videoModel>>([]);
  List<videoModel> get clickedVideoFile => videoFileList.value;

  final Rx<String> _videoID = "".obs;
  String get clickedVideoID => _videoID.value;


  setVideoId(String vID) {
    _videoID.value = vID;
  }

  //// basically this just gets all the video info once it matches the videoID(that can make you  get the whole document), its easy to understand, video 94
  getClickedVideoInfo() {

    videoFileList.bindStream(FirebaseFirestore.instance
        .collection("videos")
        .snapshots()
        .map((QuerySnapshot snapshotQuery) {

      List<videoModel> vidoesList = [];

      for (var eachVideo in snapshotQuery.docs) {
        if(eachVideo["videoID"] == clickedVideoID) {
          vidoesList.add(videoModel.fromDocumentSnapshot(eachVideo));
        }
      }
      return vidoesList;
    }));
  }

  @override
  void onInit() {
    super.onInit();
    getClickedVideoInfo();
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