package com.example.biblio;

import android.os.Bundle;
import android.view.KeyEvent;

import com.example.biblio.resources.rfidReader.RfidReaderImplementationSelector;
import com.example.biblio.resources.rfidReader.RfidReaderChannel;
import com.example.biblio.resources.utilities.UtilitiesChannel;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  RfidReaderChannel rfidReaderChannel;
  UtilitiesChannel utilitiesChannel;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // Comment the following line on production
    RfidReaderImplementationSelector.PROJECT_STAGE="development";

    rfidReaderChannel= new RfidReaderChannel(getFlutterView());
    utilitiesChannel=new UtilitiesChannel(getFlutterView());
  }

  @Override
  public boolean onKeyUp(int keyCode, KeyEvent event) {
    boolean eventHandled=rfidReaderChannel.onKeyUp(keyCode);
    if(eventHandled)
      return true;
    else
    return super.onKeyUp(keyCode, event);
  }

  @Override
  public boolean onKeyDown(int keyCode, KeyEvent event) {
    boolean eventHandled=rfidReaderChannel.onKeyDown(keyCode, event);
    if(eventHandled)
      return true;
    else
      return super.onKeyDown(keyCode, event);

  }

  @Override
  protected void onDestroy() {
    rfidReaderChannel.destroy();
    super.onDestroy();
  }
}
