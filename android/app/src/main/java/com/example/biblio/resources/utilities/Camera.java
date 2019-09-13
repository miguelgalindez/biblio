package com.example.biblio.resources.utilities;

import android.content.Context;
import android.content.pm.PackageManager;

public class Camera {

    public static boolean isDeviceCapable(Context context){
        return context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA);
    }
}
