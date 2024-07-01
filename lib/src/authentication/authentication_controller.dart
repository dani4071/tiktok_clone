import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/src/authentication/login_screen.dart';
import 'package:tiktok_clone/src/authentication/registraation_screen.dart';
import 'package:tiktok_clone/src/features/shop/home_screen/home_screen.dart';
import 'user.dart' as userModel;

class AuthenticationController extends GetxController {
  static AuthenticationController instanceAuth = Get.find();
  late Rx<File?> _pickedFile;
  late Rx<User?> _currentUser;


  @override
  void onReady() {
    super.onReady();
    _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_currentUser, goToScreen);
  }

  File? get profileImage => _pickedFile.value;

  void chooseImageFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      Get.snackbar("Profile Image",
          "You have successfully selected your profile image.");
    }
    _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }

  void captureImageFromCamera() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImageFile != null) {
      Get.snackbar("Profile Image",
          "You have successfully captured your profile image from your camera.");
    }
    _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }

  void loginUserNow(String userEmail, String userPassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      Get.snackbar("Login Successful", "Youre logged in successfully");
      showProgressBar = false;
      Get.to(const HomeScreen());
    } catch (error) {
      Get.snackbar(
          "Login unsuccessful", "Error occured during $error ========");

      showProgressBar = false;
      Get.to(const registrationScreen());
    }
  }

  void createAccountForNewUser(File imageFile, String userName, String email, String userPassword) async {
    try {
      /// create user in the firebase authentication
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: userPassword);

      /// save the user profile image in the firebase storage
      String imageDownloadUrl = await uploadImageToStorage(imageFile);

      /// save user datato the firebase database

      userModel.UserModel user = userModel.UserModel(
        name: userName,
        email: email,
        image: imageDownloadUrl,
        uid: credential.user!.uid,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set(user.toJson());
      Get.snackbar("Success", "Account created successfully",
          colorText: Colors.white);
      showProgressBar = false;
      Get.to(const loginScreen());
    } catch (error) {
      Get.snackbar("Error Message", "$error", colorText: Colors.white);

      showProgressBar = false;
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("Profile Image")
        .child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrlOfUploadedImage = await taskSnapshot.ref.getDownloadURL();

    return downloadUrlOfUploadedImage;
  }

  goToScreen(User? currentUser) {
    if(currentUser == null) {
      Get.offAll(const loginScreen());
    } else {
      Get.offAll(const HomeScreen());
    }
  }

}
