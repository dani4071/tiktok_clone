import 'package:cloud_firestore/cloud_firestore.dart';

class commentModel {

  String? userName;
  String? commentText;
  String? userProfileImaage;
  String? userId;
  String? commentId;
  final publishedDateTime;
  List? commentLikesList;


  commentModel({
    this.userName,
    this.commentText,
    this.userProfileImaage,
    this.userId,
    this.commentId,
    this.publishedDateTime,
    this.commentLikesList,
});


  Map<String, dynamic> toJson() => {
    "userName": userName,
    "commonText": commentText,
    "userProfileImage": userProfileImaage,
    "userID": userId,
    "commentID": commentId,
    "publishedDateTime": publishedDateTime,
    "commentLikesList": commentLikesList,
  };


  static commentModel fromDocumentSnapshot(DocumentSnapshot snapshotDoc) {
    var documentSnapshot = snapshotDoc.data() as Map<String, dynamic>;

    return commentModel(
      userName: documentSnapshot["userName"],
      commentText: documentSnapshot["commonText"],
      userProfileImaage: documentSnapshot["userProfileImage"],
      userId: documentSnapshot["userID"],
      commentId: documentSnapshot["commentID"],
      publishedDateTime: documentSnapshot["publishedDateTime"],
      commentLikesList: documentSnapshot["commentLikesList"],
    );
  }

}