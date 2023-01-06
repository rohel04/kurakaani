import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePick{
  static Future<File?> pickImage(ImageSource imageSource,double height,double width) async{
    XFile? xFile=await ImagePicker().pickImage(source: imageSource,maxWidth: width,maxHeight: height);
    if(xFile!=null){
      return File(xFile.path);
    }
    else{
      return null;
    }
  }
}