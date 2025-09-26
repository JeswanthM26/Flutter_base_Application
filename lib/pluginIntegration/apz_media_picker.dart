import 'dart:io';

import 'package:apz_camera/apz_camera.dart';
import 'package:apz_photopicker/apz_photopicker.dart';
import 'package:apz_photopicker/enum.dart';
import 'package:apz_photopicker/photopicker_image_model.dart';
import 'package:apz_photopicker/photopicker_result.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


 
class ApzMediaPicker {

  final ApzCamera _camera = ApzCamera();

  final ApzPhotopicker _photoPicker = ApzPhotopicker();
 
  Future<String?> _saveImagePermanently(File imageFile) async {

    try {

      final directory = await getApplicationDocumentsDirectory();

      const String fileName = 'profile_image.png';

      final String newPath = path.join(directory.path, fileName);

      final File newImage = await imageFile.copy(newPath);

      return newImage.path;

    } catch (e) {

      print("Error saving image: $e");

      return null;

    }

  }
 
  Future<String?> pickImageFromCamera(BuildContext context) async {

    final captureParams = CameraCaptureParams(

      crop: true,

      cropTitle: "Crop Image",

      fileName: "temp_profile_pic",

      targetHeight: 1080,

      targetWidth: 1080,

      quality: 90,

      format: ImageFormat.png,

      cameraDeviceSensor: CameraDeviceSensor.front,

      previewTitle: "Preview",
    );
    try {
      final CaptureResult? result = await _camera.openCamera(
        params: captureParams,
        context: context,
      );
 
      if (result != null && result.filePath != null) {

        final File tempImage = File(result.filePath!);

        return await _saveImagePermanently(tempImage);

      }

    } on Exception catch (e) {

      print("Error opening camera: $e");

    }

    return null;

  }
 
  Future<String?> pickImageFromGallery(BuildContext context) async {

    final imageModel = PhotopickerImageModel(

      crop: true,

      quality: 90,

      fileName: 'temp_profile_pic',

      format: PhotopickerImageFormat.png,

      targetWidth: 1080,

      targetHeight: 1080,

      cropTitle: 'Crop Image',

    );
 
    try {

      final PhotopickerResult? result = await _photoPicker.pickFromGallery(

        cancelCallback: () => "",

        imagemodel: imageModel,

      );
 
      if (result != null && result.imageFile!=null) {

        return await _saveImagePermanently(result.imageFile!);

      }

    } on Exception catch (e) {

      print("Error picking from gallery: $e");

    }

    return null;

  }

}
 