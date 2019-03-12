package com.kaoyaya.flutterkaoyayaplugin;
import android.app.Application;
import com.talkfun.cloudlive.util.ActivityStacks;
import com.talkfun.sdk.log.TalkFunLogger;
import com.talkfun.sdk.offline.PlaybackDownloader;

public abstract class KaoyayaApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        //初始化点播下载
        initPlaybackDownLoader();
    }

    public void initPlaybackDownLoader() {
        PlaybackDownloader.getInstance().init(this);
        PlaybackDownloader.getInstance().setDownLoadThreadSize(3);
    }


    @Override
    public void onTerminate() {
        super.onTerminate();
        System.exit(0);
    }

    public static void exit() {
        /**终止应用程序对象时调用，不保证一定被调用 ,退出移除所有的下载任务*/
        ActivityStacks.getInstance().finishAllActivity();
        //释放离线下载资源
        PlaybackDownloader.getInstance().destroy();
        TalkFunLogger.release();
        android.os.Process.killProcess(android.os.Process.myPid());
        System.exit(1);
    }

}