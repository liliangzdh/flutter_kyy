package com.kaoyaya.flutterkaoyaya;

import android.app.Activity;
import android.support.annotation.CallSuper;
import com.kaoyaya.flutterkaoyayaplugin.KaoyayaApplication;
import io.flutter.view.FlutterMain;

public class MainApplication extends KaoyayaApplication {
    private Activity mCurrentActivity = null;

    public MainApplication() {
    }

    @CallSuper
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);


    }

    public Activity getCurrentActivity() {
        return this.mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }

}