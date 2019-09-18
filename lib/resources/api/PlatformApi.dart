import 'package:biblio/models/ApiResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PlatformApi {
  final MethodChannel methodChannel;

  PlatformApi({@required String methodChannelID})
      : methodChannel = MethodChannel(methodChannelID);

  set methodCallHandler(Function handler) {
    methodChannel.setMethodCallHandler(handler);
  }

  Future<ApiResponse> _invokeMethod(String methodName,
      [dynamic arguments]) async {
    try {
      Object result = await methodChannel.invokeMethod(methodName, arguments);
      return ApiResponse(hasError: false, content: result);
    } on Exception catch (e) {
      return ApiResponse(hasError: true, content: e.toString());
    }
  }

  Future<Object> invokeMethodAnGetResult(String methodName,
      [dynamic arguments]) async {

    ApiResponse response = await _invokeMethod(methodName, arguments);

    if (!response.hasError) {
      return response.content;
    }
    return null;
  }

  Future<void> invokeMethodWithCallbacks(
      String methodName, Function onSuccess, Function onError,
      [dynamic arguments]) async {
    ApiResponse response = await _invokeMethod(methodName, arguments);

    if (!response.hasError && onSuccess != null) {
      onSuccess(response.content);
    } else if (response.hasError && onError != null) {
      print(
          '[RfidReaderRepository] Error invoking RFID reader method: $methodName. Error description: ${response.content}');
      onError(response.content);
    }
  }
}
