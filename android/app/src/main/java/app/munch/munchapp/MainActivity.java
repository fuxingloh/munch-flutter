package app.munch.munchapp;

import android.os.Bundle;
import app.munch.facebookappevents.FacebookAppEventsPlugin;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // Private Plugins
    FacebookAppEventsPlugin.registerWith(this.registrarFor("io.flutter.plugins.facebookappevents.FacebookAppEventsPlugin"));
  }
}
