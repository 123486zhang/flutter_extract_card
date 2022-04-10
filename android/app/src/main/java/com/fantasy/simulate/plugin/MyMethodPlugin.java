package com.fantasy.simulate.plugin;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.fantasy.simulate.utils.PermissionTool;
import com.fantasy.simulate.utils.ShareUtils;
import com.fantasy.simulate.utils.UtilTool;
import com.yanzhenjie.permission.runtime.Permission;
import com.fantasy.simulate.permission.PermissionManager;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.HashMap;

/**
 * 与flutter通信
 * <p>
 * Create by 伊哇 at 2021/9/17 17:44
 */
public class MyMethodPlugin implements MethodChannel.MethodCallHandler {
    private static MethodChannel methodChannel;
    private Activity activity;

    public MyMethodPlugin(Activity activity) {
        this.activity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Activity activity, FlutterEngine flutterEngine) {
        final MyMethodPlugin instance = new MyMethodPlugin(activity);
        instance.onAttachedToEngine(activity, flutterEngine.getDartExecutor().getBinaryMessenger());
    }

    private void onAttachedToEngine(Activity activity, BinaryMessenger messenger) {
        this.activity = activity;
        methodChannel = new MethodChannel(messenger, "plugin/my_method");
        methodChannel.setMethodCallHandler(this);
    }

    private static MethodChannel.Result temp_result = null;

    public static void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == 100 && temp_result != null) {
            boolean has = true;
            for (int grantResult : grantResults) {
                if (grantResult != PackageManager.PERMISSION_GRANTED) {
                    has = false;
                    break;
                }
            }
            temp_result.success(has);
            temp_result = null;
        }
    }

    /**
     * 接收flutter端触发的方法
     */
    @Override
    public void onMethodCall(@NonNull @NotNull MethodCall call, @NonNull @NotNull MethodChannel.Result result) {
        String method = call.method;
        Log.d("onMethodCall","===============>"+method);
        if ("pay".equals(method)) {
//            try {
//                int payType = call.argument("payType");//支付类型 0支付宝 1微信
//                if (payType == 1 && !UtilTool.isWeixinAvilible(activity)) {
//                    UtilTool.showToast(activity, "请先安装微信客户端！");
//                    return;
//                }
//
//                if (payType == 0 && !UtilTool.isAliPayInstalled(activity)) {
//                    ToastLess.$("请先安装支付宝客户端！");
//                    return;
//                }
//
//
//                int stype = call.argument("stype");//会员类型
//                //获取用户信息并存储
//                String userId = call.argument("userId");//userId
//                String md5 = call.argument("md5");//md5
//                String orderAdvance = call.argument("orderAdvance");//orderAdvance
//                String code = call.argument("code");//code
//                String operate = call.argument("operate");//operate
//                UserModel userModel = new UserModel();
//                userModel.uid = userId;
//                userModel.md5 = md5;
//                UserSpUtil.saveUser(activity, userModel);
//                Log.d("onMethodCall","===============>stype:"+stype+"    userId:"+userId+"    code:"+code+"     operate:"+operate+"     orderAdvance:"+orderAdvance+"   payType:"+payType);
//                int payTypeState;
//                if(payType == 0){
//                    payTypeState = 1;
//                }else {
//                    payTypeState = 2;
//                }
//                Pay.perOrder(activity, code, operate, stype, payTypeState, orderAdvance, result::success);
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
        } else if ("getChannelId".equals(method)) {
            String channelId = UtilTool.getChannelId(activity);
            result.success(channelId);
        } else if ("getAndroidId".equals(method)) {
            String androidId = UtilTool.getAndroidId(activity);
            result.success(androidId);
        } else if ("startKf".equals(method)) {
            UtilTool.startKf(activity);
        } else if ("onAgreementPass".equals(method)) {
//            MyApp.getInstance().afterPermissionOk();
        } else if ("checkPermission".equals(method)) {
            String checkPermission = call.argument("permission");
            boolean hasStoragePermission = true;
            boolean hasContactPermission = true;
            boolean hasCameraPermission = true;
            boolean hasAudioPermission = true;
            if (Build.VERSION.SDK_INT >= 23) {
                if (checkPermission.contains("存储")) {
                    hasStoragePermission = ContextCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                            == PackageManager.PERMISSION_GRANTED;
                }
                if (checkPermission.contains("通讯录")) {
                    hasContactPermission = ContextCompat.checkSelfPermission(activity, Manifest.permission.READ_CONTACTS)
                            == PackageManager.PERMISSION_GRANTED;
                }
                if (checkPermission.contains("相机")) {
                    hasCameraPermission = ContextCompat.checkSelfPermission(activity, Manifest.permission.CAMERA)
                            == PackageManager.PERMISSION_GRANTED;
                }
                if (checkPermission.contains("麦克风")) {
                    hasAudioPermission = ContextCompat.checkSelfPermission(activity, Manifest.permission.RECORD_AUDIO)
                            == PackageManager.PERMISSION_GRANTED;
                }
            }
            result.success(hasStoragePermission && hasContactPermission && hasCameraPermission);
        } else if ("requestPermission".equals(method)) {
            String requestPermission = call.argument("permission");
            ArrayList<String> list = new ArrayList<>();

            if (requestPermission.contains("存储")) {
                list.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
                list.add(Manifest.permission.READ_EXTERNAL_STORAGE);
            }

            if (requestPermission.contains("通讯录")) {
                list.add(Manifest.permission.READ_CONTACTS);
            }

            if (requestPermission.contains("相机")) {
                list.add(Manifest.permission.CAMERA);
            }
            if (requestPermission.contains("麦克风")) {
                list.add(Manifest.permission.RECORD_AUDIO);
            }

            String[] arr = list.toArray(new String[list.size()]);

            if (Build.VERSION.SDK_INT >= 23) {
                temp_result = result;
                activity.requestPermissions(arr, 100);
            } else {
                result.success(true);
            }
        }else if ("goPermissionSetting".equals(method)) {
            PermissionManager.goSettingDetail(activity);
        } else if ("handlePermission".equals(method)) {
            String permissionStr = call.argument("permission");
            PermissionTool.handlePermissionForFlutter(permissionStr, new PermissionTool.Callback() {
                @Override
                public void isAgree(boolean b) {
                    result.success(b);
                }
            });
        } else if ("shareImage".equals(method)) {
            List<String> permissions = new ArrayList<>();
            permissions.add("存储权限");
            PermissionTool.handlePermission(activity, "存储权限", permissions, aBoolean -> {
                if (aBoolean) {
                    byte[] bytes = call.argument("bytes");
                    int type = call.argument("type");
                    Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes != null ? bytes.length : 0);
                    ShareUtils.shareImage(activity, bitmap, type);
                } else {
                    UtilTool.showToast(activity, "请允许权限后重试！");
                    result.success(null);
                }
            }, Permission.WRITE_EXTERNAL_STORAGE, Permission.READ_EXTERNAL_STORAGE);
        } else if (TextUtils.equals("uploadLog", method)) {
//            UploadLog.get().uploadEx(result::success);
        } else if ("onPageStart".equals(method)) {
            String pageName = call.argument("pageName");
//            MobclickAgent.onPageStart(pageName);
        } else if ("onPageEnd".equals(method)) {
            String pageName = call.argument("pageName");
//            MobclickAgent.onPageEnd(pageName);
        } else if ("onEvent".equals(method)) {
            String eventId = call.argument("eventId");
        } else if ("onEventValue".equals(method)) {
            String eventId = call.argument("eventId");
            String value = call.argument("value");
            HashMap<String, String> map = new HashMap<>();
            map.put("value", value);
        } else {
            result.notImplemented();
        }
    }
}
