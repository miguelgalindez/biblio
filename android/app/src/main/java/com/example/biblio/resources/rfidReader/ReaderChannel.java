package com.example.biblio.resources.rfidReader;

import android.view.KeyEvent;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.FlutterView;

public class ReaderChannel {
    private static final String METHOD_CHANNEL ="biblio/rfidReader/methodChannel";
    private static final String TAG ="RFIDReaderChannel";

    private MethodChannel methodChannel;
    private Reader rfidReader;

    public ReaderChannel(FlutterView flutterView){
        methodChannel = new MethodChannel(flutterView, METHOD_CHANNEL);
        methodChannel.setMethodCallHandler(this::methodCallHandler);
        rfidReader = ImplementationSelector.getImplementation(this::onDataCallback, this::onStatusChangedCallback);
    }

    private void methodCallHandler(MethodCall methodCall, Result result){
        try {
            switch (methodCall.method) {

                case "deviceCanReadRfidTags":
                    // Indicates whether the current device is able to read RFID tags or not
                    result.success(rfidReader!=null);
                    return;

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
            result.error(TAG, ex.getMessage(), null);
        }
    }

    /**
     * Callback that is going to be invoked when
     * the reader has send data. In this case, the Flutter
     * listener will be notified about the new read tags
     */

    private void onDataCallback(List<Map<String, String>> tags){
        methodChannel.invokeMethod("onData", tags);
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
        // TODO: should i destroy the method channel?
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
        return rfidReader.onKeyDown(keyCode, event);
    }


    /**
     * Catches key up events
     * @param keyCode Code of the key that has been released (unpressed)
     * @return true or false indicating if the event was successfully handle or not.
     */
    public boolean onKeyUp(int keyCode) {
        return rfidReader.onKeyUp(keyCode);
    }
}
