package com.example.biblio.resources.rfidReader;

import android.view.KeyEvent;

import com.example.biblio.resources.EventCallback;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.view.FlutterView;

public class ReaderChannel {
    private static final String METHOD_CHANNEL ="biblio/rfidReader/methodChannel";
    private static final String TAG ="RFIDReaderChannel";

    private MethodChannel methodChannel;
    private Reader rfidReader;

    public ReaderChannel(FlutterView flutterView){
        methodChannel = new MethodChannel(flutterView, METHOD_CHANNEL);
        methodChannel.setMethodCallHandler(buildMethodCallHandler());
        rfidReader = ImplementationSelector.getImplementation(buildOnDataCallback(), buildOnStatusChangedCallback());
    }

    private MethodCallHandler buildMethodCallHandler(){
        return (methodCall, result) -> {
            try {
                switch (methodCall.method) {

                    case "open":
                        rfidReader.open();
                        break;

                    case "close":
                        rfidReader.close();
                        break;

                    case "deviceCanReadRfidTags":
                        // Indicates whether the current device is able to read RFID tags or not
                        result.success(rfidReader!=null);
                        break;

                    case "startInventory":
                        rfidReader.startInventory();
                        break;

                    case "stopInventory":
                        rfidReader.stopInventory();
                        break;

                    default:
                        result.notImplemented();
                        return;
                }

                result.success(null);

            } catch (Exception ex) {
                result.error(TAG, ex.getMessage(), null);
            }

        };
    }

    /**
     * Defines the callback that is going to be invoked when
     * the reader has send data. In this case, the Flutter
     * listener will be notified about the new read tags
     * @return EventCallback instance
     */
    private EventCallback buildOnDataCallback(){
        return tags -> methodChannel.invokeMethod("onData", tags);
    }

    /**
     * Defines the callback that is going to be invoked when
     * the reader status has changed. In this case, the Flutter
     * listener will be notified about the new reader status
     * @return EventCallback instance
     */
    private EventCallback buildOnStatusChangedCallback(){
        return status -> methodChannel.invokeMethod("onStatusChanged", (int) status);
    }

    /**
     * Destroys the method channel and releases resources
     */
    public void destroy(){
        // TODO: should i destroy the method channel?
        rfidReader.destroy();
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
     * @param event Corresponding event object
     * @return true or false indicating if the event was successfully handle or not.
     */
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        return rfidReader.onKeyUp(keyCode, event);
    }
}
