package com.kaoyaya.flutterkaoyayaplugin;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.talkfun.cloudlive.activity.AboutUsActivity;
import com.talkfun.cloudlive.activity.LoginJumpActivity;
import com.talkfun.cloudlive.activity.PlayDownLoadActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterKaoyayaPlugin
 */
public class FlutterKaoyayaPlugin implements MethodCallHandler {


    private Activity activity;

    public FlutterKaoyayaPlugin(Activity activity) {
        this.activity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_kaoyaya_plugin");
        FlutterKaoyayaPlugin instance = new FlutterKaoyayaPlugin(registrar.activity());
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                Intent intent = new Intent(activity, AboutUsActivity.class);
                activity.startActivity(intent);
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "live":
                String title = call.argument("title");
                String accessToken = call.argument("accessToken");
                String playbackId = call.argument("playbackId");
                String type = call.argument("type");
                live(accessToken, type, title, playbackId);
                break;
            case "downloadList":
                downloadList();
                break;
        }
    }

    public void live(String accessToken, String type, String title, String playbackId) {
        Bundle bundle = new Bundle();
        bundle.putString(LoginJumpActivity.TOKEN_PARAM, accessToken);
        bundle.putString(LoginJumpActivity.LOG0_PARAM, "");
        bundle.putString(LoginJumpActivity.TITLE_PARAM, title);
        if (type.equals("live")) {
            bundle.putInt(LoginJumpActivity.TYPE_PARAM, 4);
        } else {
            bundle.putInt(LoginJumpActivity.TYPE_PARAM, 5);
        }
        bundle.putString(LoginJumpActivity.ID_PARAM, playbackId);
        Intent intent = new Intent(activity, LoginJumpActivity.class);
        intent.putExtras(bundle);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        activity.startActivity(intent);
    }

    public void downloadList() {
        Intent intent = new Intent(activity, PlayDownLoadActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        activity.startActivity(intent);
    }
}
