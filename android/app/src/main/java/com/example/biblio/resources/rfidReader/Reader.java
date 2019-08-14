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
     * Code for the reader trigger key. If the device
     * doesn't have a physical trigger key, then this
     * must be null
     */
    private Integer triggerKeyCode;

    /**
     * Defines the function that will be called when
     * there're tags ready to send
     */
    private EventCallback onDataCallback;

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
     * Defines the function that will be called when the
     * reader status has changed
     */
    protected EventCallback onStatusChangedCallback;


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
     * Variable that holds read tags.
     * Every tag must be stored as a map that holds one entry for
     * each tag property and its corresponding value. Every tag
     * (casted as a map) is going to be put into an indexed
     * HashMap for improving the searching of duplicates
     * */
    // FIXME: Check for concurrency risks over readTags when the tags are send (it implies cleaning readTags) while the reader is running.
    protected HashMap<String, Map<String, String>> readTags;



    public Reader(@NotNull EventCallback onDataCallback, EventCallback onStatusChangedCallback, Integer sendingCapacity, Integer triggerKeyCode) {
        this.onDataCallback=onDataCallback;
        this.sendingCapacity=sendingCapacity;
        this.onStatusChangedCallback =onStatusChangedCallback;
        this.triggerKeyCode=triggerKeyCode;
        readTags=new HashMap<>();
        reportStatus(Status.CLOSED);
    }

    /**
     * Tries to open the reader.
     */
    protected abstract void open() throws Exception;

    /**
     * Tries to close the reader.
     */
    protected abstract void close() throws Exception;

    /**
     * Clean the reader session (if exists)
     */
    protected abstract void cleanSession();

    /**
     * Close the reader and release all the held resources.
     */
    public void destroy(){
        try {
            readTags.clear();
            close();
        } catch(Exception ex){
            Log.e(null, "Error trying to destroy the reader");
        }
    }

    /**
     * Tries to start the inventory scanning
     */
    public abstract void startInventory() throws Exception;

    /**
     * Tries to stop the inventory scanning
     */
    public abstract void stopInventory() throws Exception;


    /**
     * Adds a tag to the readTags collection. Avoids duplicated tags
     * and sends the read tags when they have been reached the sending
     * capacity (if that limit exists).
     * @param tag HashMap that contains the tag's data to be added.
     */
    protected void addTag(Map<String, String> tag) {
        String tagEPC=tag.get("epc");

        // Checking if the tag has the epc property and if it hasn't been previously read (to avoid duplicated tags in the collection)
        if(tagEPC!=null && !tagEPC.isEmpty() && readTags.get(tagEPC)==null){
            readTags.put(tagEPC, tag);

            // Checking if the number of read tags has reached the sending capacity.
            // If so, it sends the data through the callback.
            if(sendingCapacity!=null && sendingCapacity>0 && readTags.size()==sendingCapacity) {
                sendTags();
            }

        } else{
            Log.e(null, "Missing epc property in the read tag. Skipping that tag...");
        }
    }

    /**
     * Sends the read tags so far. Also, it clears the collection of read tags
     * and the reader session (if exists) to allow further tags to be read and send
     */
    protected void sendTags(){
        onDataCallback.trigger(getReadTagsAsList());
        readTags.clear();
        cleanSession();
    }

    /**
     * Notifies the new reader status by using the on status changed callback
     * @param status Any of the different states defined by the Status enum
     */
    protected void reportStatus(Status status){
        onStatusChangedCallback.trigger(status.statusCode);
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
        if(triggerWasPressed && event.getRepeatCount() == 0){
            try{
                startInventory();
            } catch(Exception ex){
                Log.e(null, ex.getMessage());
            }
        }
        return triggerWasPressed;
    }


    /**
     * Catches key up events and checks whether the reader trigger key was released (unpressed).
     * If so, it stops the inventory and returns true indicating that the event was
     * successfully handled and there's no need for it to be propagated any more.
     * @param keyCode Code of the key that has been released (unpressed)
     * @param event Corresponding event object
     * @return true or false indicating if the event was successfully handle or not.
     */
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        boolean triggerWasReleased=triggerKeyCode != null && keyCode == triggerKeyCode;
        if (triggerWasReleased){
            try {
                stopInventory();
            } catch (Exception ex) {
                Log.e(null, ex.getMessage());
            }
        }
        return triggerWasReleased;
    }

    /**
     * Returns the collection of read tags
     * @return Read tags as a list
     */
    protected List<Map<String, String>> getReadTagsAsList(){
        return new ArrayList<>(readTags.values());
    }
}


