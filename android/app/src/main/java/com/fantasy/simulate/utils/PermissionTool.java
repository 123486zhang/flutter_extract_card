package com.fantasy.simulate.utils;

import android.app.Activity;
import android.app.Dialog;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.fantasy.simulate.MyApp;
import com.fantasy.simulate.R;
import com.fantasy.simulate.dialog.BaseDialog;
import com.fantasy.simulate.permission.PermissionManager;
import com.yanzhenjie.permission.AndPermission;
import com.yanzhenjie.permission.runtime.Permission;
import com.yanzhenjie.permission.runtime.PermissionDef;

import java.util.ArrayList;
import java.util.List;

import rx.functions.Action1;


/**
 * Created by XL on 2020/2/8.
 * description:
 */
public class PermissionTool {


    public static void handlePermission(Activity activity, String permissionContent, List<String> permissionContents, Action1<Boolean> action1, @NonNull @PermissionDef String... permission) {

        boolean b = AndPermission.hasPermissions(activity, permission);
        if (b) {
            if (action1 != null) action1.call(true);
            return;
        }

        showPermissionDialog(activity, permissionContents, v1 -> {
            AndPermission.with(activity)
                    .runtime()
                    .permission(permission)
                    .onGranted(permissions -> {
                        // Storage permission are allowed.
                        if (action1 != null) action1.call(true);

                    })
                    .onDenied(permissions -> {
                        if (AndPermission.hasAlwaysDeniedPermission(activity, permissions)) {
                            BaseDialog baseDialog = new BaseDialog(activity);
                            baseDialog.setRightButton("去设置", view -> {
                                baseDialog.dismiss();
                                PermissionManager.goSettingDetail(activity);
                            });
                            baseDialog.setLeftButton("取消", view -> baseDialog.dismiss());
                            baseDialog.setContentText(Html.fromHtml("检测到您未开启<font color='#37A0FF'> " + permissionContent + "</font>，请手动开启"));
                            baseDialog.setTitleText("权限提示");
                            baseDialog.show();
                            // 打开权限设置页
                        }
                        if (action1 != null) action1.call(false);
                        // Storage permission are not allowed.
                    })
                    .start();
        });
    }


    public static void handlePermissionForFlutter(String permissionContents, Callback callback) {
        String[] arr = permissionContents.split(",");
        List<String> permissions = new ArrayList<>();

        for (String s : arr) {
            permissions.add(s);
        }
        ArrayList<String> list = new ArrayList<String>();

        for (String s : permissions) {
            if (s.contains("存储")) {
                list.add(Permission.WRITE_EXTERNAL_STORAGE);
                list.add(Permission.READ_EXTERNAL_STORAGE);
            } else if (s.contains("通讯录")) {
                list.add(Permission.READ_CONTACTS);
            } else if (s.contains("相机")) {
                list.add(Permission.CAMERA);
            }
        }

        String[] strings = new String[list.size()];
        list.toArray(strings);

        boolean b = AndPermission.hasPermissions(MyApp.getInstance(), strings);
        if (b) {
            callback.isAgree(true);
        } else {
            callback.isAgree(false);
        }
    }


    public static void showPermissionDialog(Activity activity, List<String> permissions, View.OnClickListener listener) {
        if (permissions == null || permissions.size() == 0) {
            listener.onClick(null);
            return;
        }
        Dialog dialog = new Dialog(activity, R.style.MaterialDesignDialog);
        dialog.setContentView(R.layout.dlg_permission);
        dialog.setCancelable(false);
        dialog.setCanceledOnTouchOutside(false);
        TextView okBtn = dialog.findViewById(R.id.dlg_right_btn);
        TextView noBtn = dialog.findViewById(R.id.dlg_left_btn);
        LinearLayout layoutPermissions = dialog.findViewById(R.id.layout_permission);
        for (String permission1 : permissions) {
            String permission = permission1;
            if (TextUtils.equals(permission1, "存储权限")) {
                permission = "该权限要获取软件内文件的读、写权限，以保证此软件内的功能可正常使用，若您不想使用该功能，您可以拒绝申请。需要使用此权限的功能有联系客服等功能。";
            } else if (TextUtils.equals(permission1, "相机权限")) {
                permission = "为获取照片消息，我们需要打开摄像头（用于OCR识别、实名认证）、获取文件读、写权限，若您不想使用该功能，您可以拒绝申请。拒绝该权限，不影响除群资源、联系客服外其他功能的使用。";
            } else if (TextUtils.equals(permission1, "通讯录权限")) {
                permission = "我们需要向你申请通讯录读、写权限，如果您不想使用该功能，您可以拒绝申请。拒绝该权限，不影响其他功能的使用。";
            }
            View view = LayoutInflater.from(activity).inflate(R.layout.dlg_view_permission, null);
            TextView tvTitle = view.findViewById(R.id.tvTitle);
            tvTitle.setText(permission1);
            TextView tvMsg = view.findViewById(R.id.tvMsg);
            tvMsg.setText(permission);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            layoutPermissions.addView(view, params);
        }
        okBtn.setOnClickListener(view -> {
            dialog.dismiss();
            listener.onClick(view);
        });
        noBtn.setOnClickListener(view -> {
            dialog.dismiss();
        });
        dialog.show();
    }

    public interface Callback {
        void isAgree(boolean b);
    }
}
