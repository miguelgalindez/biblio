package com.example.biblio.resources.rfidReader.implementations;

import com.alien.common.KeyCode;
import com.alien.rfid.RFID;
import com.alien.rfid.RFIDReader;
import com.example.biblio.resources.EventCallback;
import com.example.biblio.resources.rfidReader.Reader;

import org.jetbrains.annotations.NotNull;
import java.util.HashMap;

public class AlienH450 extends Reader {

    private static final int TRIGGER_KEY_CODE=KeyCode.ALR_H450.SCAN;
    private static final int SENDING_CAPACITY=50;

    private RFIDReader reader;

    public AlienH450(@NotNull EventCallback onDataCallback, EventCallback onStatusChangedCallback){
        super(onDataCallback, onStatusChangedCallback, SENDING_CAPACITY,  TRIGGER_KEY_CODE);
    }


    /**
     * Tries to open the reader.
     */
    @Override
    protected void open() throws Exception {
        reader=RFID.open();
        reportStatus(Status.OPENED);
    }

    /**
     * Tries to close the reader.
     */
    @Override
    protected void close() throws Exception{
        if(reader!=null){
            if(reader.isRunning()) {
                reader.stop();
            }
            cleanSession();
            reader.close();
            reportStatus(Status.CLOSED);
        }
    }


    /**
     * Clean the reader session (if exists)
     */
    @Override
    protected void cleanSession() {
        // TODO: how to clean session in this device
    }

    /**
     * Tries to start the inventory scanning
     */
    @Override
    public void startInventory() throws Exception {
        if(reader!=null && !reader.isRunning()){
            reader.inventory(tag -> {
                String tagEPC=tag.getEPC();

                // Casting process will be executed only if the tag hasn't been previously read
                if(tagEPC!=null && !tagEPC.isEmpty() && readTags.get(tagEPC)==null) {
                    HashMap<String, String> tagAsMap = new HashMap<>();
                    tagAsMap.put("epc", tag.getEPC());
                    tagAsMap.put("pc", tag.getPC());
                    tagAsMap.put("tid", tag.getTID());
                    tagAsMap.put("rssi", String.valueOf(tag.getRSSI()));

                    addTag(tagAsMap);
                }
            });

            reportStatus(Status.INVENTORY_STARTED);

        } else if (reader==null){
            throw new Exception("The inventory scanning couldn't be started because the reader is null.");
        } else {
            throw new Exception("The inventory scanning couldn't be started because the reader is busy.");
        }
    }

    /**
     * Tries to stop the inventory scanning
     */
    @Override
    public void stopInventory() throws Exception {
        if(reader!=null){
            reader.stop();
            reportStatus(Status.INVENTORY_STOPPED);
            sendTags();
        } else {
            throw new Exception("The inventory scanning couldn't be stopped because the reader is null.");
        }
    }
}
