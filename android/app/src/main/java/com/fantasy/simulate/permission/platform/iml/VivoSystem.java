package com.fantasy.simulate.permission.platform.iml;

import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;

/**
 * Created by spark on 2018/4/24.
 */

public class VivoSystem extends AbstractAndroidSystem {

    private static final String TAG = "SPA-VivoSystem";

    @Override
    public boolean checkFloatWindowPermission(Context context) {
        int version = Build.VERSION.SDK_INT;
        if (version <= 19) {
            return false;
        } else if (version <= 21) {
            //API<=21 的vivo手机无悬浮窗设置界面，默认都为true
            return true;
        } else {
            return checkVivoFWP22And23(context) || checkVivoFWPAbove23(context);
        }
    }

    @Override
    public void applyFloatWindowPermission(Context context) {
        applyVivoFWP(context);
    }

    private boolean checkVivoFWP22And23(Context context) {
        Uri uri = Uri.parse("content://com.iqoo.secure.provider.secureprovider/allowfloatwindowapp");
        boolean isFloatOn = false;
        ContentResolver resolver = context.getContentResolver();
        Cursor cursor = null;
        try {
            cursor = resolver.query(uri, null, "pkgname=?", new String[]{context.getPackageName()}, null);
            if (cursor != null && cursor.getCount() > 0 && cursor.moveToFirst()) {
                int mode = cursor.getInt(cursor.getColumnIndex("currentlmode"));
                Log.i(TAG, "checkVivoFWP22: mode=" + mode);
                isFloatOn = (mode == 0);
            }
        } catch (Exception e) {
            isFloatOn = !isVivoFirstRequestFWP(context);
            e.printStackTrace();
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return isFloatOn;
    }

    private boolean checkVivoFWPAbove23(Context context) {
        Uri uri = Uri.parse("content://com.vivo.permissionmanager.provider.permission/float_window_apps");
        boolean isFloatOn = false;
        ContentResolver resolver = context.getContentResolver();
        Cursor cursor = null;
        try {
            cursor = resolver.query(uri, null, "pkgname=?", new String[]{context.getPackageName()}, null);
            if (cursor != null && cursor.getCount() > 0 && cursor.moveToFirst()) {
                int mode = cursor.getInt(cursor.getColumnIndex("currentmode"));
                Log.i(TAG, "checkVivoFWPAbove22: mode=" + mode);
                isFloatOn = (mode == 0);
            }
        } catch (Exception e) {
            isFloatOn = !isVivoFirstRequestFWP(context);
            e.printStackTrace();
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return isFloatOn;
    }

    /**
     * vivo 悬浮窗申请
     *
     * @param context
     */
    private void applyVivoFWP(Context context) {
        try {
            Intent intent = new Intent();
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.putExtra("packagename", context.getPackageName());
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
                intent.setComponent(new ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.SoftPermissionDetailActivity"));
            } else if (Build.VERSION.SDK_INT == Build.VERSION_CODES.M) {
                intent.setComponent(new ComponentName("com.iqoo.secure", "com.iqoo.secure.safeguard.SoftPermissionDetailActivity"));
            } else {
                intent.setComponent(ComponentName.unflattenFromString("com.vivo.permissionmanager/.activity.PurviewTabActivity"));
            }
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            try {
                Intent intent = new Intent(Intent.ACTION_MAIN);
                intent.addCategory(Intent.CATEGORY_LAUNCHER);
                ComponentName comp = ComponentName.unflattenFromString("com.iqoo.secure/.MainGuideActivity");
                intent.setComponent(comp);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
            } catch (Exception ex) {
                Toast.makeText(context, "跳转失败，请前往 i管家 设置悬浮窗权限", Toast.LENGTH_SHORT).show();
            }
        } finally {
            saveVivoRequestFwp(context);
        }
    }

    private boolean isVivoFirstRequestFWP(Context context) {
        SharedPreferences sp = context.getSharedPreferences("vivo_fwp", Context.MODE_PRIVATE);
        return sp.getBoolean("isFirst", true);
    }

    private void saveVivoRequestFwp(Context context) {
        SharedPreferences sp = context.getSharedPreferences("vivo_fwp", Context.MODE_PRIVATE);
        sp.edit().putBoolean("isFirst", false).apply();
    }
}
