package com.fantasy.simulate.permission.platform.iml;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import com.fantasy.simulate.utils.RomUtils;

/**
 * Created by spark on 2018/4/24.
 */

public class MiSystem extends AbstractAndroidSystem {

    @Override
    public void applyFloatWindowPermission(Context context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            applyMiFWPBelow23(context);
        } else {
            super.applyFloatWindowPermission(context);
        }
    }

    private void applyMiFWPBelow23(Context context) {
        int versionCode = RomUtils.getMiuiVersion();
        if (versionCode <= 5) {
            try {
                Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                intent.setData(Uri.fromParts("package", context.getPackageName(), null));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
            } catch (Exception e) {
                e.printStackTrace();
                goAppSettingDetail(context);
            }
        } else {
            try {
                Intent intent = new Intent("miui.intent.action.APP_PERM_EDITOR");
                intent.setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity");
                intent.putExtra("extra_pkgname", context.getPackageName());
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
            } catch (Exception e) {
                e.printStackTrace();
                try {
                    Intent intent = new Intent("miui.intent.action.APP_PERM_EDITOR");
                    intent.setPackage("com.miui.securitycenter");
                    intent.putExtra("extra_pkgname", context.getPackageName());
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    context.startActivity(intent);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    goAppSettingDetail(context);
                }
            }
        }
    }
}
