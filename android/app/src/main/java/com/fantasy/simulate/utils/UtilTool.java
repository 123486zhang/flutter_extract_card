package com.fantasy.simulate.utils;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.Settings;
import android.text.ClipboardManager;
import android.text.InputType;
import android.text.TextUtils;
import android.text.method.DigitsKeyListener;
import android.widget.EditText;
import android.widget.Toast;

import com.jayfeng.lesscode.core.AppLess;
import com.fantasy.simulate.bean.UserModel;
import com.fantasy.simulate.db.UserSpUtil;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * @author XL
 * @time 2020-03-23
 */
public final class UtilTool {
    private static long lastClickTime;
    private static final int MIN_DELAY_TIME = 300;  // 两次点击间隔不能少于500ms

    /**
     * 判断是否为快速点击
     *
     * @return
     */
    public static boolean isFastClick() {
        boolean flag = true;
        long currentClickTime = System.currentTimeMillis();
        if ((currentClickTime - lastClickTime) >= MIN_DELAY_TIME) {
            flag = false;
        }
        lastClickTime = currentClickTime;
        return flag;
    }

    public static String getRealPathFromURI(Context context, Uri contentURI) {
        String result;
        Cursor cursor = context.getContentResolver().query(contentURI,
                new String[]{MediaStore.Images.ImageColumns.DATA},
                null, null, null);
        if (cursor == null) result = contentURI.getPath();
        else {
            cursor.moveToFirst();
            int index = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
            result = cursor.getString(index);
            cursor.close();
        }
        return result;
    }

    public static void showToast(Context context, String toast) {
        Toast.makeText(context, toast, Toast.LENGTH_SHORT).show();
    }

    public static void copy2Clipboard(Context context, String text) {
        ClipboardManager cm = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
        cm.setText(text);
    }

    /**
     * 这个方法有问题, 字符串超过int长度就是false了
     * 判断字符串是否全是数字
     *
     * @param string
     * @return
     */
    public static boolean isNumberString(String string) {
        if (TextUtils.isEmpty(string)) {
            return false;
        }
        for (int i = 0; i < string.length(); i++) {
            char chr = string.charAt(i);
            if (chr < '0' || chr > '9') {
                return false;
            }
        }
        return true;

    }

    public static boolean isWeixinAvilible(Context context) {
        final PackageManager packageManager = context.getPackageManager();// 获取packagemanager
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);// 获取所有已安装程序的包信息
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName;
                if (pn.equals("com.tencent.mm")) {
                    return true;
                }
            }
        }

        return false;
    }

    public static boolean isAliPayInstalled(Context context) {
        Uri uri = Uri.parse("alipays://platformapi/startApp");
        Intent intent = new Intent(Intent.ACTION_VIEW, uri);
        ComponentName componentName = intent.resolveActivity(context.getPackageManager());
        return componentName != null;
    }

    public static boolean isExistApp(Context context, String pkname) {
        final PackageManager packageManager = context.getPackageManager();// 获取packagemanager
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);// 获取所有已安装程序的包信息
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName;
                if (pn.equals(pkname)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static void openExistApp(Context context, String pkname) {
        Intent LaunchIntent = context.getPackageManager().getLaunchIntentForPackage(pkname);
        context.startActivity(LaunchIntent);
    }

    /**
     * 密码显示或隐藏 （切换）
     */
    public static void showPassword(EditText etPassword, boolean isShow) {
        //记住光标开始的位置
        int pos = etPassword.getSelectionStart();
        if (!isShow) {//隐藏密码
            etPassword.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        } else {//显示密码
            etPassword.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
        }
        etPassword.setSelection(pos);
        String digits = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        etPassword.setKeyListener(DigitsKeyListener.getInstance(digits));
    }

    public static boolean isPhoneNumber(String str) {
        String pattern = "1[23456789]\\d{9}";

        Pattern r = Pattern.compile(pattern);
        Matcher m = r.matcher(str);
        return m.matches();
    }


    public static String getAndroidId(Context context) {
        String ANDROID_ID = Settings.System.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        return ANDROID_ID;
    }


    public static boolean checkBitmap(String path) {
        if (TextUtils.isEmpty(path))
            return false;
        Bitmap result = BitmapFactory.decodeFile(path);
        if (result == null) {
            return false;
        }
        result.recycle();
        return true;
    }

    public static String getUniqueid() {
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


    public static String getChannelId(Context context) {
        String resultData = "0";
        try {
            PackageManager packageManager = context.getPackageManager();
            if (packageManager != null) {
                ApplicationInfo applicationInfo = packageManager.getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
                if (applicationInfo != null) {
                    if (applicationInfo.metaData != null) {
                        // 防止系统自动判断渠道id为int或String
                        resultData = applicationInfo.metaData.get("UMENG_CHANNEL").toString();
                    }
                }
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return resultData;
    }

    public static void saveImageToGallery(Context context, Bitmap bmp) {
        // 首先保存图片
        File file = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsoluteFile();//注意小米手机必须这样获得public绝对路径
        String fileName = "wsky";
        File appDir = new File(file, fileName);
        if (!appDir.exists()) {
            appDir.mkdirs();
        }
        fileName = System.currentTimeMillis() + ".jpg";
        File currentFile = new File(appDir, fileName);

        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(currentFile);
            bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (fos != null) {
                    fos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // 最后通知图库更新
        sendInAlbum(context, currentFile.getPath());
    }

    public static String filterCharToNormal(String oldString) {
        if (oldString == null) {
            return "";
        }
        StringBuilder stringBuilder = new StringBuilder();
        int length = oldString.length();
        for (int i = 0; i < length; i++) {//遍历传入的String的所有字符
            char codePoint = oldString.charAt(i);
            String punctuation = "[`~!@#$^&*()+=|{}':;',\\[\\].<>/?~！@#￥……& amp;*（）——+|{}【】‘；：”“’。，、？|-]";
            if (//如果当前字符为常规字符,则将该字符拼入StringBuilder
                    ((codePoint >= 0x4e00) && (codePoint <= 0x9fa5)) ||//表示汉字区间
                            ((codePoint >= 0x30) && (codePoint <= 0x39)) ||//表示数字区间
                            ((codePoint >= 0x41) && (codePoint <= 0x5a)) ||//表示大写字母区间
                            ((codePoint >= 0x61) && (codePoint <= 0x7a)) || punctuation.contains(String.valueOf(codePoint))) {//小写字母区间
                stringBuilder.append(codePoint);
            } else {//如果当前字符为非常规字符,则忽略掉该字符
            }
        }
        return stringBuilder.toString();
    }

    public static void sendInAlbum(Context context, String path) {
        if (TextUtils.isEmpty(path)) return;

        // 最后通知图库更新
        context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE,
                Uri.fromFile(new File(path))));
    }

    public static boolean isNetUrl(String str) {
        if (str.startsWith("http://") || str.startsWith("https://") || str.startsWith("www."))
            return true;
        return false;
    }

    public static String md5(String string) {
        if (TextUtils.isEmpty(string)) {
            return "";
        }
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
            byte[] bytes = md5.digest(string.getBytes());
            StringBuilder result = new StringBuilder();
            for (byte b : bytes) {
                String temp = Integer.toHexString(b & 0xff);
                if (temp.length() == 1) {
                    temp = "0" + temp;
                }
                result.append(temp);
            }
            return result.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 复制单个文件
     *
     * @param oldPath String 原文件路径 如：c:/fqf.txt
     * @param newPath String 复制后路径 如：f:/fqf.txt
     * @return boolean
     */
    public static void copyFile(String oldPath, String newPath) {
        try {
            int bytesum = 0;
            int byteread = 0;
            File oldfile = new File(oldPath);
            if (oldfile.exists()) { // 文件存在时
                InputStream inStream = new FileInputStream(oldPath); // 读入原文件
                FileOutputStream fs = new FileOutputStream(create(newPath));
                byte[] buffer = new byte[1444];
                // int length;
                while ((byteread = inStream.read(buffer)) != -1) {
                    bytesum += byteread; // 字节数 文件大小
                    fs.write(buffer, 0, byteread);
                }
                inStream.close();
                fs.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public static File create(String filePath) {
        if (TextUtils.isEmpty(filePath)) {
            return null;
        }

        File f = new File(filePath);
        if (!f.getParentFile().exists()) {// 如果不存在上级文件夹
            f.getParentFile().mkdirs();
        }
        try {
            boolean newFile = f.createNewFile();
            return f;
        } catch (IOException e) {
            if (f != null && f.exists()) {
                f.delete();
            }
            return null;
        }
    }

    private static String get12UUID() {
        UUID id = UUID.randomUUID();
        String[] idd = id.toString().split("-");
        return idd[0] + idd[1];
    }

    public static String setMaxLength(String str, int maxLen) {
        if (TextUtils.isEmpty(str)) {
            return str;
        }
        int count = 0;
        int endIndex = 0;
        for (int i = 0; i < str.length(); i++) {
            char item = str.charAt(i);
            if (item < 128) {
                count = count + 1;
            } else {
                count = count + 2;
            }
            if (maxLen == count || (item >= 128 && maxLen + 1 == count)) {
                endIndex = i;
            }
        }
        if (count <= maxLen) {
            return str;
        } else {
            return str.substring(0, endIndex);
        }
    }

    public static void startKf(Context context) {
        String sdkToken = context.getPackageName() + UtilTool.getAndroidId(context);
        Map<String, String> info = new HashMap<>();
        //**//sdktoken 必填**
        Map<String, String> updateInfo = new HashMap<>();

        //JuanTop 2019/3/29 增加客服昵称，
        UserModel userModel = UserSpUtil.getUser(context);

        String nickName = getUdeskNickName(context);
        if (TextUtils.isEmpty(nickName)) {
            nickName = userModel != null && UserSpUtil.isLogin(context)
                    ? userModel.name : "";
        }

        if (TextUtils.isEmpty(nickName)) {
            nickName = get12UUID();
            putUdeskNickName(context, nickName);
        }
        
      //  UdeskSDKManager.getInstance().entryChat(context, builder.build(), sdkToken);
    }

    private static final String UDESK_NICK_NAME = "nick_name_key";
    private static final String USER_FILE_NAME = "user_file";

    public static void putUdeskNickName(Context context, String nickName) {
        SharedPreferences sp = context.getSharedPreferences(USER_FILE_NAME, Context.MODE_PRIVATE);
        sp.edit().putString(UDESK_NICK_NAME, nickName).apply();
    }

    public static String getUdeskNickName(Context context) {
        SharedPreferences sp = context.getSharedPreferences(USER_FILE_NAME, Context.MODE_PRIVATE);
        return sp.getString(UDESK_NICK_NAME, "");
    }
}
