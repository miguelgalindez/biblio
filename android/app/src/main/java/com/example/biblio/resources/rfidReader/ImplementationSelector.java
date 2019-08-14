package com.example.biblio.resources.rfidReader;

import org.jetbrains.annotations.NotNull;


import com.example.biblio.resources.EventCallback;
import com.example.biblio.resources.rfidReader.implementations.AlienH450;
import com.example.biblio.resources.rfidReader.implementations.Mock;

public class ImplementationSelector {

    private static final String DEVICE_MODEL=android.os.Build.MODEL;
    public static String PROJECT_STAGE="production";

    public static Reader getImplementation(@NotNull EventCallback onDataCallback, EventCallback onStatusChangedCallback){
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


}
