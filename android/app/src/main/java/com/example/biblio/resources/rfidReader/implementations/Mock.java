package com.example.biblio.resources.rfidReader.implementations;

import com.example.biblio.resources.EventCallback;
import com.example.biblio.resources.rfidReader.RfidReader;
import com.example.biblio.resources.rfidReader.RfidTag;
import org.jetbrains.annotations.NotNull;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Mock extends RfidReader {
    private static final Double RSSI_AT_ONE_METER=-30.0;
    private static final int SENDING_CAPACITY=50;

    /**
     * Initializing mock data
     */
    private static final ArrayList<RfidTag> mockReadTags=new ArrayList<>();
    static{
        for(int i=0; i<SENDING_CAPACITY; i++){
            String mockEpc="Test-EPC-"+i;
            Double mockRssi=-60.0+i;
            mockReadTags.add(new RfidTag(mockEpc, mockRssi));
        }
    }

    public Mock(@NotNull EventCallback<List<Map<String, String>>> onDataCallback, EventCallback<Integer> onStatusChangedCallback){
        super(onDataCallback, onStatusChangedCallback, RSSI_AT_ONE_METER, SENDING_CAPACITY,  null);
    }


    /**
     * Tries to initialize the RFID reader.
     * It is specific to each RFID reader model
     */
    @Override
    protected void initReader() throws Exception{
        throw new Exception("Testing exception...");
    }

    /**
     * Tries to destroy the RFID reader.
     * It is specific to each RFID reader model
     */
    @Override
    protected void destroyReader() {

    }

    /**
     * Asks the RFID reader to run the continuous tags scanning
     *
     * @param onTagReadCallback Function that's gonna be executed
     *                          every time a tag is read
     */
    @Override
    protected void runScanning(EventCallback<RfidTag> onTagReadCallback){
        for(RfidTag tag : mockReadTags){
            onTagReadCallback.trigger(tag);
        }
    }

    /**
     * Asks the RFID reader to stop the continuous tags scanning
     */
    @Override
    protected void stopScanning(){

    }

    /**
     * Clean the RFID reader session (if exists).
     */
    @Override
    protected void cleanReaderSession() {

    }

    /**
     * Sets the RFID reader transmit power
     *
     * @param power Power attenuation in dBm
     */
    @Override
    public void setPower(int power) {

    }

    /**
     * Returns the RFID reader transmit power
     *
     * @return Power attenuation in dBm
     */
    @Override
    public int getPower() {
        return 0;
    }
}
