import 'package:cloud_firestore/cloud_firestore.dart';


class videoModel {

  String? userID;
  String? userName;
  String? userProfileImage;
  String? videoID;
  int? totalComments;
  int? totalShares;
  List? likesList;
  String? artistSongName;
  String? descriptionTags;
  String? videoUrl;
  String? thumbnailUrl;
  int? publishedDateTime;

  videoModel ({
   this.userID,
   this.userName,
   this.userProfileImage,
   this.videoID,
   this.totalComments,
   this.totalShares,
   this.likesList,
   this.artistSongName,
   this.descriptionTags,
   this.videoUrl,
   this.thumbnailUrl,
   this.publishedDateTime,
});


  Map<String, dynamic> toJson() => {
    "userID": userID,
    "userName": userName,
    "userProfileImage": userProfileImage,
    "videoID": videoID,
    "totalComments": totalComments,
    "totalShares": totalShares,
    "likesList": likesList,
    "artistSongName": artistSongName,
    "descriptionTags": descriptionTags,
    "videoUrl": videoUrl,
    "thumbnailUrl": thumbnailUrl,
    "publishedDateTime": publishedDateTime,
  };

  static videoModel fromDocumentSnapshot(DocumentSnapshot snapshot) {

    var docSnapshot = snapshot.data() as Map<String, dynamic>;

    return videoModel(
      userID: docSnapshot["userId"],
      userName: docSnapshot["userName"],
      userProfileImage: docSnapshot["userProfileImage"],
      videoID: docSnapshot["videoID"],
      totalComments: docSnapshot["totalComments"],
      totalShares: docSnapshot["totalShares"],
      likesList: docSnapshot["likesList"],
      artistSongName: docSnapshot["artistSongName"],
      descriptionTags: docSnapshot["descriptionTags"],
      videoUrl: docSnapshot["videoUrl"],
      thumbnailUrl: docSnapshot["thumbnailUrl"],
      publishedDateTime: docSnapshot["publishedDateTime"],
    );
  }
}