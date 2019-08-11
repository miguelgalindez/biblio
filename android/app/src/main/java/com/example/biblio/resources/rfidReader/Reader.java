package com.example.biblio.resources.rfidReader;

import android.util.Log;
import android.view.KeyEvent;
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
    private DataCallback onDataCallback;

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
     * Defines the function that will be called when the inventory
     * scanning is started
     */
    protected StartInventoryCallback startInventoryCallback;

    /**
     * Defines the function that will be called when the inventory
     * scanning is started
     */
    protected StopInventoryCallback stopInventoryCallback;

    /**
     * Variable that holds read tags.
     * Every tag must be stored as a map that holds one entry for
     * each tag property and its corresponding value. Every tag
     * (casted as a map) is going to be put into an indexed
     * HashMap for improving the searching of duplicates
     * */
    protected HashMap<String, Map<String, String>> readTags;

    // FIXME: Check for concurrency risks over readTags when the tags are send (it implies cleaning readTags) while the reader is running.

    public Reader(@NotNull DataCallback dataCallback, StartInventoryCallback startInventoryCallback, StopInventoryCallback stopInventoryCallback, Integer sendingCapacity, Integer triggerKeyCode) {
        this.onDataCallback=dataCallback;
        this.sendingCapacity=sendingCapacity;
        this.startInventoryCallback=startInventoryCallback;
        this.stopInventoryCallback=stopInventoryCallback;
        this.triggerKeyCode=triggerKeyCode;
        readTags=new HashMap<>();
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
        onDataCallback.onData(getReadTagsAsList());
        readTags.clear();
        cleanSession();
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

    protected List<Map<String, String>> getReadTagsAsList(){
        return new ArrayList<>(readTags.values());
    }

    /**
     * Interface that holds the callback for data sending
     */
    public interface DataCallback {
        void onData(List<Map<String, String>> tags);
    }

    /**
     * Interface that defines the callback that will be
     * called when the inventory scanning is started
     */
    public interface StartInventoryCallback {
        void onInventoryStartedCallback();
    }

    /**
     * Interface that defines the callback that will be
     * called when the inventory scanning is stopped
     */
    public interface StopInventoryCallback {
        void onInventoryStoppedCallback();
    }
}


