package com.example.biblio;

import android.os.Bundle;
import android.view.KeyEvent;

import com.example.biblio.resources.rfidReader.RfidReaderChannel;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  RfidReaderChannel rfidReaderChannel;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    rfidReaderChannel= new RfidReaderChannel(getFlutterView());
  }

  @Override
  public boolean onKeyUp(int keyCode, KeyEvent event) {
    boolean eventHandled=rfidReaderChannel.onKeyUp(keyCode, event);
    /**
     * TODO: Check if the event was handled. If so,
     * don't call the event on super
     */
    if(eventHandled)
      return true;
    else
    return super.onKeyUp(keyCode, event);
  }

  @Override
  public boolean onKeyDown(int keyCode, KeyEvent event) {
    boolean eventHandled=rfidReaderChannel.onKeyDown(keyCode, event);
    /**
     * TODO: Check if the event was handled. If so,
     * don't call the event on super
     */
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
