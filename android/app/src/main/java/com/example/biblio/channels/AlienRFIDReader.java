package com.example.biblio.channels;

import android.util.Log;
import android.view.KeyEvent;
import com.alien.common.KeyCode;
import com.alien.rfid.RFID;
import com.alien.rfid.RFIDReader;
import com.alien.rfid.ReaderException;
import com.alien.rfid.Tag;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

public class AlienRFIDReader {
    private static final String METHOD_CHANNEL ="biblio/rfidReader/methodChannel";
    private static final String ERROR_ID="AlienRFIDReaderError";
    private RFIDReader reader;
    private boolean readerIsOpened;
    private MethodChannel methodChannel;
    private HashMap<String, Map<String, String>> readTags;

    /**
     * TODO: add a boolean property that indicates whether the reader
     * was properly initialized or not, and use it for onKey handlers
     */

    public AlienRFIDReader(FlutterView flutterView){
        readerIsOpened=openReader();
        methodChannel = new MethodChannel(flutterView, METHOD_CHANNEL);
        methodChannel.setMethodCallHandler(buildMethodCallHandler());
        readTags=new HashMap<>();
    }

    private boolean openReader(){
        try {
            reader = RFID.open();
            return true;
        } catch (Exception ex){
            Log.e(ERROR_ID, "Reader couldn't be opened");
        }
        return false;
    }

    public void destroy(){
        /**
         * TODO: What else is needed to destroy a reader? See docs
         */
        if(reader!=null) {
            reader.close();
            readerIsOpened=false;
        }
    }

    private MethodChannel.MethodCallHandler buildMethodCallHandler(){
        return (methodCall, result) -> {
            if(readerIsOpened){
                try {
                    switch (methodCall.method) {
                        case "startInventory":
                            startInventory();
                            break;
                        case "stopInventory":
                            stopInventory();
                            break;

                        default:
                            result.notImplemented();
                            return;
                    }
                    result.success("Method: "+methodCall.method+" was successfully called");

                } catch (Exception ex) {
                    result.error(ERROR_ID, ex.getMessage(), null);
                }
            } else{
                result.error(ERROR_ID, "The reader couldn't be initialized", null);
            }
        };
    }

    private void startInventory() throws ReaderException {

        if(!reader.isRunning()){
            reader.inventory(this::processTag);
            Log.d("AlienRFIDReader", "Inventory started");
        } else{
            throw new ReaderException("The inventory couldn't be started because the reader is bussy");
        }
    }

    private void processTag(final Tag tag){
        Log.d("AlienRFIDReader", "EPC: " + tag.getEPC() + " PC: " + tag.getPC() + " TID: " + tag.getTID() + " RSSI: " + tag.getRSSI());

        Map<String, String> tagAsMap=new HashMap<>();
        tagAsMap.put("epc", tag.getEPC());
        tagAsMap.put("pc", tag.getPC());
        tagAsMap.put("tid", tag.getTID());
        tagAsMap.put("rssi", String.valueOf(tag.getRSSI()));

        readTags.put(tag.getEPC(), tagAsMap);
    }

    private void stopInventory() throws ReaderException {
        if (reader != null) {
            List<Map<String, String>> tags=new ArrayList<>(readTags.values());
            /*List<String> tags=new ArrayList<>();
            tags.add("Hello");
            tags.add("world");*/
            methodChannel.invokeMethod("onTagRead", tags);
            reader.stop();
            Log.d("AlienRFIDReader", "Inventory stopped");
        } else {
            throw new ReaderException("The inventory couldn't be stopped because the reader is null");
        }
    }

    public boolean onKeyDown(int keyCode, KeyEvent event) {
        try {
            if (keyCode == KeyCode.ALR_H450.SCAN && event.getRepeatCount() == 0) {
                startInventory();
                return true;
            }
        } catch(Exception ex){
            Log.e(ERROR_ID, ex.getMessage());
        }

        return false;
    }

    public boolean onKeyUp(int keyCode, KeyEvent event) {
        try {
            if (keyCode == KeyCode.ALR_H450.SCAN) {
                stopInventory();
                return true;
            }
        } catch(Exception ex){
            Log.e(ERROR_ID, ex.getMessage());
        }

        return false;
    }
}
