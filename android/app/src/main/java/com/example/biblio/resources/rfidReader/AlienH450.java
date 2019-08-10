package com.example.biblio.resources.rfidReader;

import android.util.Log;

import com.alien.common.KeyCode;
import com.alien.rfid.RFID;
import com.alien.rfid.RFIDReader;
import org.jetbrains.annotations.NotNull;
import java.util.HashMap;

public class AlienH450 extends RfidReader {

    private static final int TRIGGER_KEY_CODE=KeyCode.ALR_H450.SCAN;
    private static final int SENDING_CAPACITY=50;

    private RFIDReader reader;

    public AlienH450(@NotNull DataCallback dataCallback, StartInventoryCallback startInventoryCallback, StopInventoryCallback stopInventoryCallback){
        super(dataCallback, startInventoryCallback, stopInventoryCallback, SENDING_CAPACITY,  TRIGGER_KEY_CODE);
    }


    /**
     * Tries to initialize the reader.
     */
    @Override
    protected void init(){
        try{
            reader= RFID.open();
        } catch(Exception ex){
            Log.e(null, "AlienH450 couldn't be initialized");
        }
    }


    /**
     * Release all the resources held by the reader
     */
    @Override
    public void destroy() {

        // TODO: What else is needed to destroy a reader? See docs
        if(reader!=null){
            reader.close();
        }
    }

    /**
     * Clean the reader session (if exists)
     */
    @Override
    protected void cleanSession() {

    }

    /**
     * Tries to start the inventory scanning
     */
    @Override
    public void startInventory() throws Exception {
        if(!reader.isRunning()){
            reader.inventory(tag -> {
                HashMap<String, String> tagAsMap = new HashMap<>();
                tagAsMap.put("epc", tag.getEPC());
                tagAsMap.put("pc", tag.getPC());
                tagAsMap.put("tid", tag.getTID());
                tagAsMap.put("rssi", String.valueOf(tag.getRSSI()));

                addTag(tagAsMap);
            });
            startInventoryCallback.onInventoryStartedCallback();

        } else{
            throw new Exception("The inventory scanning couldn't be started because the reader is bussy.");
        }
    }

    /**
     * Tries to stop the inventory scanning
     */
    @Override
    public void stopInventory() throws Exception {
        if(reader!=null){
            reader.stop();
            stopInventoryCallback.onInventoryStoppedCallback();
            sendTags();
        } else {
            throw new Exception("The inventory scanning couldn't be stopped because the reader is null");
        }
    }
}
