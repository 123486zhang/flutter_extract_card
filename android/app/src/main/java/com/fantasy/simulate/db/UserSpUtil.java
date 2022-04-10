package com.fantasy.simulate.db;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;

import com.fantasy.simulate.bean.UserModel;

/**
 * Created by Felix on 2017/7/24.
 */

public class UserSpUtil {

    public static final String FILE_NAME = "UserSpName";
    public static final String FILE_KEY = "UserSpKey";
    /**
     * 存储用户模型
     *
     * @param context
     * @param userModel
     */
    public static void saveUser(Context context, UserModel userModel) {
        SpHelper.saveObject(context, userModel, FILE_NAME, FILE_KEY);
    }


    /**
     * 获取用户模型
     *
     * @param context
     * @return
     */
    public static UserModel getUser(Context context) {
        if (context == null) {
            return null;
        }
        UserModel userModel = (UserModel) SpHelper.getObject(context, FILE_NAME, FILE_KEY);
        return userModel;
    }

    /**
     * 获取用户id
     *
     * @param context
     * @return
     */
    public static String getUserId(Context context) {
        UserModel userModel = getUser(context);
        if (userModel == null) {
            return "";
        }
        return userModel.uid;
    }

    /**
     * 是否登录
     *
     * @param context
     * @return
     */
    public static boolean isLogin(Context context) {
        return !TextUtils.isEmpty(getUserId(context));
    }


    /**
     * 退出登录
     *
     * @param context
     */
    public static void logout(Activity context) {
        UserSpUtil.saveUser(context, null);
    }


    /**
     * 其他地方登录，清除登录数据
     *
     * @param context
     */
    public static void clearLogin(Activity context) {
        UserSpUtil.saveUser(context, null);
    }
}
