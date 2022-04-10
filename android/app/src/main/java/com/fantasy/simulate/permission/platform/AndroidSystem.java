package com.fantasy.simulate.permission.platform;

import android.content.Context;

/**
 * Created by spark on 2018/4/24.
 */

public interface AndroidSystem {

    /**
     * 跳转到各自系统设置详情页面
     *
     * @param context 上下文对象
     */
    void goAppSettingDetail(Context context);

    /**
     * 跳转到悬浮窗设置界面
     * @param context
     */
    void applyFloatWindowPermission(Context context);

    /**
     * 检查是否有悬浮窗权限
     * @param context
     * @return
     */
    boolean checkFloatWindowPermission(Context context);
}
