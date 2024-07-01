import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_clone/src/authentication/authentication_controller.dart';
import 'package:tiktok_clone/src/authentication/login_screen.dart';
import 'package:tiktok_clone/src/common/input_text_widget.dart';

import '../../global.dart';

class registrationScreen extends StatefulWidget {
  const registrationScreen({super.key});

  @override
  State<registrationScreen> createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                'Create Account',
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                ),
              ),
              Text(
                'To get started now!',
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  authenticationController.captureImageFromCamera();
                },
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("assets/pic.png"),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: username,
                  labelString: 'Username',
                  isObscure: false,
                  iconData: Icons.person,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: email,
                  labelString: 'Email',
                  isObscure: false,
                  iconData: Icons.email_outlined,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: password,
                  labelString: 'Password',
                  isObscure: true,
                  iconData: Icons.lock,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              showProgressBar == false
                  ? Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 38,
                          height: 54,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: InkWell(
                            onTap: () {
                              if (authenticationController.profileImage !=
                                      null &&
                                  username.text.isNotEmpty &&
                                  email.text.isNotEmpty &&
                                  password.text.isNotEmpty) {
                                setState(() {
                                  showProgressBar = true;
                                });

                                authenticationController
                                    .createAccountForNewUser(
                                  authenticationController.profileImage!,
                                  username.text.trim(),
                                  email.text.trim(),
                                  password.text.trim(),
                                );
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const loginScreen());
                              },
                              child: const Text(
                                'Login Here',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  : Container(
                      child: const SimpleCircularProgressBar(
                        progressColors: [
                          Colors.green,
                          Colors.pink,
                          Colors.yellow,
                          Colors.pink,
                          Colors.purple,
                        ],
                        animationDuration: 3,
                        backColor: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
