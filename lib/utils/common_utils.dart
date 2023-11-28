import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/codef_controller.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/sharedpreference_controller.dart';
import 'package:upfin/controllers/websocket_controller.dart';
import 'package:upfin/utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import '../configs/app_config.dart';
import '../datas/my_data.dart';
import '../styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import 'package:image/image.dart' as imglib;
import 'package:timezone/data/latest.dart' as tzlocal;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

import '../views/app_main_view.dart';

class CommonUtils {

  static void logcat(){

  }

  static const int logMaxSize = 600;
  static void log(String logType, String logMessage){
    if(FireBaseController.fcmToken != ""){
      if(logType.toLowerCase() == "e"){
        FireBaseController.writeLog("error", FireBaseController.fcmToken, logMessage);
      }
    }

    if(logType.toLowerCase() != "e") logType = "";

    var logger = Logger();
    if(logMessage.length > logMaxSize){
      switch(logType.toLowerCase()){
        case "d":
          logger.d("long log start=======================>");
        case "i":
          logger.i("long log start=======================>");
        case "e":
          logger.e("long log start=======================>");
        case "w":
          logger.wtf("long log start=======================>");
        default:
          break;
      }

      for (int i = 0; i < logMessage.length; i += logMaxSize) {
        int end = (i + logMaxSize < logMessage.length) ? i + logMaxSize : logMessage.length;
        switch(logType.toLowerCase()){
          case "d":
            logger.d(logMessage.substring(i, end));
          case "i":
            logger.i(logMessage.substring(i, end));
          case "e":
            logger.e(logMessage.substring(i, end));
          case "w":
            logger.wtf(logMessage.substring(i, end));
          default:
            break;
        }
      }

      switch(logType.toLowerCase()){
        case "d":
          logger.d("long log end=======================>");
        case "i":
          logger.i("long log end=======================>");
        case "e":
          logger.e("long log end=======================>");
        case "w":
          logger.wtf("long log end=======================>");
        default:
          break;
      }
    }else{
      switch(logType.toLowerCase()){
        case "d":
          return logger.d(logMessage);
        case "i":
          return logger.i(logMessage);
        case "e":
          return logger.e(logMessage);
        case "w":
          return logger.wtf(logMessage);
        default:
          break;
      }
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

  static void hideKeyBoard(){
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

  static Future<void> checkUpdate(BuildContext context) async {
    CommonUtils.log("w","check update");
    int state = await Config.isNeedToUpdateForMain();
    CommonUtils.log("w","check update state : $state");
    if(state == 99){
      if(context.mounted && !isOutPopOn){
        CommonUtils.log("w","check update mount");
        isOutPopOn = true;
        UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, 100.w, Config.isAndroid ? 30.h : 35.h, 0.5, (context, setState){
          return Column(children: [
            UiUtils.getMarginBox(0, 3.h),
            Center(child: UiUtils.getTextWithFixedScale("시스템 점검중입니다.", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, null)),
            UiUtils.getMarginBox(0, 3.h),
            UiUtils.getExpandedScrollView(Axis.vertical,
                SizedBox(width : 80.w, child: UiUtils.getTextWithFixedScale2(Config.appInfoTextMap["close_text"].replaceAll("@@", "\n"), 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null))),
            UiUtils.getMarginBox(0, 1.h)
          ]);
        });
      }
    }else if(state == 44){
      if(context.mounted && !isOutPopOn){
        CommonUtils.log("w","check update mount");
        isOutPopOn = true;
        UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, 100.w, Config.isAndroid ? 18.h : 23.h, 0.5, (context, setState){
          return Center(child: Column(children: [
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("앱 업데이트가 필요합니다!", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
            UiUtils.getMarginBox(0, 3.h),
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                UiUtils.getTextWithFixedScale("업데이트", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
                  launchUrl(Uri.parse(Config.appStoreUrl));
                }),
            Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h)
          ]));
        });
      }
    }
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
    String targetPriceString = price.toInt().toString();
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
        resultString = "${getPriceCommaFormattedString(double.parse(frontValue))}억원";
      }else{
        resultString = "${getPriceCommaFormattedString(double.parse(frontValue))}억 ${getPriceCommaFormattedString(double.parse(backValue))} 만원";
      }
    }else{
      resultString = "${getPriceCommaFormattedString(double.parse(backValue))} 만원";
    }

    return resultString;
  }

  static void flutterToast(String msgString){
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: msgString, gravity: ToastGravity.SNACKBAR, backgroundColor: ColorStyles.upFinDarkGray, timeInSecForIosWeb : 3,
        fontSize: 12.sp, textColor: ColorStyles.upFinWhite, toastLength: Config.isAndroid? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
  }

  static setAppLog(String eventName){
    if(MyData.email != ""){
      Map<String, Object> data = {
        'id': CommonUtils.encryptData(MyData.email),
        'time': CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime()),
        'event' : eventName
      };

      CommonUtils.log("w","call app log");
      FireBaseController.analytics!.logEvent(name: eventName, parameters: data);
    }
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

  static Future<void> moveTo(BuildContext fromContext, String toRoute, Object? arguments) async {
    await Navigator.of(fromContext).pushNamed(toRoute, arguments: arguments);
  }

  static Future<Object?> moveToWithResult(BuildContext fromContext, String toRoute, Object? arguments) async {
    final result = await Navigator.of(fromContext).pushNamed(toRoute, arguments: arguments);
    return result;
  }

  static Future<void> moveWithRemoveUntil(BuildContext fromContext, String toRoute, Object? arguments) async {
    await Navigator.of(fromContext).pushNamedAndRemoveUntil(toRoute, (route) => false, arguments: arguments);
  }

  static void moveWithUntil(BuildContext fromContext, String toRoute) {
    Navigator.popUntil(fromContext, ModalRoute.withName(toRoute));
  }

  static Future<void> moveWithReplacementTo(BuildContext fromContext, String toRoute, Object? arguments) async {
    await Navigator.of(fromContext).pushReplacementNamed(toRoute, arguments: arguments);
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

  static Future<bool> onWillPopForPreventBackButton(){
    return Future(() => false);
  }

  static Future<bool> onWillPopForControlFinishApp(BuildContext? context) async {
    bool confirm = await showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('FinApp 종료', style: TextStyles.upFinTitleTextStyle),
          content: Text('앱을 종료 하시겠습니까?', style: TextStyles.upFinBasicTextStyle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('아니오', style: TextStyles.upFinBasicTextStyle),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('예', style: TextStyles.upFinBasicTextStyle),
            ),
          ],
        );
      },
    );
    // Return false to prevent the action, or true to allow it
    return confirm;
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
    int month = int.parse(formattedInput.substring(4, 6));
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

  static DateTime parseToLocalTime(String targetDate){
    tzlocal.initializeTimeZones(); // 타임존 초기화
    final location = tz.getLocation('Asia/Seoul'); // 원하는 타임존 설정
    DateTime parsedDateTime = DateTime.parse(targetDate);
    tz.TZDateTime parsedDateTimeWithTimeZone = tz.TZDateTime.from(parsedDateTime, location);
    return parsedDateTimeWithTimeZone;
  }

  static DateTime addTimeToTargetTime(DateTime targetDateTime) {
    DateTime thirtyMinLater = DateTime(
      targetDateTime.year,
      targetDateTime.month,
      targetDateTime.day,
      targetDateTime.hour+1,
      targetDateTime.minute,
      targetDateTime.second,
    );

    return thirtyMinLater;
  }

  static DateTime addWeekToTargetTime(DateTime targetDateTime) {
    DateTime thirtyMinLater = DateTime(
      targetDateTime.year,
      targetDateTime.month,
      targetDateTime.day+7,
      targetDateTime.hour,
      targetDateTime.minute,
      targetDateTime.second,
    );

    return thirtyMinLater;
  }

  static DateTime getCurrentLocalTime() {
    DateTime now = convertStringToTime(convertTimeToString(DateTime.now()));
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

  static Map<String, Image> cachedImageMap = {};
  static Map<String, List<double>> cachedImageSizedMap = {};

  static void setCachedImage(String url) async {
    try{
      var response = await http.get(Uri.parse(url));
      String responseString = String.fromCharCodes(response.bodyBytes);
      Image image = Image.memory(response.bodyBytes);
      image.fittedBox(fit:BoxFit.contain);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
          String widthString = info.image.width.toString();
          String heightString = info.image.height.toString();
          CommonUtils.log("", "saved img : $url\n$widthString, $heightString");
        }),
      );
    }catch(error){
      CommonUtils.log('e', 'set cached image size error : $error');
    }
  }

  static bool isCachedImage(String url){
    String result = "";
    if(result != ""){
      return true;
    }else{
      return false;
    }
  }

  static Image? getCachedImage(String url) {
    try{
      if(isCachedImage(url)){
        String result = "";
        List<int> responseBytes = result.codeUnits;
        return Image.memory(Uint8List.fromList(responseBytes));
      }else{
        CommonUtils.log('e', 'set cached image null');
        return null;
      }
    }catch(error){
      CommonUtils.log('e', 'set cached image error : $error');
      return null;
    }
  }

  static List<double>? getCachedImageSize(String url) {
    try{
      if(isCachedImage(url)){
        double w = 0;
        double h = 0;
        String wResult = "";
        w = double.parse(wResult);
        String hResult = "";
        h = double.parse(hResult);
        return [w,h];
      }else{
        CommonUtils.log('e', 'set cached image null');
        return null;
      }
    }catch(error){
      CommonUtils.log('e', 'set cached image error : $error');
      return null;
    }
  }

  static Future<List<File>?> getFiles(int type) async {
    try{
      // type 1: android all
      // type 2: ios img
      // type 3: ios doc
      FilePickerResult? result;
      if(type == 1){
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: LogfinController.validFileTypeList,
          allowMultiple: false,
        );
      }else if(type == 2){
        result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
      }else if(type == 3){
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: LogfinController.validFileTypeList,
          allowMultiple: false,
        );
      }

      if(result != null) {
        List<File> pickFiles = result.paths.map((path) => File(path!)).toList();
        if(pickFiles.isNotEmpty){
          return pickFiles;
        }else{
          return null;
        }
      } else {
        return null;
      }
    }catch(error){
      CommonUtils.log('e', 'getFile error : $error');
      return null;
    }
  }

  static Future<bool> isFileExists(String filePath) async {
    File file = File(filePath);
    return await file.exists();
  }

  static Future<void> convertImageFileToJpg(String targetImagePath) async {
    File originalFile = File(targetImagePath);
    String originalFileName = originalFile.path.split('/').last;
    List imageNameSplit = originalFileName.split(".");
    String extension = imageNameSplit[1].toLowerCase();

    if (extension != 'jpg' && extension != 'jpeg') {
      List<int> imageBytes = await File(targetImagePath).readAsBytes();
      imglib.Image? originalImage = imglib.decodeImage(Uint8List.fromList(imageBytes));
      if (originalImage != null) {
        String newImagePath = targetImagePath.replaceFirst(extension, 'jpg');
        await File(newImagePath).writeAsBytes(imglib.encodeJpg(originalImage));
        CommonUtils.log('i', 'after convert to JPG');
        await printFileSize(File(newImagePath));
      }
    }else{
      CommonUtils.log('i', 'don\'t need convert to JPG');
    }
  }

  static Future<String> renameFile(String targetImagePath, String newFileName) async {
    try {
      final originalFile = File(targetImagePath);
      final directory = originalFile.parent;
      final ext = targetImagePath.split(".").last;
      final destinationFile = File('${directory.path}/$newFileName.$ext');
      await originalFile.copy(destinationFile.path);

      CommonUtils.log("w","new file : ${destinationFile.path}");
      return destinationFile.path;
    } catch (e) {
      CommonUtils.log("w","new file error: $e");
      return "";
    }
  }

  static String getNewImagePath(String targetImagePath){
    File originalFile = File(targetImagePath);
    String originalFileName = originalFile.path.split('/').last;
    String currentTimeString = CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime());
    List filename = originalFileName.split(".");
    String newFileName = '$currentTimeString.${filename[1]}';
    String newPath = targetImagePath.replaceFirst(originalFileName, newFileName);
    CommonUtils.log('i', 'original path : $targetImagePath\nnew path : $newPath');
    return newPath;
  }

  static Future<void> printFileSize(File file) async {
    int sizeInBytes = await file.length();
    double sizeInKB = sizeInBytes / 1024; // Convert bytes to kilobytes
    CommonUtils.log('i','File Size \nKB : $sizeInKB kb');
  }

  static Future<void> printXFileSize(XFile xFile) async {
    int sizeInBytes = await xFile.length();
    double sizeInKB = sizeInBytes / 1024; // Convert bytes to kilobytes
    double sizeInMB = sizeInKB / 1024;    // Convert kilobytes to megabytes
    CommonUtils.log('i','XFile Size \nKB : $sizeInKB kb \nMB :  $sizeInMB mb');
  }

  static Future<String> _remakeFileAndGetPath(String filePath) async {
    CommonUtils.log('i', 'before convert to JPG');
    await printFileSize(File(filePath));
    await convertImageFileToJpg(filePath);
    String newPath = getNewImagePath(filePath);
    CommonUtils.log('i', 'before rename image file');
    await renameFile(filePath, newPath);
    await printXFileSize(XFile(newPath));

    return newPath;
  }

  static Future<String> makeMaskingImageAndGetPath(String imagePath, Map<String,dynamic> maskingInfoMap) async {
    try {
      final imglib.Image image = imglib.decodeImage(File(imagePath).readAsBytesSync())!;
      List<dynamic> listMap = maskingInfoMap['personalNum'][0]['maskingPolys'][0]['vertices'];
      List<int> xPoints = [];
      List<int> yPoints = [];
      for(Map<String,dynamic> each in listMap){
        var xPoint = each['x'].toString().split(".")[0];
        var yPoint = each['y'].toString().split(".")[0];
        xPoints.add(int.parse(xPoint));
        yPoints.add(int.parse(yPoint));
      }

      int minXValue = xPoints.reduce((min, current) => min < current ? min : current);
      int maxXValue = xPoints.reduce((max, current) => max > current ? max : current);
      int minYValue = yPoints.reduce((min, current) => min < current ? min : current);
      int maxYValue = yPoints.reduce((max, current) => max > current ? max : current);
      int maskingXSize = maxXValue - minXValue;
      int maskingYSize = maxYValue - minYValue;
      int startXPoint = minXValue;
      int startYPoint = minYValue;
      int endXPoint = maxXValue;
      int endYPoint = maxYValue;

      List<dynamic> listMapForBounding = maskingInfoMap['personalNum'][0]['boundingPolys'][0]['vertices'];
      List<int> xPointsForBounding = [];
      List<int> yPointsForBounding = [];
      for(Map<String,dynamic> each in listMapForBounding){
        var xPointForBounding = each['x'].toString().split(".")[0];
        var yPointForBounding = each['y'].toString().split(".")[0];
        xPointsForBounding.add(int.parse(xPointForBounding));
        yPointsForBounding.add(int.parse(yPointForBounding));
      }

      int minXValueForBounding = xPointsForBounding.reduce((min, current) => min < current ? min : current);
      int maxXValueForBounding = xPointsForBounding.reduce((max, current) => max > current ? max : current);
      int minYValueForBounding = yPointsForBounding.reduce((min, current) => min < current ? min : current);
      int maxYValueForBounding = yPointsForBounding.reduce((max, current) => max > current ? max : current);
      int maskingXSizeForBounding = maxXValueForBounding - minXValueForBounding;
      int maskingYSizeForBounding = maxYValueForBounding - minYValueForBounding;
      int startXPointForBounding = minXValueForBounding;
      int startYPointForBounding = minYValueForBounding;

      bool isError = false;
      if(maskingXSizeForBounding > maskingYSizeForBounding){
        //가로모드
        if(maskingXSizeForBounding*0.6 <= maskingXSize){
          isError = true;
        }
      }else{
        //세로모드
        if(maskingYSizeForBounding*0.6 <= maskingYSize){
          isError = true;
        }
      }

      CommonUtils.log("i", "Bounding image info ===========>\n"
          "maskingXSizeForBounding:$maskingXSizeForBounding maskingYSizeForBounding:$maskingYSizeForBounding\n"
          "startXPointForBounding:$startXPointForBounding startYPointForBounding: $startYPointForBounding");

      CommonUtils.log("i", "Masking image info ===========>\n"
          "maskingXSize:$maskingXSize maskingYSize:$maskingYSize\n"
          "startXPoint:$startXPoint startYPoint: $startYPoint");

      if(isError){
        CommonUtils.log('e', "masking size error");
        return "";
      }else{
        imglib.fillRect(image, x1: startXPoint, x2 : endXPoint, y1: startYPoint, y2 : endYPoint, color: imglib.ColorRgba8(0, 0, 0, 255));
        final modifiedImagePath = imagePath.replaceAll('.jpg', '_masked.jpg');
        File(modifiedImagePath).writeAsBytesSync(imglib.encodeJpg(image));
        return modifiedImagePath;
      }


    } catch (e) {
      CommonUtils.log('e', e.toString());
      return "";
    }
  }

  static Future<void> backToHome(BuildContext context) async {
    resetData();
    MyData.isLogout = true;
    await FireBaseController.setNotificationTorF(false);
    await CommonUtils.saveSettingsToFile("push_from", "");
    await CommonUtils.saveSettingsToFile("push_room_id", "");
    CommonUtils.log("", "delete file");
    if(context.mounted) CommonUtils.moveWithUntil(context, AppView.appRootView.value);
  }

  static Future<void> emergencyBackToHome() async {
    CommonUtils.log("w", "em out1");
    if(Config.contextForEmergencyBack != null){
      CommonUtils.log("w", "em out2");
      resetData();
      MyData.isLogout = true;
      await FireBaseController.setNotificationTorF(false);
      await CommonUtils.saveSettingsToFile("push_from", "");
      await CommonUtils.saveSettingsToFile("push_room_id", "");
      CommonUtils.log("", "delete file");
      if(Config.isEmergencyRoot){
        CommonUtils.moveWithReplacementTo(Config.contextForEmergencyBack!, AppView.appRootView.value, null);
      }else{
        CommonUtils.moveWithUntil(Config.contextForEmergencyBack!, AppView.appRootView.value);
      }
    }
  }

  static bool containsKorean(String text) {
    for (int i = 0; i < text.length; i++) {
      final characterCode = text.codeUnitAt(i);
      if ((characterCode >= 0xAC00 && characterCode <= 0xD7A3) ||
          (characterCode >= '가'.codeUnitAt(0) && characterCode <= '힣'.codeUnitAt(0))) {
        return true;
      }
    }
    return false;
  }

  static void resetData(){
    MyData.resetMyData();
    hideKeyBoard();
    AppMainViewState.doCheckToSearchAccident = false;
    GetController.to.resetAccdientInfoList();
    GetController.to.resetChatLoanInfoList();
    GetController.to.resetChatMessageInfoList();
    WebSocketController.resetConnectWebSocketCable();
    WebSocketController.resetRetry();
    GetController.to.updateAllSubScribed(true);
    if(CodeFController.apiCheckTimer != null) CodeFController.apiCheckTimer!.cancel();
  }

  static Future<void> goToMain(BuildContext context, String? email, String? password) async {
    DateTime thirtyMinutesLater = CommonUtils.addTimeToTargetTime(CommonUtils.getCurrentLocalTime());
    if(email != null && password != null){
      String prevId = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceIdKey);
      if(prevId != email){
        SharedPreferenceController.deleteAllData();
      }
      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceValidDateKey, CommonUtils.convertTimeToString(thirtyMinutesLater));
      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIdKey, email);
      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferencePwKey, password);
      CommonUtils.moveWithReplacementTo(context, AppView.appMainView.value, null);
    }else{
      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceValidDateKey, CommonUtils.convertTimeToString(thirtyMinutesLater));
      CommonUtils.moveTo(context, AppView.appMainView.value, null);
    }

    MyData.isLogout = false;
    await FireBaseController.setNotificationTorF(true);
  }

  static Future<String> makeCroppedImageAndGetPath(String imagePath, Map<String,dynamic> infoMap) async {
    try {
      final imglib.Image image = imglib.decodeImage(File(imagePath).readAsBytesSync())!;
      List<dynamic> listMap = infoMap['rois_map'][0]['vertices'];
      List<int> xPoints = [];
      List<int> yPoints = [];
      for(Map<String,dynamic> each in listMap){
        var xPoint = each['x'].toString().split(".")[0];
        var yPoint = each['y'].toString().split(".")[0];
        xPoints.add(int.parse(xPoint));
        yPoints.add(int.parse(yPoint));
      }

      int minXValue = xPoints.reduce((min, current) => min < current ? min : current);
      int maxXValue = xPoints.reduce((max, current) => max > current ? max : current);
      int minYValue = yPoints.reduce((min, current) => min < current ? min : current);
      int maxYValue = yPoints.reduce((max, current) => max > current ? max : current);
      int maskingXSize = maxXValue - minXValue;
      int maskingYSize = maxYValue - minYValue;
      int startXPoint = minXValue;
      int startYPoint = minYValue;

      final cropped = imglib.copyCrop(image, x: startXPoint, y: startYPoint, width: maskingXSize, height: maskingYSize);
      final modifiedImagePath = imagePath.replaceAll('.jpg', '_cropped.jpg');
      File(modifiedImagePath).writeAsBytesSync(imglib.encodeJpg(cropped));
      return modifiedImagePath;
    } catch (e) {
      CommonUtils.log('e', e.toString());
      return "";
    }
  }

  static String getFormattedLastMsgTime(String timeString){
    String result = "";
    DateTime now = CommonUtils.getCurrentLocalTime();
    String nowYearString = CommonUtils.convertTimeToString(now).substring(0,4);
    String chatYearString = timeString.substring(0,4);
    if(chatYearString != nowYearString){
      result = "${timeString.substring(2,4)}.${timeString.substring(4,6)}.${timeString.substring(6,8)}";
    }else{
      DateTime yesterday = DateTime(now.year, now.month, now.day-1);
      String yesterdayString = CommonUtils.convertTimeToString(yesterday).substring(0,8);
      String chatDayString = timeString.substring(0,8);
      if(yesterdayString != chatDayString){
        String nowDayString = CommonUtils.convertTimeToString(now).substring(0,8);
        if(nowDayString != chatDayString){
          result = "${timeString.substring(4,6)}월 ${timeString.substring(6,8)}일";
        }else{
          result = "${timeString.substring(8,10)}시 ${timeString.substring(10,12)}분";
        }
      }else{
        result = "어제";
      }
    }

    return result;
  }

  static String getValueFromDeepLink(String link, String parameterKey){
    String parameterValue = "";

    if(link.contains("?")){
      String paramString = link.split("?").last;
      List<String> paramList = paramString.split("&");
      if(paramList.isEmpty){
        parameterValue = paramString.split("=").last;
      }else{
        for(var each in paramList){
          if(each.contains(parameterKey)){
            parameterValue = each.split("=").last;
          }
        }
      }
    }

    return parameterValue;
  }

  static bool isEmailValid(String email) {
    if(email == "" || email.length <= 5 || email.contains(" ") ||  email.contains("..")){
      return false;
    }else{
      // 이메일 형식을 확인하기 위한 정규 표현식
      String emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
      RegExp regExp = RegExp(emailRegex);

      // 정규 표현식과 매치되는지 확인
      return regExp.hasMatch(email);
    }
  }

  static Future<bool> isPermissionDenied() async {
    bool result = false;
    for(var each in Config.permissionList){
      var status = await each.status;
      CommonUtils.log("W","status : ${status.isDenied} || ${status.isLimited} || ${status.isGranted}");
      if(Config.isAndroid){
        if (status.isDenied) {
          result = true;
        }
      }else{
        if(status.isDenied){
          result = true;
        }else{
          if(!status.isGranted){
            result = true;
          }

        }
      }
    }
    CommonUtils.log("W","status result : $result");
    return result;
  }

  static bool isOutPopOn = false;

  static Future<void> requestPermissions(Function(bool isDenied, List<String>? deniedPermissionsList) callback) async {
    List<String> deniedPermissions = [];
    for(var each in Config.permissionList){
      var status = await each.request();
      if(Config.isAndroid){
        if (status.isDenied) {
          String permissionName = each.toString().split('.').last;
          CommonUtils.log("w", "p name : $permissionName");
          switch(permissionName){
            case "notification" : permissionName = "알림";
            case "phone" : permissionName = "전화";
            case "camera" : permissionName = "카메라";
            case "photos" : permissionName = "앨범";
            case "storage" : permissionName = "저장소";
            case "manageExternalStorage" : permissionName = "저장소";
          }
          deniedPermissions.add(permissionName);
        }
      }else{
        if (status.isDenied) {
          String permissionName = each.toString().split('.').last;
          CommonUtils.log("w", "p name : $permissionName");
          switch(permissionName){
            case "notification" : permissionName = "알림";
            case "phone" : permissionName = "전화";
            case "camera" : permissionName = "카메라";
            case "photos" : permissionName = "앨범";
            case "storage" : permissionName = "저장소";
            case "manageExternalStorage" : permissionName = "저장소";
          }
          deniedPermissions.add(permissionName);
        }else{
          if (!status.isGranted) {
            String permissionName = each.toString().split('.').last;
            CommonUtils.log("w", "p name : $permissionName");
            switch(permissionName){
              case "notification" : permissionName = "알림";
              case "phone" : permissionName = "전화";
              case "camera" : permissionName = "카메라";
              case "photos" : permissionName = "앨범";
              case "storage" : permissionName = "저장소";
              case "manageExternalStorage" : permissionName = "저장소";
            }
            deniedPermissions.add(permissionName);
          }
        }
      }
    }

    if(deniedPermissions.isNotEmpty){
      return callback(true, deniedPermissions);
    }else{
      return callback(false, null);
    }
  }

  static String decryptLogData(String token, String encText) {
    try {
      if (encText != "") {
        final keyBytes = _getEnCodeKey();
        final key = encrypt.Key(Uint8List.fromList(keyBytes));
        var ivText = removeSpecialCharacters(token).substring(0,16);
        final ivBytes = ivText.codeUnits;
        final iv = encrypt.IV(Uint8List.fromList(ivBytes));
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final encodedData = encrypt.Encrypted.fromBase64(encText);
        final decrypted = encrypter.decrypt(encodedData, iv: iv);
        return decrypted;
      } else {
        CommonUtils.flutterToast("enc 값이 없습니다.");
        return "";
      }
    } catch (error) {
      CommonUtils.flutterToast("$error");
      return "";
    }
  }

  static String encryptData(String data) {
    try {
      if (data != "") {
        final keyBytes = _getEnCodeKey();
        final key = encrypt.Key(Uint8List.fromList(keyBytes));
        var ivText = removeSpecialCharacters(FireBaseController.fcmToken).substring(0,16);
        final ivBytes = ivText.codeUnits;
        final iv = encrypt.IV(Uint8List.fromList(ivBytes));
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final encrypted = encrypter.encrypt(data, iv: iv);
        final encodedData = encrypt.Encrypted.fromBase64(encrypted.base64);
        final decrypted = encrypter.decrypt(encodedData, iv: iv);
        CommonUtils.log("i", "${iv.base64} || Encrypted : $decrypted");
        return encrypted.base64;
      } else {
        CommonUtils.log("i", "encode error: Encrypted data is null");
        return "";
      }
    } catch (error) {
      CommonUtils.log("i", "encode error: $error");
      return "";
    }
  }

  static String decryptData(String resultString) {
    try {
      if (resultString != "") {
        final keyBytes = _getEnCodeKey();
        final key = encrypt.Key(Uint8List.fromList(keyBytes));
        var ivText = removeSpecialCharacters(FireBaseController.fcmToken).substring(0,16);
        final ivBytes = ivText.codeUnits;
        final iv = encrypt.IV(Uint8List.fromList(ivBytes));
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final encodedData = encrypt.Encrypted.fromBase64(resultString);
        final decrypted = encrypter.decrypt(encodedData, iv: iv);
        return decrypted;
      } else {
        CommonUtils.log("i", "decode error: Decrypted data is null");
        return "";
      }
    } catch (error) {
      CommonUtils.log("i", "decode error: $error");
      return "";
    }
  }

  static Uint8List _getEnCodeKey(){
    final keyBytes = Uint8List(16); // 16바이트 배열 생성
    final inputBytes = Uint8List.fromList(removeSpecialCharacters(FireBaseController.fcmToken).codeUnits);
    final inputLength = inputBytes.length;

    for (int i = 0; i < 16; i++) {
      if (i < inputLength) {
        keyBytes[i] = inputBytes[i];
      } else {
        keyBytes[i] = 'a'.codeUnitAt(0);
      }
    }

    return keyBytes;
  }

  static String removeSpecialCharacters(String text) {
    // 정규 표현식으로 특수 문자를 찾아 제거
    final regex = RegExp(r'[!@#%^&*(),.?":{}|<>]'); // 여기에 제거하고 싶은 특수 문자를 추가
    return text.replaceAll(regex, '');
  }

  static bool isValidStateByApiExpiredDate(){
    bool result = false;
    String thirtyMinutesLaterString = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceValidDateKey);
    if(thirtyMinutesLaterString != ""){
      // CommonUtils.log("i", "\ncurr:${CommonUtils.getCurrentLocalTime()}\nthir:${CommonUtils.convertStringToTime(thirtyMinutesLaterString)}");
      // CommonUtils.log("i", "isBefore : ${CommonUtils.getCurrentLocalTime().isBefore(CommonUtils.convertStringToTime(thirtyMinutesLaterString))}");
      result = CommonUtils.getCurrentLocalTime().isBefore(CommonUtils.convertStringToTime(thirtyMinutesLaterString));
    } else{
      result = false;
    }

    return result;
  }

  static bool isValidStateByInfoVersion(){
    bool result = false;
    String savedVersion = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceValidInfoVersion);
    if(savedVersion != ""){
      int infoVersionCode = Config.appInfoTextMap["info_text_version"];
      if(infoVersionCode > int.parse(savedVersion)){
        result = false;
      }else{
        result = true;
      }
    }else{
      result = false;
    }

    return result;
  }

  static bool isValidStateByInfoExpiredDate(){
    bool result = false;
    String thirtyMinutesLaterString = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceValidInfoDateKey);
    if(thirtyMinutesLaterString != ""){
      // CommonUtils.log("", "\ncurr:${CommonUtils.getCurrentLocalTime()}\nthir:${CommonUtils.convertStringToTime(thirtyMinutesLaterString)}");
      // CommonUtils.log("", "isBefore : ${CommonUtils.getCurrentLocalTime().isBefore(CommonUtils.convertStringToTime(thirtyMinutesLaterString))}");
      result = CommonUtils.getCurrentLocalTime().isBefore(CommonUtils.convertStringToTime(thirtyMinutesLaterString));
    }else{
      result = false;
    }

    return result;
  }

  static Future<File> get _localFile async {
    Directory directory = await getApplicationCacheDirectory();
    return File("${directory.path}/push_settings.json");
  }

  static Future<Map<String, dynamic>> readSettingsFromFile() async {
    final file = await _localFile;

    Map<String, dynamic> settings;
    try {
      final contents = await file.readAsString();
      settings = jsonDecode(contents);
    } catch (error) {
      settings = {
        "push_from": "",
        "push_room_id": ""
      };

      file.writeAsString(
        jsonEncode(settings),
      );
    }

    return settings;
  }

  static Future<void> saveSettingsToFile<T>(String key, T value) async {
    final file = await _localFile;
    Map<String, dynamic> settings = await readSettingsFromFile();

    settings.containsKey(key)
        ? settings[key] = value
        : settings.addAll({key: value});

    await file.writeAsString(
      jsonEncode(settings),
    );
  }

  static Future<(List<int>, String)> getFileBytesAndName(Object? file) async {
    List<int> bytes;
    String fileName;

    if (file is XFile) {
      bytes = await file.readAsBytes();
      fileName = file.name;
    } else if (file is File) {
      bytes = await file.readAsBytes();
      fileName = file.path.split('/').last;
    } else if (file is PlatformFile) {
      if (kIsWeb) {
        bytes = file.bytes!;
      } else {
        bytes = await _getFileBytes(file);
      }
      fileName = file.name;
    } else {
      throw Exception('Invalid file type');
    }
    return (bytes, fileName);
  }

  static Future<List<int>> _getFileBytes(PlatformFile platformFile) async {
    // Get the file path from the PlatformFile object
    String? filePath = platformFile.path;

    // Read the file as bytes, File is from the dart:io library
    File file = File(filePath!);
    List<int> fileBytes = await file.readAsBytes();

    return fileBytes;
  }

  static Future<void> printSettingsFromFile() async {
    final file = await _localFile;

    Map<String, dynamic> settings;
    try {
      final contents = await file.readAsString();
      settings = jsonDecode(contents);
      CommonUtils.log("w", "print settings : ${jsonEncode(settings)}");
    } catch (error) {
      CommonUtils.log("w", "readSettingsFromFile error : $error");
      settings = {
        "push_from": "",
        "push_room_id": ""
      };

      file.writeAsString(
        jsonEncode(settings),
      );
    }
  }
}