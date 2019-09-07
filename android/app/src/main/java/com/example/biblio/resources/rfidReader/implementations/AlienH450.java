package com.example.biblio.resources.rfidReader.implementations;

import com.alien.common.KeyCode;
import com.alien.rfid.RFID;
import com.alien.rfid.RFIDReader;
import com.example.biblio.resources.EventCallback;
import com.example.biblio.resources.rfidReader.Reader;
import com.example.biblio.resources.rfidReader.Tag;

import org.jetbrains.annotations.NotNull;

import java.util.List;
import java.util.Map;

public class AlienH450 extends Reader {

    private static final Double RSSI_AT_ONE_METER=-67.5;
    private static final int SENDING_CAPACITY=50;
    private static final int TRIGGER_KEY_CODE=KeyCode.ALR_H450.SCAN;

    private RFIDReader rfidReader;

    public AlienH450(@NotNull EventCallback<List<Map<String, String>>> onDataCallback, EventCallback<Integer> onStatusChangedCallback){
        super(onDataCallback, onStatusChangedCallback, RSSI_AT_ONE_METER, SENDING_CAPACITY, TRIGGER_KEY_CODE);
    }


    /**
     * Clean the rfidReader session (if exists).
     * It is highly recommended to clear the
     * read tags collection. To do that,
     * include the following line in this
     * method's implementation:
     *      readTags.clear();
     */
    @Override
    protected void cleanSession() {
        // TODO: how to clean session in this device
    }

    /**
     * Tries to initialize the RFID reader.
     * It is specific to each RFID reader model
     */
    @Override
    protected void initReader() throws Exception {
        if(rfidReader ==null) {
            rfidReader = RFID.open();
        } else{
            throw new Exception("RfidReader couldn't be opened because it has already been instantiated");
        }
    }

    /**
     * Tries to destroy the RFID reader.
     * It is specific to each RFID reader model
     */
    @Override
    protected void destroyReader() throws Exception {
        if(rfidReader !=null){
            if(rfidReader.isRunning()) {
                rfidReader.stop();
            }
            rfidReader.close();
            rfidReader =null;
        } else {
            throw new Exception("RfidReader couldn't be closed because it is null");
        }
    }

    /**
     * Asks the RFID reader to run the continuous tags scanning
     *
     * @param onTagReadCallback Function that's gonna be executed
     *                          every time a tag is read
     */
    @Override
    protected void runScanning(EventCallback<Tag> onTagReadCallback) throws Exception {
        if(rfidReader !=null && !rfidReader.isRunning()) {
            rfidReader.inventory((com.alien.rfid.Tag tag) -> onTagReadCallback.trigger(new Tag(tag.getEPC(), tag.getRSSI())));
        } else if (rfidReader ==null){
            throw new Exception("The inventory scanning couldn't be started because the rfidReader is null.");
        } else {
            throw new Exception("The inventory scanning couldn't be started because the rfidReader is busy.");
        }
    }

    /**
     * Asks the RFID Reader to stop the continuous tags scanning
     */
    @Override
    protected void stopScanning() throws Exception {
        if(rfidReader !=null){
            rfidReader.stop();
        } else {
            throw new Exception("The inventory scanning couldn't be stopped because the rfidReader is null.");
        }
    }

    /**
     * Sets the rfidReader transmit power
     * @param power Power attenuation in dBm
     */
    @Override
    public void setPower(int power) throws Exception {
        rfidReader.setPower(power);
    }

    /**
     * Returns the rfidReader transmit power
     * @return Power attenuation in dBm
     */
    @Override
    public int getPower() throws Exception {
        return rfidReader.getPower();
    }
}
