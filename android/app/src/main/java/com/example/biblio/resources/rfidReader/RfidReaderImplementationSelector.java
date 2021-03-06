package com.example.biblio.resources.rfidReader;

import com.example.biblio.resources.EventCallback;
import com.example.biblio.resources.rfidReader.implementations.AlienH450;
import com.example.biblio.resources.rfidReader.implementations.Mock;

import java.util.List;
import java.util.Map;

public class RfidReaderImplementationSelector {

    private static final String DEVICE_MODEL=android.os.Build.MODEL;
    public static String PROJECT_STAGE;

    public static RfidReader getImplementation(EventCallback<List<Map<String, String>>> onDataCallback, EventCallback<Integer> onStatusChangedCallback){
        switch (DEVICE_MODEL){
            case "ALR-H450":
                return new AlienH450(onDataCallback, onStatusChangedCallback);

            default:
                if("development".equalsIgnoreCase(PROJECT_STAGE)){
                    return new Mock(onDataCallback, onStatusChangedCallback);
                }
                return null;
        }
    }

    public static boolean isDeviceCapable(){
        return getImplementation(null, null)!=null;
    }


}
