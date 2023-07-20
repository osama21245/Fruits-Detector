import 'dart:io';

import 'package:camera/camera.dart';
import 'package:friuts_detector/main.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

abstract class homePageControoler extends GetxController {
  String resultlabel = "";
  late ImagePicker imagepicker;
  bool isWorking = false;
  CameraController? cameraConroller;
  CameraImage? imgCamera;
}

class ImphomePageControoler extends homePageControoler {
  initcamera() {
    cameraConroller = CameraController(cameras![0], ResolutionPreset.medium);
    cameraConroller!.initialize().then((value) {
      cameraConroller!.startImageStream((imageFrameStream) => {
            if (!isWorking)
              {
                isWorking = true,
                imgCamera = imageFrameStream,
                runModelonStreamFream()
              }
          });
    });
  }

  loadmodel() async {
    String? output = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    print(output);
    update();
  }

  runModelonStreamFream() async {
    var recogition = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true);
    resultlabel = '';

    recogition!.forEach((element) {
      resultlabel += element['label'] +
          '    ' +
          (element['confidence'] as double).toStringAsExponential(2) +
          '\n\n';
    });
    update();
    isWorking = false;
  }

  @override
  void onInit() {
    loadmodel();
    imagepicker = ImagePicker();
    super.onInit();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraConroller?.dispose();
  }
}
