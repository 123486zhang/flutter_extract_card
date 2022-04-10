package com.fantasy.simulate.bean;

import android.text.TextUtils;

import java.io.Serializable;

/**
 * Created by Felix on 2017/10/9.
 */

public class UserModel implements Serializable {
    public String uid;
    public String name;
    public String headimgurl;
    public String phonenumber;
    public String province;
    public String city;
    public String county;
    public String md5;
    public int isBindPhone; //0绑定,1未绑定
    public int loginType;//0表示微信录 1表示手机登录
    public int isValidation; // 是否实名 是：1 否：0
    public boolean IsSetPassword;

    public UserModel() {
        this.uid = "";
        this.name = "";
        this.headimgurl = "";
        this.phonenumber = "";
        this.province = "";
        this.city = "";
        this.county = "";
    }

    /**
     * 是否是微信登錄
     *
     * @return
     */
    public boolean isWechatLogin() {

        return !isNumberString(uid);
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
}
