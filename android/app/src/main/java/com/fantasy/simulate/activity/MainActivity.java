package com.fantasy.simulate.activity;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.fantasy.simulate.plugin.MyMethodPlugin;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

/**
 * Create by 伊哇 at 2021/9/22 10:05
 */
public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull @org.jetbrains.annotations.NotNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MyMethodPlugin.registerWith(this, flutterEngine);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (!isTaskRoot()) {
            finish();
        }
    }

    @Override
    public void onFlutterUiDisplayed() {
        super.onFlutterUiDisplayed();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        MyMethodPlugin.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }
}
