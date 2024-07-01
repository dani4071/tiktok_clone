import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/src/authentication/user.dart';

class searchController extends GetxController {
  final Rx<List<UserModel>> _userSearchedList = Rx<List<UserModel>>([]);
  List<UserModel> get userSearchedList => _userSearchedList.value;

  searchForUser(String textInput) {
    _userSearchedList.bindStream(FirebaseFirestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: textInput)
        .snapshots()
        .map((QuerySnapshot searchUserQuerySnapshot) {
      List<UserModel> searchList = [];

      for (var user in searchUserQuerySnapshot.docs) {
        searchList.add(UserModel.fromSnap(user));
      }

      return searchList;
    }));
  }
}
