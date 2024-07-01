import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  String? name;
  String? uid;
  String? image;
  String? email;
  String? youtube;
  String? facebook;
  String? twitter;
  String? instagram;


  UserModel({
    this.name,
    this.uid,
    this.image,
    this.email,
    this.youtube,
    this.facebook,
    this.twitter,
    this.instagram,
});


  Map<String, dynamic> toJson() => {
    "name": name,
    "uid": uid,
    "image": image,
    "email": email,
    "youtube": youtube,
    "facebook": facebook,
    "twitter": twitter,
    "instagram": instagram
  };


  static UserModel fromSnap(DocumentSnapshot snapshot){

    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      name: dataSnapshot['name'],
      uid: dataSnapshot['uid'],
      email: dataSnapshot['email'],
      image: dataSnapshot['image'],
      instagram: dataSnapshot['instagram'],
      youtube: dataSnapshot['youtube'],
      facebook: dataSnapshot['facebook'],
      twitter: dataSnapshot['twitter'],
    );
  }
}