import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:transition/transition.dart';
import '../styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import 'package:image/image.dart' as imglib;

class CommonUtils {
  static void log(String logType, String logMessage){
    var logger = Logger();
    switch(logType.toLowerCase()){
      case "d":
        return logger.d(logMessage);
      case "i":
        return logger.i(logMessage);
      case "e":
        return logger.e(logMessage);
      default :
        return logger.wtf(logMessage);
    }
  }

  static bool containsSpecialCharacters(String parameter) {
    final RegExp regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return regex.hasMatch(parameter);
  }

  static bool isNumeric(String parameter) {
    return double.tryParse(parameter) != null;
  }

  static String _removeFirstLetterIfZero(String str) {
    String result = "";
    if (str != "" && str[0] == '0') {
      result = str.substring(1);
    } else {
      result = str;
    }

    return result;
  }

  static String getRandomKey(){
    int randomNumber = Random().nextInt(10000); // 0 ~ 10000 랜덤
    return randomNumber.toString();
  }

  static void hideKeyBoard(BuildContext context){
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static bool isKoreanText(String text) {
    if (text.isEmpty) {
      return false; // Handle empty input
    }

    const koreanUnicodeStart = 0xAC00;
    const koreanUnicodeEnd = 0xD7AF;

    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);
      if (charCode >= koreanUnicodeStart && charCode <= koreanUnicodeEnd) {
        return true;
      }
    }
    return false;
  }

  static String getLastWord(String text) {
    List<String> words = text.split('');
    if (words.isNotEmpty) {
      return words.last;
    } else {
      return '';
    }
  }

  static String getFirstWord(String text) {
    List<String> words = text.split('');
    if (words.isNotEmpty) {
      return words.first;
    } else {
      return '';
    }
  }

  static String deleteLastEnter(String text){
    String result = text;
    while(CommonUtils.getLastWord(result) == "\n"){
      result = _replaceLastWord(result, "");
    }

    return result;
  }

  static String _replaceLastWord(String originalString, String newWord) {
    List<String> words = originalString.split('');
    if (words.isNotEmpty) {
      // Replace the last word with the new word
      words[words.length - 1] = newWord;
    }
    // Join the words back into a string
    String result = words.join('');
    return result;
  }

  static String extractStringAfterTarget(String originalString, String targetString){
    int index = originalString.indexOf(targetString);

    if (index != -1) {
      return originalString.substring(index + targetString.length);
    } else {
      return originalString;
    }
  }

  static String extractStringBeforeTarget(String originalString, String targetString){
    int index = originalString.indexOf(targetString);

    if (index != -1) {
      return originalString.substring(0, index);
    } else {
      return originalString;
    }
  }

  static String getPriceCommaFormattedString(double price){
    var format = NumberFormat('###,###,###,###');
    return format.format(price);
  }

  static String getPriceFormattedString(double price){
    String resultString = "";
    String targetPriceString = price.toString();
    String frontValue = "";
    String backValue = "";

    if(targetPriceString.length <= 4){
      backValue = targetPriceString;
    }else{
      backValue = targetPriceString.substring(targetPriceString.length - 4);
      frontValue = targetPriceString.substring(0, targetPriceString.length - 4);
    }

    if(frontValue != ""){
      for(int i = 0 ; i < 4 ; i++){
        backValue = _removeFirstLetterIfZero(backValue);
      }

      if(backValue == ""){
        resultString = "$frontValue억원";
      }else{
        resultString = "$frontValue억 $backValue만원";
      }
    }else{
      resultString = "$backValue만원";
    }

    return resultString;
  }

  static void flutterToast(String msgString){
    Fluttertoast.showToast(msg: msgString, gravity: ToastGravity.BOTTOM, backgroundColor: ColorStyles.darkGray, fontSize: 20, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
  }

  static Size _getSize(GlobalKey key) {
    final RenderBox renderBox =
    key.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    return size;
  }

  static List<double> safeSize(BuildContext context){
    double w = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.left - MediaQuery.of(context).padding.right;
    double h = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    return [w,h];
  }

  static List<double> fullSize(BuildContext context){
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return [w,h];
  }

  static void sleepMs(int targetMilliseconds){
    Duration sleepTime = Duration(milliseconds: targetMilliseconds);
    sleep(sleepTime);
  }

  static String formatDuration(int targetSeconds) {
    Duration duration = Duration(seconds: targetSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  static Future<void> moveView(BuildContext fromContext, Widget toView) async {
    await Navigator.push(fromContext, Transition(child: toView, transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
  }

  static void moveBack(BuildContext fromContext) {
    Navigator.pop(fromContext);
  }

  static Transition getViewTransition(Widget toView){
    return Transition(child: toView, transitionEffect: TransitionEffect.RIGHT_TO_LEFT);
  }

  static bool isKeyboardUp = false;
  static KeyboardVisibilityController getKeyboardViewController(void Function()? callbackOnKeyboardShow, void Function()? callbackOnKeyboardHide){
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardUp = visible;
      if(visible){
        if(callbackOnKeyboardShow != null) callbackOnKeyboardShow();
      }else{
        if(callbackOnKeyboardHide != null) callbackOnKeyboardHide();
      }
    });

    return keyboardVisibilityController;
  }

  static Future<bool> onWillPopForPreventBackButton(BuildContext? context){
    return Future(() => false);
  }

  static Future<bool> onWillPopForControlFinishApp(BuildContext? context) async {
    bool confirm = await showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('FinApp 종료', style: TextStyles.finishPopTitleStyle),
          content: Text('앱을 종료 하시겠습니까?', style: TextStyles.finishPopContentsStyle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('아니오', style: TextStyles.finishPopButtonTextStyle),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('예', style: TextStyles.finishPopButtonTextStyle),
            ),
          ],
        );
      },
    );
    // Return false to prevent the action, or true to allow it
    return confirm ?? false;
  }

  static void finishApp(){
    SystemNavigator.pop();
  }

  static DateTime convertStringToTime(String input) {
    String formattedInput = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (formattedInput.length < 14) {
      throw Exception('Invalid input format. Expected format: yyyyMMddHHmmss');
    }

    int year = int.parse(formattedInput.substring(0, 4));
    int month = int.parse(formattedInput.substring(4, 6)) - 1;
    int day = int.parse(formattedInput.substring(6, 8));
    int hour = int.parse(formattedInput.substring(8, 10));
    int minute = int.parse(formattedInput.substring(10, 12));
    int second = int.parse(formattedInput.substring(12, 14));

    return DateTime(year, month, day, hour, minute, second);
  }

  static String convertTimeToString(DateTime dateTime) {
    DateFormat formatter = DateFormat('yyyyMMddHHmmss');
    String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }

  static DateTime getCurrentLocalTime() {
    DateTime now = DateTime.now();
    return now;
  }

  static DateTime convertToUtcTime(DateTime dateTime) {
    DateTime utcDateTime = DateTime.utc(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
    return utcDateTime;
  }

  static DateTime convertToLocalTime(DateTime utcDateTime) {
    DateTime systemDateTime = utcDateTime.toLocal();
    return systemDateTime;
  }

  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> getGalleryImage() async {
    try{
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if(image != null){
        image = await renameFile(image, makeImageName(image));
        image = await convertImageFileToJpg(image);
        CommonUtils.log('i', "path : ${image.path}\nname : ${image.name}");
      }

      return image;
    }catch(e){
      CommonUtils.log('e', e.toString());
      return null;
    }
  }

  static Future<XFile?> getCameraImage() async {
    try{
      XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if(image != null){
        image = await renameFile(image, makeImageName(image));
        image = await convertImageFileToJpg(image);
        CommonUtils.log('i', "path : ${image.path}\nname : ${image.name}");
      }
      return image;
    }catch(e){
      CommonUtils.log('e', e.toString());
      return null;
    }
  }

  static Future<List<XFile?>> getGalleryImageList() async {
    List<XFile?> imageList = [];
    try{
      List<XFile?> imageListInMultiImage = await _picker.pickMultiImage();
      for(var eachImage in imageListInMultiImage){
        if(eachImage != null) {
          eachImage = await renameFile(eachImage, makeImageName(eachImage));
          eachImage = await convertImageFileToJpg(eachImage);
          imageList.add(eachImage);
        }
      }
      return imageList;
    }catch(e){
      CommonUtils.log('e', e.toString());
      return imageList;
    }
  }

  static Future<XFile> convertImageFileToJpg(XFile targetImage) async {
    String imagePath = targetImage.path;
    String extension = imagePath.split('.').last.toLowerCase();

    if (extension != 'jpg') {
      List<int> imageBytes = await File(imagePath).readAsBytes();
      imglib.Image? originalImage = imglib.decodeImage(Uint8List.fromList(imageBytes));
      if (originalImage != null) {
        String newImagePath = imagePath.replaceFirst(extension, 'jpg');
        File(newImagePath).writeAsBytesSync(imglib.encodeJpg(originalImage));
        targetImage = XFile(newImagePath);
      }
    }
    return targetImage;
  }

  static Future<XFile> renameFile(XFile targetImage, String newFileName) async {
    String originalPath = targetImage.path ?? '';
    File originalFile = File(originalPath);
    String originalFileName = originalFile.path.split('/').last;
    String newPath = originalPath.replaceFirst(originalFileName, newFileName);
    File renamedFile = await originalFile.rename(newPath);
    return XFile(renamedFile.path);
  }

  static String makeImageName(XFile targetImage){
    String currentTimeString = CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime());
    List filename = targetImage.name.split(".");
    return '$currentTimeString.${filename[1]}';
  }

  static Future<bool> uploadImage(XFile targetImage) async {
    try {
      //final MultipartFile multipartFile =  MultipartFile.fromFileSync(targetImage.path, contentType: MediaType("image", "jpg"));
      var formData = FormData.fromMap({'image': await MultipartFile.fromFile(targetImage.path)});
      //var formData = FormData.fromMap({'imageKey': multipartFile});

      var dio = Dio();
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      dio.options.headers = {'token': 'HEADER_TOKEN'};
      final res = await dio.post('BASE_URL', data: formData);

      CommonUtils.log('i', res.statusCode.toString());
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      return false;
    }
  }

}