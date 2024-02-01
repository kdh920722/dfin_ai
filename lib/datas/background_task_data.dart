import 'dart:isolate';

class BackgroundTaskData {
  final SendPort sendPort;
  final String url;
  final String tokenHeader;
  final Map<String, dynamic> inputJson;

  BackgroundTaskData(this.sendPort, this.url, this.tokenHeader, this.inputJson);
}