package com.example.biblio.resources.utilities;

import android.content.Context;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.FlutterView;

public class UtilitiesChannel {
    private static final String CHANNEL_ID ="biblio/utilities";
    private MethodChannel methodChannel;
    private Context context;

    public UtilitiesChannel(FlutterView flutterView){
        context=flutterView.getContext();
        methodChannel=new MethodChannel(flutterView, CHANNEL_ID);
        methodChannel.setMethodCallHandler(this::methodCallHandler);
    }

    private void methodCallHandler(MethodCall methodCall, Result result){
        switch (methodCall.method){
            case "getDeviceCapabilities":
                result.success(DeviceCapabilities.getCapabilities(context));
                break;

            default:
                result.notImplemented();
        }
    }
}
