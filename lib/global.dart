import 'package:firebase_auth/firebase_auth.dart';


bool showProgressBar = false;

final currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();