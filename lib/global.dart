import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


bool showProgressBar = false;

final currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();