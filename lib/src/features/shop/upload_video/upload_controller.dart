import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/src/features/shop/home_screen/home_screen.dart';
import 'package:tiktok_clone/src/features/shop/upload_video/video_model.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController {

  compressVideoFile(String videoFilePath) async {
    final compressVideoFilePath = await VideoCompress.compressVideo(videoFilePath, quality: VideoQuality.LowQuality);
    return compressVideoFilePath!.file;
  }


  uploadCompressedVideoFileToFirebaseStorage(String videoId, String videoFilePath) async {

    UploadTask videoUploadTask = FirebaseStorage.instance.ref().child("All Videos").child(videoId).putFile(await compressVideoFile(videoFilePath));

    TaskSnapshot snapshot = await videoUploadTask;

    String downloadUrlOfUploadedVideo = await snapshot.ref.getDownloadURL();

    return downloadUrlOfUploadedVideo;

  }



  getThumbnail(String videoFilePath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);

    return thumbnailImage;
  }

  uploadThumbnailImageToFirebaseStorage(String videoId, String videoFilePath) async {

    UploadTask thumbnailUploadTask = FirebaseStorage.instance.ref().child("All Thumbnails").child(videoId).putFile(await getThumbnail(videoFilePath));

    TaskSnapshot snapshot = await thumbnailUploadTask;

    String downloadUrlOfUploadedVideo = await snapshot.ref.getDownloadURL();

    return downloadUrlOfUploadedVideo;
  }


  saveVideoInformationToFirebaseDatabase(String artistName, String descriptionTags, String videoPath, BuildContext context) async {
    try {

      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();

      String videoId = DateTime.now().millisecondsSinceEpoch.toString();


      // 1. upload video to storage
      String videoDownloadedUrl = await uploadCompressedVideoFileToFirebaseStorage(videoId, videoPath);

      // 2. upload thumbnail to storage
      String thumbnailDownloadedUrl = await uploadThumbnailImageToFirebaseStorage(videoId, videoPath);

      // 3. save overall video info to firebase
      videoModel videoObject = videoModel(
        userID: FirebaseAuth.instance.currentUser!.uid,
        userName: (userDocumentSnapshot.data() as Map<String, dynamic>)["name"],
        userProfileImage: (userDocumentSnapshot.data() as Map<String, dynamic>)["image"],
        videoID: videoId,
        totalComments: 0,
        totalShares: 0,
        likesList: [],
        artistSongName: artistName,
        descriptionTags: descriptionTags,
        videoUrl: videoDownloadedUrl,
        thumbnailUrl: thumbnailDownloadedUrl,
        publishedDateTime: DateTime.now().millisecondsSinceEpoch,
      );

      await FirebaseFirestore.instance.collection("videos").doc(videoId).set(videoObject.toJson());

      showProgressBar = false;

      Get.to(const HomeScreen());
      
      Get.snackbar("New Video", "You successfully uploaded your new video");


      
    } catch (e) {
      Get.snackbar("Error uploading", "$e");
    }

  }

}