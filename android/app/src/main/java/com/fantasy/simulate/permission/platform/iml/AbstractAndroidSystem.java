package com.fantasy.simulate.permission.platform.iml;

import android.app.Activity;
import android.app.AppOpsManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Binder;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;


import com.fantasy.simulate.permission.platform.AndroidSystem;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Created by spark on 2018/4/24.
 */

public abstract class AbstractAndroidSystem implements AndroidSystem {

    private static final String TAG = "SPA-AbsAndroidSystem";

    @Override
    public void goAppSettingDetail(Context context) {
        try {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            Uri uri = Uri.fromParts("package", context.getPackageName(), null);
            intent.setData(uri);
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(context, "自动跳转失败，请自行到设置中开启", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public boolean checkFloatWindowPermission(Context context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return checkFloatWindowPermissionBelow23(context);
        } else {
            //6.0版本之后由于 google 增加了对悬浮窗权限的管理，所以方式就统一了(可能个别手机还会有问题)
            return checkFloatWindowPermissionAbove23(context);
        }
    }

    @Override
    public void applyFloatWindowPermission(Context context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            goAppSettingDetail(context);
        } else {
            applyFloatWindowPermissionAbove23(context);
        }
    }

    /**
     * API<23 的悬浮窗权限检查
     *
     * @param context
     * @return
     */
    protected boolean checkFloatWindowPermissionBelow23(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            AppOpsManager manager = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            try {
                Class clazz = AppOpsManager.class;
                Method method = clazz.getDeclaredMethod("checkOp", int.class, int.class, String.class);
                method.setAccessible(true);
                //OP_SYSTEM_ALERT_WINDOW = 24
                int result = (int) method.invoke(manager, 24, Binder.getCallingUid(), context.getPackageName());
                return AppOpsManager.MODE_ALLOWED == result;
            } catch (Exception e) {
                Log.e(TAG, Log.getStackTraceString(e));
            }
        } else {
            Log.e(TAG, "Below API 19 cannot invoke!");
        }
        return false;
    }

    /**
     * API>=23 的悬浮窗权限检查
     *
     * @param context
     * @return
     */
    protected boolean checkFloatWindowPermissionAbove23(Context context) {
        Boolean result = false;
        if (Build.VERSION.SDK_INT >= 23) {
            try {
                Class clazz = Settings.class;
                Method canDrawOverlays = clazz.getDeclaredMethod("canDrawOverlays", Context.class);
                if (canDrawOverlays == null) {
                    Log.d(TAG, "checkOp-method==null");
                    return result;
                }
                canDrawOverlays.setAccessible(true);
                result = (Boolean) canDrawOverlays.invoke(null, context);
            } catch (Exception e) {
                Log.e(TAG, Log.getStackTraceString(e));
            }
        }
        return result;
    }

    protected void applyFloatWindowPermissionAbove23(Context context) {
        if (Build.VERSION.SDK_INT < 23) return;

        try {
            Class clazz = Settings.class;
            Field field = clazz.getDeclaredField("ACTION_MANAGE_OVERLAY_PERMISSION");
            Intent intent = new Intent(field.get(null).toString());
            intent.setData(Uri.parse("package:" + context.getPackageName()));
            if (context instanceof Activity) {
                ((Activity) context).startActivityForResult(intent, 424);
            } else {
                context.startActivity(intent);
            }
        } catch (Exception e) {
            e.printStackTrace();
            goAppSettingDetail(context);
        }
    }
}
