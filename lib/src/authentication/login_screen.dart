import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_clone/src/authentication/authentication_controller.dart';
import 'package:tiktok_clone/src/authentication/registraation_screen.dart';
import 'package:tiktok_clone/src/common/input_text_widget.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool showProgressBar = false;
  final controller = AuthenticationController.instanceAuth;

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

              Image.asset(
                "assets/tiktok-logo.png",
                width: 200,
              ),

              Text(
                'Welcome',
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                ),
              ),

              Text(
                'Glad to see you',
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
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

                              if(email.text.isNotEmpty && password.text.isNotEmpty){
                                setState(() {
                                  showProgressBar = true;
                                });


                                controller.loginUserNow(email.text.trim(), password.text.trim());
                              }

                            },
                            child: const Center(
                              child: Text(
                                'Login',
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
                              "Don't have an Account? ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const registrationScreen());
                              },
                              child: const Text(
                                'Sign Up Now',
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
