package com.fantasy.simulate.permission;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import com.fantasy.simulate.permission.platform.AndroidSystem;


/**
 * Created by spark on 2018/4/24.
 */

public class PermissionManager {

    private static final String TAG = "SPA-PermissionManager";

    private static final AndroidSystem sSYSTEM = AndroidSystemFactory.findAndroidSystem();

    /**
     * 悬浮窗权限检查
     */
    public static boolean checkFWP(Context context) {
        boolean has = sSYSTEM.checkFloatWindowPermission(context);
        Log.d(TAG, "FWP=" + has + ", model" + Build.MODEL + ", api=" + Build.VERSION.SDK_INT);
        return has;
    }

    /**
     * 悬浮窗权限申请
     */
    public static void applyFWP(Context context) {
        sSYSTEM.applyFloatWindowPermission(context);
    }

    public static void goSettingDetail(Context context) {
        sSYSTEM.goAppSettingDetail(context);
    }
}
