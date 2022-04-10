package com.fantasy.simulate.utils;

import android.content.Context;

import com.fantasy.simulate.bean.BasicBean;

public class BasicDataUitl {
	/**
	 * 初始化获取的基本信息方便调用
	 */
	public static BasicBean getBasicData(Context ctx) {
		BasicBean basicModel = new BasicBean();
		basicModel.Channel = Integer.parseInt(AppUtil.getAppMetaDataS(ctx,
				"UMENG_CHANNEL"));
		basicModel.phoneModel = android.os.Build.MODEL;
		basicModel.versionName = AppUtil.getVersion(ctx);
		basicModel.IMEI = AppUtil.getIMEI(ctx);
		basicModel.versionCode = AppUtil.getVersionCode(ctx);
		basicModel.uniqueId = AppUtil.getUniqueid(ctx);
		basicModel.androidver = android.os.Build.VERSION.RELEASE;
		basicModel.androidid = AppUtil.getAndroidId(ctx);
		return basicModel;
	}
}
