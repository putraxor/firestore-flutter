package com.github.putraxor.firestore;

import android.os.Bundle;
import android.util.Log;

import com.google.firebase.FirebaseApp;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    FirebaseApp.initializeApp(this);
    Log.wtf("Main", "Why flutter stupid?");
    GeneratedPluginRegistrant.registerWith(this);
  }
}
