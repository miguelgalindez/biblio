package com.example.biblio.resources.rfidReader;

import android.view.KeyEvent;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.FlutterView;

public class RfidReaderChannel {
    private static final String CHANNEL_ID ="biblio/rfidReader";

    private MethodChannel methodChannel;
    private RfidReader rfidReader;

    public RfidReaderChannel(FlutterView flutterView){
        methodChannel = new MethodChannel(flutterView, CHANNEL_ID);
        methodChannel.setMethodCallHandler(this::methodCallHandler);
        rfidReader = RfidReaderImplementationSelector.getImplementation(this::onDataCallback, this::onStatusChangedCallback);
    }

    private void methodCallHandler(MethodCall methodCall, Result result){
        try {
            switch (methodCall.method) {
                case "reportCurrentStatus":
                    rfidReader.reportCurrentStatus();
                    break;

                case "getPower":
                    result.success(rfidReader.getPower());
                    return;

                case  "getRssiAtOneMeter":
                    result.success(rfidReader.getRssiAtOneMeter());
                    return;

                case "open":
                    rfidReader.open();
                    break;

                case "close":
                    rfidReader.close();
                    break;

                case "startInventory":
                    rfidReader.startInventory();
                    break;

                case "stopInventory":
                    rfidReader.stopInventory();
                    break;

                case "sendTags":
                    rfidReader.sendTags();
                    break;

                case "clear":
                    rfidReader.clear();
                    break;

                case "discardTag":
                    rfidReader.discardTag((String) methodCall.arguments);
                    break;

                default:
                    result.notImplemented();
                    return;
            }

            result.success(null);

        } catch (Exception ex) {
            result.error("RFIDReaderChannel", ex.getMessage(), null);
        }
    }

    /**
     * Callback that is going to be invoked when
     * the reader has send data. In this case, the Flutter
     * listener will be notified about the new read tags
     */

    private void onDataCallback(List<Map<String, String>> tags){
        methodChannel.invokeMethod("onTagsRead", tags);
    }

    /**
     * Callback that is going to be invoked when
     * the reader status has changed. In this case, the Flutter
     * listener will be notified about the new reader status
     */
    private void onStatusChangedCallback(int status){
        methodChannel.invokeMethod("onStatusChanged", status);
    }

    /**
     * Destroys the method channel and releases resources
     */
    public void destroy(){
        if(rfidReader!=null) {
            try {
                rfidReader.close();
            } catch(Exception ignored) {}
        }
    }

    /**
     * Catches key down events
     * @param keyCode Code of the key that has been pressed
     * @param event Corresponding event object
     * @return true or false indicating if the event was successfully handle or not.
     */
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if(rfidReader!=null) {
            return rfidReader.onKeyDown(keyCode, event);
        }
        return false;
    }


    /**
     * Catches key up events
     * @param keyCode Code of the key that has been released (unpressed)
     * @return true or false indicating if the event was successfully handle or not.
     */
    public boolean onKeyUp(int keyCode) {
        if(rfidReader!=null) {
            return rfidReader.onKeyUp(keyCode);
        }
        return false;
    }
}
