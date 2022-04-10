package com.fantasy.simulate.utils;

import android.app.Activity;

import com.fantasy.simulate.bean.BasicBean;
import com.fantasy.simulate.bean.PayBean;
import com.fantasy.simulate.db.UserSpUtil;
import com.fantasy.simulate.manager.ApiManager;


/**
 * 支付帮助类
 *
 * @author john
 */
public class PayUtil {

    public static boolean isPay = false;

    public static void pay(final Activity ctx, final PayBean payBean, final PayCallBack callBack) {
//        switch (payBean.payType) {
//            case 0:
//                isPay = true;
//                //支付宝支付
//                ApiManager.payAli(ctx, getAliBody(ctx, payBean), payBean.stype, aBoolean -> {
//                    if (aBoolean) {
//                        callBack.onSuccess("");
//                        isPay = false;
//                    } else {
//                        callBack.onFail();
//                    }
//                });
//                break;
//            case 1:
//                isPay = true;
//                //微信支付
//                ApiManager.payWx(ctx, getWxBody(ctx, payBean), payBean.stype, aBoolean -> {
//                    if (aBoolean) {
//                        callBack.onSuccess("");
//                        isPay = false;
//                    } else {
//                        callBack.onFail();
//                    }
//                });
//                break;
//            default:
//                break;
//        }
    }

    private static String getAliBody(Activity context, PayBean payBean) {
        //imei|chanleid|ver(应用外部版本)|微信包名|uniqueid|model|androidver|应用本身包名|stype(支付类型)|0
        BasicBean model = BasicDataUitl.getBasicData(context);
        String imei = model.IMEI;
        String androidver = model.androidver;
        int channel = model.Channel;
        String versionName = model.versionName;
        String uniqueId = UserSpUtil.getUserId(context);
        String phoneModel = model.phoneModel;
        String str = imei + "|" + channel + "|" + versionName + "|"
                + context.getPackageName() + "|" + uniqueId + "|" + phoneModel
                + "|" + androidver + "|" + ApiManager.PRODUCT_ID + "|" + payBean.stype + "|" + UserSpUtil.getUserId(context);
        return str;
    }

    private static String getWxBody(Activity context, PayBean payBean) {
        //imei|chanleid|ver(应用外部版本)|微信包名|uniqueid|model|androidver|应用本身包名|stype(支付类型)|0
        BasicBean model = BasicDataUitl.getBasicData(context);
        String imei = model.IMEI;
        String androidver = model.androidver;
        int channel = model.Channel;
        String versionName = model.versionName;
        String uniqueId = UserSpUtil.getUserId(context);
        String phoneModel = model.phoneModel;
        String str = imei + "|" + channel + "|" + versionName + "|"
                + context.getPackageName() + "|" + uniqueId + "|" + phoneModel
                + "|" + androidver + "|" + ApiManager.PRODUCT_ID + "|" + payBean.stype + "|" + UserSpUtil.getUserId(context);
        return str;
    }
}
