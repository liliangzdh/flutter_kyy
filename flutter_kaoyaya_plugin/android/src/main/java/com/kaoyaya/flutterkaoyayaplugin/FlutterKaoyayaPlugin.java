package com.kaoyaya.flutterkaoyayaplugin;

import android.app.Activity;
import android.content.Intent;

import com.talkfun.cloudlive.activity.AboutUsActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterKaoyayaPlugin */
public class FlutterKaoyayaPlugin implements MethodCallHandler {


  private Activity activity;
  public FlutterKaoyayaPlugin(Activity activity) {
    this.activity = activity;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_kaoyaya_plugin");
    FlutterKaoyayaPlugin instance = new FlutterKaoyayaPlugin(registrar.activity());
    channel.setMethodCallHandler(instance);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      Intent intent = new Intent(activity, AboutUsActivity.class);
      activity.startActivity(intent);
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}
