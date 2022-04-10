package com.fantasy.simulate;

import android.content.Context;

import androidx.multidex.MultiDex;

import io.flutter.app.FlutterApplication;

/**
 * Create by 伊哇 at 2021/9/22 9:53
 */
public class MyApp extends FlutterApplication {
    private static MyApp sInstance;

    public static MyApp getInstance() {
        return sInstance;
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        sInstance = this;
        MultiDex.install(this);
    }

    @Override
    public void onCreate() {
        super.onCreate();
    //    Storage.init(this);
     //   initBase();
    }

//    public void initBase() {
//        BaseExternal.init(this, new UserInfoCallback() {
//            @Override
//            public String getUserCode() {
//                String userId = UserSpUtil.getUserId(MyApp.this);
//                return TextUtils.isEmpty(userId) ? "" : userId;
//            }
//
//            @Override
//            public String getAccessToken() {
//                UserModel userModel = UserSpUtil.getUser(MyApp.this);
//                if (userModel != null && !TextUtils.isEmpty(userModel.md5)) {
//                    return userModel.md5;
//                }
//                return "";
//            }
//        });
//    }

//    /**
//     * 初始化api
//     */
//    public void afterPermissionOk() {
//        $.getInstance()
//                .context(this)
//                .build();
//        Api.init(null);
//        BaseExternal.delayInit(this);
//        UdeskSDKManager.getInstance().initApiKey(this, "hnjiyw.udesk.cn", "03c1aeac9349b0521b915d1e6577e164", "24a84b34fd59f509");
//        initUmeng();
//    }

}
