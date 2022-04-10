package com.fantasy.simulate.utils;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

public class RomUtils {

    private static final String TAG = "SPA-RomUtils";

    /**
     * 获取 emui 版本号
     *
     * @return
     */
    public static double getEmuiVersion() {
        try {
            String emuiVersion = getSystemProperty("ro.build.version.emui");
            String version = emuiVersion.substring(emuiVersion.indexOf("_") + 1);
            return Double.parseDouble(version);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 4.0;
    }

    /**
     * 获取小米 rom 版本号，获取失败返回 -1
     *
     * @return miui rom version code, if fail , return -1
     */
    public static int getMiuiVersion() {
        String version = getSystemProperty("ro.miui.ui.version.name");
        if (version != null) {
            try {
                return Integer.parseInt(version.substring(1));
            } catch (Exception e) {
                Log.e(TAG, "get miui version code error, version : " + version);
                Log.e(TAG, Log.getStackTraceString(e));
            }
        }
        return -1;
    }

    public static String getSystemProperty(String propName) {
        String line;
        BufferedReader input = null;
        try {
            Process p = Runtime.getRuntime().exec("getprop " + propName);
            input = new BufferedReader(new InputStreamReader(p.getInputStream()), 1024);
            line = input.readLine();
            input.close();
        } catch (IOException ex) {
            Log.e(TAG, "Unable to read sysprop " + propName, ex);
            return null;
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    Log.e(TAG, "Exception while closing InputStream", e);
                }
            }
        }
        return line;
    }

    public static boolean checkIsHuaweiRom() {
        return Build.MANUFACTURER.contains("HUAWEI");
    }

    /**
     * check if is miui ROM
     */
    public static boolean checkIsMiuiRom() {
        return !TextUtils.isEmpty(getSystemProperty("ro.miui.ui.version.name"));
    }

    public static boolean checkIsSamsungRom() {
        return Build.MANUFACTURER.contains("samsung")
                || Build.BRAND.contains("samsung");
    }

    public static boolean checkIsMeizuRom() {
        String meizuFlymeOSFlag = getSystemProperty("ro.build.display.id");
        if (TextUtils.isEmpty(meizuFlymeOSFlag)) {
            return false;
        } else
            return meizuFlymeOSFlag.contains("flyme") || meizuFlymeOSFlag.toLowerCase().contains("flyme");
    }

    public static boolean checkIs360Rom() {
        return Build.MANUFACTURER.contains("QiKU")
                || Build.MANUFACTURER.contains("360");
    }

    public static boolean checkIsVivoRom() {
        return Build.MANUFACTURER.contains("vivo")
                || Build.BRAND.contains("vivo");
    }

    public static boolean checkIsOppoRom() {
        return Build.MANUFACTURER.contains("OPPO")
                || Build.MANUFACTURER.contains("oppo")
                || Build.BRAND.contains("OPPO")
                || Build.BRAND.contains("oppo");
    }

    public static int getIqooVersion(Context context) {
        PackageInfo iqoo = getPackageInfo(context, "com.iqoo.secure");
        if (iqoo == null) {
            return -1;
        }
        Log.d("SPA", "Version=" + iqoo.versionName + ", code=" + iqoo.versionCode);
        return Integer.parseInt(iqoo.versionName.substring(0, 1));
    }

    public static PackageInfo getPackageInfo(Context context, String packagename) {
        List<PackageInfo> packageInfos = context.getPackageManager()
                .getInstalledPackages(0);
        for (int i = 0; i < packageInfos.size(); i++) {
            PackageInfo info = packageInfos.get(i);
            if (info.packageName.equals(packagename)) {
                return info;
            }
        }
        return null;
    }
}
