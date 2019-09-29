package com.example.biblio.resources.utilities;

import android.content.Context;

import com.example.biblio.resources.rfidReader.RfidReaderImplementationSelector;

import java.util.ArrayList;

public class DeviceCapabilities {
    private static ArrayList<String> capabilities;

    public static ArrayList<String> getCapabilities(Context context) {
        if(capabilities==null || capabilities.isEmpty()) {
            lookUpCapabilities(context);
        }
        return capabilities;
    }

    private static void lookUpCapabilities(Context context){
        capabilities=new ArrayList<>();

        if(RfidReaderImplementationSelector.isDeviceCapable()){
            capabilities.add("rfidTagsReading");
        }

        if(Camera.isDeviceCapable(context)){
            capabilities.add("camera");
        }
    }
}
