package com.fantasy.simulate.manager;

/**
 * Create by 伊哇 at 2021/9/22 9:52
 *
 * 网络请求处理
 */
public class ApiManager {
    public static final int PRODUCT_ID = 92;

//    /**
//     * 支付宝支付
//     */
//    public static void payAli(Activity ctx, String body, int stype, Callback<Boolean> callback) {
//        try {
//            JSONObject param = new JSONObject();
//            BasicBean model = BasicDataUitl.getBasicData(ctx);
//            param.put("packageName", ctx.getPackageName());
//            param.put("md5", "");
//            param.put("body", body);
//            param.put("chandid", model.Channel + "");
//            param.put("stype", stype);
//            param.put("ver", model.versionName);
//            Log.e("====","==payAli=="+param.toString());
//            Pay.preOrder2(ctx, "alipaysdk", "/api/AliPay/PreOrderV2", param.toString(), 1, callback);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    /**
//     * 微信支付
//     */
//    public static void payWx(Activity ctx, String body, int stype, Callback<Boolean> callback) {
//        try {
//            JSONObject param = new JSONObject();
//            BasicBean model = BasicDataUitl.getBasicData(ctx);
//            param.put("packageName", ctx.getPackageName());
//            param.put("md5", "");
//            param.put("body", body);
//            param.put("chandid", model.Channel + "");
//            param.put("stype", stype);
//            param.put("ver", model.versionName);
//            Log.e("====","==payWx=="+param.toString());
//            Pay.preOrder2(ctx, "wxpaysdk", "/api/OrderPay", param.toString(), 2, callback);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
}
