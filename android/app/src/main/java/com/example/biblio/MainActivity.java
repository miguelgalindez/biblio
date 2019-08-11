package com.example.biblio;

import android.os.Bundle;
import android.view.KeyEvent;

import com.example.biblio.resources.rfidReader.ImplementationSelector;
import com.example.biblio.resources.rfidReader.ReaderChannel;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  ReaderChannel rfidReaderChannel;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // Comment the following line on production
    ImplementationSelector.PROJECT_STAGE="development";

    rfidReaderChannel= new ReaderChannel(getFlutterView());
  }

  @Override
  public boolean onKeyUp(int keyCode, KeyEvent event) {
    boolean eventHandled=rfidReaderChannel.onKeyUp(keyCode, event);
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
