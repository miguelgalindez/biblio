package com.example.biblio;

import android.os.Bundle;
import android.view.KeyEvent;

import com.example.biblio.channels.AlienRFIDReader;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  AlienRFIDReader alienRFIDReader;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    alienRFIDReader=new AlienRFIDReader(getFlutterView());
  }

  @Override
  public boolean onKeyUp(int keyCode, KeyEvent event) {
    boolean eventHandled=alienRFIDReader.onKeyUp(keyCode, event);
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
    boolean eventHandled=alienRFIDReader.onKeyDown(keyCode, event);
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
    alienRFIDReader.destroy();
    super.onDestroy();
  }
}
