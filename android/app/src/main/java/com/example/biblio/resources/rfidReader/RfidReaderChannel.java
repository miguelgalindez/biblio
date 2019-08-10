package com.example.biblio.resources.rfidReader;

import android.view.KeyEvent;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.view.FlutterView;
import com.example.biblio.resources.rfidReader.RfidReader.DataCallback;
import com.example.biblio.resources.rfidReader.RfidReader.StartInventoryCallback;
import com.example.biblio.resources.rfidReader.RfidReader.StopInventoryCallback;

public class RfidReaderChannel {
    private static final String METHOD_CHANNEL ="biblio/rfidReader/methodChannel";

    private MethodChannel methodChannel;
    private RfidReader rfidReader;

    public RfidReaderChannel(FlutterView flutterView){
        methodChannel = new MethodChannel(flutterView, METHOD_CHANNEL);
        methodChannel.setMethodCallHandler(buildMethodCallHandler());
        // TODO Add implementation selector
        rfidReader = new AlienH450(buildDataCallback(), buildStartInventoryCallback(), buildStopInventoryCallback());
    }

    private MethodCallHandler buildMethodCallHandler(){
        return (methodCall, result) -> {
            if(rfidReader!=null){
                try {
                    switch (methodCall.method) {
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
                    result.error(null, ex.getMessage(), null);
                }
            } else{
                result.error(null, "The reader couldn't be initialized", null);
            }
        };
    }

    private DataCallback buildDataCallback(){
        return tags -> methodChannel.invokeMethod("onData", tags);
    }

    private StartInventoryCallback buildStartInventoryCallback(){
        return ()-> methodChannel.invokeMethod("onInventoryStarted", null);
    }

    private StopInventoryCallback buildStopInventoryCallback(){
        return ()-> methodChannel.invokeMethod("onInventoryStopped", null);
    }


    public void destroy(){
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
