package com.fantasy.simulate.permission.platform.iml;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.widget.Toast;

/**
 * Created by spark on 2018/4/24.
 */

public class OppoSystem extends AbstractAndroidSystem {

    @Override
    public void applyFloatWindowPermission(Context context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            applyOppoFWPBelow23(context);
        } else {
            super.applyFloatWindowPermission(context);
        }
    }

    /**
     * oppo 悬浮窗申请
     *
     * @param context
     */
    private void applyOppoFWPBelow23(Context context) {
        try {
            Intent intent = new Intent("action.coloros.safecenter.FloatWindowListActivity");
            ComponentName comp = ComponentName.unflattenFromString("com.coloros.safecenter/.sysfloatwindow.FloatWindowListActivity");
            intent.setComponent(comp);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch (Exception e) {
            try {
                Intent intent = new Intent("action.coloros.safecenter.FloatWindowListActivity");
                ComponentName comp = ComponentName.unflattenFromString("com.coloros.safecenter/.permission.floatwindow.FloatWindowListActivity");
                intent.setComponent(comp);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
            } catch (Exception ex) {
                Toast.makeText(context, "跳转失败，请前往 手机管家 设置悬浮窗权限", Toast.LENGTH_SHORT).show();
            }
        }
    }
}
