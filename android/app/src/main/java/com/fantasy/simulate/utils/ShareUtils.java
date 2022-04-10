package com.fantasy.simulate.utils;

import android.app.Activity;
import android.graphics.Bitmap;

import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXImageObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXTextObject;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.io.ByteArrayOutputStream;

public class ShareUtils {
    /**
     * 分享到微信
     */
    public static final int type_wx = SendMessageToWX.Req.WXSceneSession;
    /**
     * 分享到微信朋友圈
     */
    public static final int type_wxcircle = SendMessageToWX.Req.WXSceneTimeline;
    public static final String AppId = "wx90e5c342e2e382fc";


    public static void shareText(Activity ctx, String shareTv) {
        IWXAPI api = WXAPIFactory.createWXAPI(ctx, AppId);
        //初始化一个WXTextObject对象
        WXTextObject textObj = new WXTextObject();
        textObj.text = shareTv;
        //用WXTextObject对象初始化一个WXMediaMessage对象
        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = textObj;
        msg.description = shareTv;
        //构造一个Req
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        //transaction字段用于唯一标识一个请求
        req.transaction = buildTransaction("textshare");
        req.message = msg;
        req.scene = type_wx;
        api.sendReq(req);
    }

    public static void shareImage(Activity ctx, Bitmap bitmap,int type) {
        IWXAPI api = WXAPIFactory.createWXAPI(ctx, AppId);
        WXImageObject wxImageObject = new WXImageObject(bitmap);
        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = wxImageObject;
        //设置缩略图

        Bitmap thumbBp = Bitmap.createScaledBitmap(bitmap, 50, 50, true);

        msg.thumbData = bmpToByteArray(thumbBp, true);
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("img");//  transaction字段用
        req.message = msg;
        req.scene = type==1?type_wx:type_wxcircle;
        api.sendReq(req);
    }

    private static byte[] bmpToByteArray(final Bitmap bmp, final boolean needRecycle) {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.PNG, 100, output);
        if (needRecycle) {
            bmp.recycle();
        }

        byte[] result = output.toByteArray();
        try {
            output.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private static String buildTransaction(final String type) {
        return (type == null) ? String.valueOf(System.currentTimeMillis())
                : type + System.currentTimeMillis();
    }
}
