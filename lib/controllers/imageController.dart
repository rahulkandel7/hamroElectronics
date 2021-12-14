import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  var selectedImagePath = ''.obs;

  var selectedImageSize = ''.obs;

  void getImage(ImageSource imagesource) async {
    final pickedFile = await ImagePicker().pickImage(source: imagesource);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;

      print(path.basename(selectedImagePath.value));
    } else {}
  }
}
