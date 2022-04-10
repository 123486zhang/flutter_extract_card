package com.fantasy.simulate.permission.platform.iml;

import android.content.Context;
import android.content.Intent;
import android.os.Build;

/**
 * Created by spark on 2018/4/24.
 */

public class QiHooSystem extends AbstractAndroidSystem {

    @Override
    public void applyFloatWindowPermission(Context context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            applyQihooFWPPermission(context);
        } else {
            super.applyFloatWindowPermission(context);
        }
    }

    /**
     * 360 悬浮窗权限申请
     */
    private void applyQihooFWPPermission(Context context) {
        try {
            Intent intent = new Intent();
            intent.setClassName("com.android.settings", "com.android.settings.Settings$OverlaySettingsActivity");
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch (Exception e) {
            try {
                Intent intent = new Intent();
                intent.setClassName("com.qihoo360.mobilesafe", "com.qihoo360.mobilesafe.ui.index.AppEnterActivity");
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
            } catch (Exception ex) {
                goAppSettingDetail(context);
            }
        }
    }
}
