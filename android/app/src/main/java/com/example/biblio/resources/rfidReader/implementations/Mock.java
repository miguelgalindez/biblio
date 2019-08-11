package com.example.biblio.resources.rfidReader.implementations;

import com.example.biblio.resources.rfidReader.Reader;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

public class Mock extends Reader {

    private static final int SENDING_CAPACITY=50;

    /**
     * Initializing mock data
     */
    private static final HashMap<String, Map<String, String>> mockReadTags=new HashMap<>();
    static{
        for(int i=0; i<SENDING_CAPACITY; i++){
            Map<String, String> mockTag=new HashMap<>();
            mockTag.put("epc", "Test-EPC-"+i);
            mockTag.put("pc", "");
            mockTag.put("tid", "");
            mockTag.put("rssi", "Test-RSSI-"+i);
            mockReadTags.put(mockTag.get("epc"), mockTag);
        }
    }

    public Mock(@NotNull DataCallback dataCallback, StartInventoryCallback startInventoryCallback, StopInventoryCallback stopInventoryCallback){
        super(dataCallback, startInventoryCallback, stopInventoryCallback, SENDING_CAPACITY,  null);
    }


    /**
     * Tries to open the reader.
     */
    @Override
    protected void open() {

    }

    /**
     * Tries to close the reader.
     */
    @Override
    protected void close() {

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
        startInventoryCallback.onInventoryStartedCallback();

        // Mocking tags scanning
        for(Map.Entry<String, Map<String, String>> entry : mockReadTags.entrySet()){
            addTag(entry.getValue());
        }
    }

    /**
     * Tries to stop the inventory scanning
     */
    @Override
    public void stopInventory() throws Exception {
        stopInventoryCallback.onInventoryStoppedCallback();
        sendTags();
    }


}
