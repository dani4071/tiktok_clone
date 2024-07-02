import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';

class ProfileController extends GetxController {
  /// variables
  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get userMap => _userMap.value;
  final Rx<String> _userId = "".obs;

  /// getting the user id once this is called and passing the string to _userId so we can use it here in the controller
  updateCurrentUserId(String visitUserId) {
    _userId.value = visitUserId;
    retrieveUserInformation();
  }

  /// retreiving the user document using the id that was passed to us.
  retrieveUserInformation() async {
    DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userId.value)
        .get();

    final userInfo = userDocumentSnapshot.data() as dynamic;

    String userName = userInfo["name"];
    String userEmail = userInfo["email"];
    String userImage = userInfo["image"];
    String userUID = userInfo["uid"];
    String userYoutube = userInfo["youtube"] ?? "";
    String userInstagram = userInfo["instagram"] ?? "";
    String userTwitter = userInfo["twitter"] ?? "";
    String userFacebook = userInfo["facebook"] ?? "";

    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = false;
    List<String> thumbnailList = [];
    
    
    // get user's videos info
    //// users video that he uploaded himself so that you can display on his profile as thumbnail images
    var currentUserVideos = await FirebaseFirestore.instance
        .collection("videos")
        .orderBy("publishedDateTime", descending: true)
        .where("userID", isEqualTo: _userId.value)
        .get();
    
    for(int i=0; i<currentUserVideos.docs.length; i++) {
      thumbnailList.add((currentUserVideos.docs[i].data() as dynamic)["thumbnailUrl"]);
    }

    // get total number of likes
    //// this works by checking all the vidoes the particular user uploaded by using [currentUserVideos] then looping them to check the like list lenght then adding all together
    for(var eachVideo in currentUserVideos.docs) {
      totalLikes = totalLikes + (eachVideo.data()["likesList"] as List).length;
    }

    // get total number of followers
    var followerNumDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userId.value)
        .collection("followers")
        .get();
    totalFollowers = followerNumDocument.docs.length;

    // get total number of following
    var followingNumDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userId.value)
        .collection("following")
        .get();
    totalFollowings = followingNumDocument.docs.length;

    //get the isFollowing true or false value
    FirebaseFirestore.instance
        .collection("users")
        .doc(_userId.value)
        .collection("followers")
        .doc(currentUserId)
        .get().then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    /// assigning the snapshot of the user we got to the map  variable we created
    _userMap.value = {
      "userName": userName,
      "userEmail": userEmail,
      "userImage": userImage,
      "userUID": userUID,
      "userYoutube": userYoutube,
      "userInstagram": userInstagram,
      "userTwitter": userTwitter,
      "userFacebook": userFacebook,
      "totalLikes": totalLikes.toString(),
      "totalFollowers": totalFollowers.toString(),
      "totalFollowings": totalFollowings.toString(),
      "isFollowing": isFollowing,
      "thumbnailList": thumbnailList,
    };

    update();
  }

  followUnfollowUser() async {
    /// basically this explains it all
    // 1. currentUser = already logged in user
    // who is going to search and visit someone profile

    // 2. other user = [visitors profile]
    // currentUser is now on the profile page of other user

    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userId.value)
        .collection("followers")
        .doc(currentUserId)
        .get();

    // current user is Already following other user
    if (document.exists) {
      // remove follower
      // remove following

      // 1. remove currentUser as a follower from visitorPerson's followersList
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userId.value)
          .collection("followers")
          .doc(currentUserId)
          .delete();

      // 2. remove that visitProfile person as a new following to the current users following list
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .collection("following")
          .doc(_userId.value)
          .delete();

      // decrement - update totalFollowers number
      _userMap.value.update("totalFollowers", (value) => (int.parse(value) - 1).toString());
    }
    // if current user is not already following other user Z [visitors profile]
    else {
      /// if you remenber how tiktok works, when you follow someone, you have started following the person, but also in your own profile it showing that you are following the person, thats wharts happening here
      // 1. add currentUser as a new follower to visitors followerS list
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userId.value)
          .collection("followers")
          .doc(currentUserId)
          .set({});

      // 2. add that visitProfile person as a new following to the current users following list
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .collection("following")
          .doc(_userId.value)
          .set({});

      // add - update totalFollowers number
      _userMap.value.update("totalFollowers", (value) => (int.parse(value) + 1).toString());
    }

    _userMap.value.update("isFollowing", (value) => !value);
    update();
  }
}
