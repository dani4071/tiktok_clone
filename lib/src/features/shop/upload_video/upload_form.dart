import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/src/features/shop/upload_video/upload_controller.dart';
import 'package:video_player/video_player.dart';
import '../../../common/input_text_widget.dart';

class uploadForm extends StatefulWidget {

  final File videoFile;
  final String videoPath;

  const uploadForm({super.key, 
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<uploadForm> createState() => _uploadFormState();
}

class _uploadFormState extends State<uploadForm> {

  VideoPlayerController? playerController;
  UploadController uploadController = Get.put(UploadController());
  TextEditingController artistController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });
    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   playerController!.dispose();
  //   playerController!.pause();
  // }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: VideoPlayer(playerController!),
            ),
            const SizedBox(
              height: 30,
            ),

            showProgressBar == true ? Container(
              child: const SimpleCircularProgressBar(
                progressColors: [
                  Colors.green,
                  Colors.blueAccent,
                  Colors.green,
                  Colors.red,
                  Colors.purple,
                ],
                animationDuration: 20,
                backColor: Colors.white38,
              ),
            ) : Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputTextWidget(
                    textEditingController: artistController,
                    labelString: 'Artist',
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
                    textEditingController: descriptionController,
                    labelString: 'description',
                    isObscure: false,
                    iconData: Icons.lock,
                  ),
                ),
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

                      Get.snackbar("Works", "working");
                      if(artistController.text.isEmpty && descriptionController.text.isEmpty){
                        Get.snackbar("Empty", "its empty");
                      }

                      if(artistController.text.isNotEmpty && descriptionController.text.isNotEmpty) {

                        uploadController.saveVideoInformationToFirebaseDatabase(
                            artistController.text,
                            descriptionController.text,
                            widget.videoPath,
                            context
                        );

                        setState(() {
                          showProgressBar = true;
                        });
                      }

                    },
                    child: const Center(
                      child: Text(
                        'Upload now',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    playerController!.dispose();
    super.dispose();

  }
}
