import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/homeControoler.dart';
import 'package:camera/camera.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    ImphomePageControoler controller = Get.put(ImphomePageControoler());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 226, 223, 53),
          child: Icon(Icons.video_call_outlined),
          onPressed: () {
            controller.initcamera();
          },
        ),
        body: WillPopScope(
            onWillPop: () {
              Get.defaultDialog(
                  title: "Warning".tr,
                  middleText: "Are you sure you want to leave app",
                  onConfirm: () {
                    exit(0);
                  },
                  onCancel: () {},
                  buttonColor: Colors.grey,
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.grey,
                  textConfirm: "yes",
                  textCancel: "no");
              return Future.value(false);
            },
            child: GetBuilder<ImphomePageControoler>(
                builder: (controller) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/3187946.jpg",
                              ))),
                      child: Center(
                          child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.15,
                          ),
                          // Text(
                          //   "Fruits Detector",
                          //   style: TextStyle(
                          //       fontSize: 32,
                          //       color: Color.fromARGB(163, 38, 151, 23),
                          //       fontWeight: FontWeight.bold),
                          // ),
                          SizedBox(),
                          controller.imgCamera == null
                              ? ClipRRect()
                              : Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: AspectRatio(
                                      aspectRatio: controller
                                          .cameraConroller!.value.aspectRatio,
                                      child: CameraPreview(
                                          controller.cameraConroller!),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          Text(
                            "${controller.resultlabel}",
                            style: TextStyle(
                                color: Color.fromARGB(161, 151, 189, 63),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                    ))));
  }
}
