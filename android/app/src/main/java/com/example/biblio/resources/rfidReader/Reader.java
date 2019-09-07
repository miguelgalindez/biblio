package com.example.biblio.resources.rfidReader;

import android.util.Log;
import android.view.KeyEvent;

import com.example.biblio.resources.EventCallback;
import org.jetbrains.annotations.NotNull;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public abstract class Reader {
    /**
     * Enumeration of well-known (standard) states for every reader
     */
    protected enum Status {
        CLOSED(0),
        OPENED(1),
        INVENTORY_STARTED(2),
        INVENTORY_STOPPED(3);

        private final int statusCode;
        Status(int statusCode){
            this.statusCode=statusCode;
        }
    }

    /**
     * The received signal strength in dBm at 1 metre.
     * Every reader must be calibrated to get this value.
     */
    protected Double rssiAtOneMeter;

    /**
     * Code for the reader trigger key. If the device
     * doesn't have a physical trigger key, then this
     * must be null
     */
    private Integer triggerKeyCode;

    /**
     * Defines the function that will be called when
     * there're tags ready to send
     */
    private EventCallback<List<Map<String, String>>> onDataCallback;

    /**
     * Defines the function that will be called when the
     * reader status has changed
     */
    protected EventCallback<Integer> onStatusChangedCallback;

    /**
     * Indicates the maximum number of tags the
     * reader can send using the provided callback (onDataCallback).
     * When the callback sends data through
     * a method channel, the application crashes if
     * the data is too big. To avoid that, whenever the number
     * of read tags reach this limit, the callback is
     * invoked with the tags read so far, and the
     * collection of read tags is cleared to allow further data.
     */
    private Integer sendingCapacity;

    /**
     * Holds the last reported status
     */
    protected Status currentStatus;

    /**
     * Variable that holds read tags.
     * Every tag must be stored as a map that holds one entry for
     * each tag property and its corresponding value. Every tag
     * (casted as a map) is going to be put into an indexed
     * HashMap for improving the searching of duplicates
     * */
    protected HashMap<String, Map<String, String>> readTags;

    /**
     * Indicates if there are tags without reporting.
     */
    private boolean areThereUnreportedTags;



    public Reader(@NotNull EventCallback<List<Map<String, String>>> onDataCallback, EventCallback<Integer> onStatusChangedCallback, Double rssiAtOneMeter, Integer sendingCapacity, Integer triggerKeyCode) {
        this.onDataCallback=onDataCallback;
        this.onStatusChangedCallback =onStatusChangedCallback;
        this.rssiAtOneMeter=rssiAtOneMeter;
        this.sendingCapacity=sendingCapacity;
        this.triggerKeyCode=triggerKeyCode;
        readTags=new HashMap<>();
        changeStatus(Status.CLOSED);
    }


    /**
     * Tries to initialize the RFID reader.
     * It is specific to each RFID reader model
     */
    protected abstract void initReader() throws Exception;

    /**
     * Tries to destroy the RFID reader.
     * It is specific to each RFID reader model
     */
    protected abstract void destroyReader() throws Exception;

    /**
     * Asks the RFID reader to run the continuous tags scanning
     * @param onTagReadCallback Function that's gonna be executed
     *                          every time a tag is read
     */
    protected abstract void runScanning(EventCallback<Tag> onTagReadCallback) throws Exception;

    /**
     * Asks the RFID reader to stop the continuous tags scanning
     */
    protected abstract void stopScanning() throws Exception;

    /**
     * Clean the RFID reader session (if exists).
     */
    protected abstract void cleanSession();


    /**
     * Sets the RFID reader transmit power
     * @param power Power attenuation in dBm
     */
    public abstract void setPower(int power) throws Exception;

    /**
     * Returns the RFID reader transmit power
     * @return Power attenuation in dBm
     */
    public abstract int getPower() throws Exception;


    /**
     * Tries to open the RFID reader.
     */
    public void open() throws Exception {
        initReader();
        changeStatus(Status.OPENED);
    }

    /**
     * Tries to close the RFID reader.
     */
    public void close() throws Exception{
        readTags.clear();
        cleanSession();
        destroyReader();
        changeStatus(Status.CLOSED);
    }

    /**
     * Tries to start the inventory
     */
    public void startInventory() throws Exception {
        runScanning(this::processReadTag);
        changeStatus(Status.INVENTORY_STARTED);
    }


    /**
     * Tries to stop the inventory.
     * To avoid reporting inaccurate states, it must follow
     * these steps (in strict order):
     *      1. Stop scanning
     *      2. Send tags
     *      3. Report "Inventory stopped" status
     */
    public void stopInventory() throws Exception {
        stopScanning();
        sendTags();
        changeStatus(Status.INVENTORY_STOPPED);
    }

    /**
     * Processes the tag received as parameter.
     * Depending whether the tag has been already read or not,
     * it's going to add this tag to the collection or to
     * update its previous rssi.
     * @param tag tag to be processed
     */
    private void processReadTag(Tag tag){
        Map<String, String> previouslyReadTag=readTags.get(tag.getEpc());

        // Tag will be added only if it has not already been read
        if(tag.getEpc()!=null && !tag.getEpc().isEmpty() && previouslyReadTag==null) {
            HashMap<String, String> tagAsMap = new HashMap<>();
            tagAsMap.put("epc", tag.getEpc());
            tagAsMap.put("rssi", String.valueOf(tag.getRssi()));

            addTag(tagAsMap);

        }

        // But if the tag has already been read, then its RSSI value will be updated
        // if the current reading have a greater RSSI value
        else if(previouslyReadTag!=null){
            String previousRSSIasString=previouslyReadTag.get("rssi");
            double previousRSSI = previousRSSIasString !=null ? Double.parseDouble(previousRSSIasString) : 0.0;
            double currentRSSI=tag.getRssi();
            if(currentRSSI>previousRSSI){
                previouslyReadTag.put("rssi", String.valueOf(currentRSSI));
            }
        }
    }


    /**
     * Adds a tag to the readTags collection. Avoids duplicated tags
     * and sends the read tags when they have been reached the sending
     * capacity (if that limit exists).
     * @param tag HashMap that contains the tag's data to be added.
     */
    private void addTag(Map<String, String> tag) {
        String tagEPC=tag.get("epc");

        // Checking if the tag has the epc property and if it hasn't been previously read (to avoid duplicated tags in the collection)
        if(tagEPC!=null && !tagEPC.isEmpty() && readTags.get(tagEPC)==null){
            readTags.put(tagEPC, tag);
            areThereUnreportedTags =true;

            // Checking if the number of read tags has reached the sending capacity.
            // If so, it sends the data through the callback.
            if(sendingCapacity!=null && sendingCapacity>0 && readTags.size()==sendingCapacity) {
                sendTags();
                readTags.clear();
                cleanSession();
            }
        } else{
            Log.e(null, "Missing epc property in the read tag. Skipping that tag...");
        }
    }

    /**
     * Sends the read tags so far. Also, it clears the collection of read tags
     * and the reader session (if exists) to allow further tags to be read and send
     */
    public void sendTags(){
        if(readTags!=null && !readTags.isEmpty() && areThereUnreportedTags) {
            onDataCallback.trigger(getReadTagsAsList());
            areThereUnreportedTags=false;
        }
    }

    /**
     * Replaces the reader status with the new one received as parameter
     * @param status Any of the different states defined by the Status enum
     */
    private void changeStatus(Status status){
        this.currentStatus=status;
        reportCurrentStatus();
    }

    /**
     * Reports/Notifies the current reader status by using the
     * "onStatusChanged" callback
     */
    public void reportCurrentStatus() {
        onStatusChangedCallback.trigger(this.currentStatus.statusCode);
    }


    /**
     * Catches key down events and checks whether the reader trigger key was pressed.
     * If so, it starts the inventory and returns true indicating that the event was
     * successfully handled and there's no need for it to be propagated any more.
     * @param keyCode Code of the key that has been pressed
     * @param event Corresponding event object
     * @return true or false indicating if the event was successfully handle or not.
     */
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        boolean triggerWasPressed=triggerKeyCode!=null && keyCode==triggerKeyCode;
        if(triggerWasPressed) {
            boolean canBeStarted = currentStatus == Status.OPENED && currentStatus != Status.INVENTORY_STARTED;

            if (event.getRepeatCount() == 0 && canBeStarted) {
                try {
                    startInventory();
                } catch (Exception ex) {
                    Log.e(null, ex.getMessage());
                }
            }
        }
        return triggerWasPressed;
    }


    /**
     * Catches key up events and checks whether the reader trigger key was released (unpressed).
     * If so, it stops the inventory and returns true indicating that the event was
     * successfully handled and there's no need for it to be propagated any more.
     * @param keyCode Code of the key that has been released (unpressed)
     * @return true or false indicating if the event was successfully handle or not.
     */
    public boolean onKeyUp(int keyCode) {
        boolean triggerWasReleased=triggerKeyCode != null && keyCode == triggerKeyCode;
        if(triggerWasReleased) {
            boolean canBeStopped = currentStatus == Status.OPENED && currentStatus != Status.INVENTORY_STOPPED;
            if (canBeStopped) {
                try {
                    stopInventory();
                } catch (Exception ex) {
                    Log.e(null, ex.getMessage());
                }
            }
        }
        return triggerWasReleased;
    }

    /**
     * Returns the collection of read tags
     * @return Read tags as a list
     */
    private List<Map<String, String>> getReadTagsAsList(){
        return new ArrayList<>(readTags.values());
    }

    public Double getRssiAtOneMeter() {
        return rssiAtOneMeter;
    }
}


