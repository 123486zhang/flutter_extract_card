package com.fantasy.simulate.utils;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.provider.Settings;
import android.text.TextUtils;
import android.widget.EditText;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.util.List;

public class AppUtil {
    public static String getApplicationName(Context ctx) {
        PackageManager packageManager = null;
        ApplicationInfo applicationInfo = null;
        try {
            packageManager = ctx.getApplicationContext().getPackageManager();
            applicationInfo = packageManager.getApplicationInfo(
                    ctx.getPackageName(), 0);
        } catch (NameNotFoundException e) {
            applicationInfo = null;
        }
        String applicationName = (String) packageManager
                .getApplicationLabel(applicationInfo);
        if (TextUtils.isEmpty(applicationName)) {
            applicationInfo = ctx.getApplicationInfo();
            int stringId = applicationInfo.labelRes;
            applicationName = (stringId == 0) ? applicationInfo.nonLocalizedLabel.toString() : ctx.getString(stringId);
        }

        return applicationName;
    }

    public static int getVersionCode(Context ctx, String packageName) {

        try {
            PackageManager manager = ctx.getPackageManager();
            PackageInfo info = manager.getPackageInfo(packageName, 0);
            int versionCode = info.versionCode;
            return versionCode;
        } catch (NameNotFoundException e) {
            e.printStackTrace();
            return 0;
        }
    }

    //根据包名获取包信息
    public static PackageInfo getPackageInfo(Context context, String packageName) {
        List<PackageInfo> packageInfos = context.getPackageManager().getInstalledPackages(0);
        for (int i = 0; i < packageInfos.size(); i++) {
            PackageInfo info = packageInfos.get(i);
            if (info.packageName.equals(packageName)) {
                return info;
            }
        }
        return null;
    }

    public static String getAndroidId(Context context) {
        String ANDROID_ID = Settings.System.getString(context.getContentResolver(), Settings.System.ANDROID_ID);
        return ANDROID_ID;
    }

    /**
     * 获取外部版本号的方法
     *
     * @param ctx
     * @return
     */
    public static String getVersion(Context ctx) {

        try {
            PackageManager manager = ctx.getPackageManager();
            PackageInfo info = manager.getPackageInfo(ctx.getPackageName(), 0);
            String version = info.versionName;
            return version;
        } catch (NameNotFoundException e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * 获取内部版本号的方法
     */
    public static int getVersionCode(Context ctx) {

        try {
            PackageManager manager = ctx.getPackageManager();
            PackageInfo info = manager.getPackageInfo(ctx.getPackageName(), 0);
            int versionCode = info.versionCode;
            return versionCode;
        } catch (NameNotFoundException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 获取IMEI号
     */
    public static String getIMEI(Context ctx) {
        return getAndroidId(ctx);
    }

    public static String getUniqueid(Context ctx) {
        String uniqueId = Build.BOARD.length() % 10 + ""
                + Build.BRAND.length() % 10 + "" + Build.CPU_ABI.length() % 10
                + "" + Build.DEVICE.length() % 10 + ""
                + Build.DISPLAY.length() % 10 + "" + Build.HOST.length() % 10
                + "" + Build.ID.length() % 10 + ""
                + Build.MANUFACTURER.length() % 10 + ""
                + Build.MODEL.length() % 10 + "" + Build.PRODUCT.length() % 10
                + "" + Build.TAGS.length() % 10 + "" + Build.TYPE.length() % 10
                + "" + Build.USER.length() % 10 + Build.SERIAL;
        return uniqueId;
    }

    public static String getModel() {
        return Build.MODEL;
    }

    /**
     * 获取application中指定的meta-data
     *
     * @return 如果没有获取成功(没有对应值，或者异常)，则返回值为空
     */
    public static int getAppMetaData(Context ctx, String key) {
        if (ctx == null || TextUtils.isEmpty(key)) {
            return 0;
        }
        int resultData = 0;
        try {
            PackageManager packageManager = ctx.getPackageManager();
            if (packageManager != null) {
                ApplicationInfo applicationInfo = packageManager
                        .getApplicationInfo(ctx.getPackageName(),
                                PackageManager.GET_META_DATA);
                if (applicationInfo != null) {
                    if (applicationInfo.metaData != null) {
                        resultData = applicationInfo.metaData.getInt(key);
                    }
                }
            }
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }

        return resultData;
    }

    public static String getAppMetaDataS(Context ctx, String key) {
        if (ctx == null || TextUtils.isEmpty(key)) {
            return 0 + "";
        }
        String resultData = 0 + "";
        try {
            PackageManager packageManager = ctx.getPackageManager();
            if (packageManager != null) {
                ApplicationInfo applicationInfo = packageManager
                        .getApplicationInfo(ctx.getPackageName(),
                                PackageManager.GET_META_DATA);
                if (applicationInfo != null) {
                    if (applicationInfo.metaData != null) {
                        // 防止系统自动判断渠道id为int或String
                        resultData = applicationInfo.metaData.get(key)
                                .toString();
                    }
                }
            }
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }

        return resultData;
    }

    public static String getMac() {
        String macSerial = null;
        String str = "";
        try {
            Process pp = Runtime.getRuntime().exec(
                    "cat /sys/class/net/wlan0/address ");
            InputStreamReader ir = new InputStreamReader(pp.getInputStream());
            LineNumberReader input = new LineNumberReader(ir);

            for (; null != str; ) {
                str = input.readLine();
                if (str != null) {
                    macSerial = str.trim();// 去空格
                    break;
                }
            }
        } catch (IOException ex) {
            // 赋予默认值
            ex.printStackTrace();
        }
        return macSerial;
    }

    /**
     * 获取EditText内容
     *
     * @param et
     * @return
     */
    public static String getEditTextContent(EditText et) {
        String str = et.getText().toString();
        return str;
    }

    public static boolean getIsChangeIcon(Context context) {
        SharedPreferences sp = context.getSharedPreferences("icon", Activity.MODE_PRIVATE);
        return sp.getBoolean("changeIcon", false);
    }
    public static void setIsChangeIcon(Context context, boolean bool) {
        SharedPreferences sp = context.getSharedPreferences("icon", Activity.MODE_PRIVATE);
        SharedPreferences.Editor edit = sp.edit();
        edit.putBoolean("changeIcon", bool);
        edit.apply();
    }

    /**
     * 图片是否损坏
     *
     * @param path
     * @return
     */
    public static boolean checkBitmap(String path) {
        if (TextUtils.isEmpty(path))
            return false;
        try {
            Bitmap result = BitmapFactory.decodeFile(path);
            if (result == null) {
                return false;
            }
            result.recycle();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
}
