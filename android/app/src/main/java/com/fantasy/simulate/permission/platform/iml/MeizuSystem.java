package com.fantasy.simulate.permission.platform.iml;

import android.content.Context;
import android.content.Intent;
import android.os.Build;

/**
 * Created by spark on 2018/4/24.
 */

public class MeizuSystem extends AbstractAndroidSystem {

    @Override
    public void applyFloatWindowPermission(Context context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            applyMeizuFWPBelow24(context);
        } else {
            super.applyFloatWindowPermission(context);
        }
    }

    private void applyMeizuFWPBelow24(Context context) {
        try {
            Intent intent = new Intent("com.meizu.safe.security.SHOW_APPSEC");
            intent.setClassName("com.meizu.safe", "com.meizu.safe.security.AppSecActivity");
            intent.putExtra("packageName", context.getPackageName());
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            goAppSettingDetail(context);
        }
    }
}
