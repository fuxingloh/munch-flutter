package app.munch.munchapp;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import app.munch.facebookappevents.FacebookAppEventsPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // Private Plugins
    FacebookAppEventsPlugin.registerWith(this.registrarFor("io.flutter.plugins.facebookappevents.FacebookAppEventsPlugin"));
  }
}
