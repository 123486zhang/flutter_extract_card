package com.fantasy.simulate.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.text.method.LinkMovementMethod;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.fantasy.simulate.R;


/**
 * Created by SPARKE on 2017/11/28.
 */
public class BaseDialog extends Dialog {

    private TextView mTitleView;
    private TextView mContentView;
    private CharSequence mTitleText = null;
    private CharSequence mContentText = null;

    private int mLeftTextColorResId;
    private int mRightTextColorResId;

    private FrameLayout mContainer;
    private int mContainerLayoutId = -1;

    private LinearLayout mBtnContainer;
    private TextView mLeftBtn;
    private TextView mRightBtn;
    private ImageView ivDis;

    private boolean isLinkable = false;
//    private View mBtnDivider;
//    private int mLeftBgResId = R.drawable.image_selector_dlg_left_btn;
//    private int mRightBgResId = R.drawable.image_selector_dlg_right_btn;

    private int mLeftBgResId = -1;
    private int mRightBgResId = -1;

    private CharSequence mLeftText = null;
    private CharSequence mRightText = null;
    private View.OnClickListener mLeftListener;
    private View.OnClickListener mRightListener;

    public BaseDialog(Context context) {
        super(context, R.style.MaterialDesignDialog);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dlg_base);
        mTitleView = findViewById(R.id.dlg_title);
        if (TextUtils.isEmpty(mTitleText)) {
            mTitleView.setVisibility(View.GONE);
        } else {
            mTitleView.setText(mTitleText);
        }

        mContentView = findViewById(R.id.dlg_content);
        if (TextUtils.isEmpty(mContentText)) {
            mContentView.setVisibility(View.GONE);
        } else {

            mContentView.setText(mContentText);

            mContentView.post(new Runnable() {
                @Override
                public void run() {
                    if (mContentView.getLineCount() > 1) mContentView.setGravity(Gravity.LEFT);
                    else mContentView.setGravity(Gravity.CENTER);

                }
            });
        }

        mContainer = findViewById(R.id.dlg_container);
        if (mContainerLayoutId == -1) {
            mContainer.setVisibility(View.GONE);
        } else {
            View childView = LayoutInflater.from(getContext()).inflate(mContainerLayoutId, null);
            mContainer.addView(childView);
            assembleChildView(childView);
        }

        mBtnContainer = findViewById(R.id.ll_button_container);
        if (TextUtils.isEmpty(mLeftText) && TextUtils.isEmpty(mRightText)) {
            mBtnContainer.setVisibility(View.GONE);
        }

//        mBtnDivider = findViewById(R.id.dlg_btn_divider);
//        mBtnDivider.setVisibility(TextUtils.isEmpty(mLeftText) || TextUtils.isEmpty(mRightText) ? View.GONE : View.VISIBLE);

        mLeftBtn = findViewById(R.id.dlg_left_btn);
        if (TextUtils.isEmpty(mLeftText)) {
            mLeftBtn.setVisibility(View.GONE);
        } else {
            mLeftBtn.setVisibility(View.VISIBLE);
            mLeftBtn.setText(mLeftText);
            if (mLeftTextColorResId > 0) {
                mLeftBtn.setTextColor(mLeftTextColorResId);
            }
            if (mLeftBgResId > 0) {
                mLeftBtn.setBackgroundResource(mLeftBgResId);
            }
            if (mLeftListener != null) {
                mLeftBtn.setOnClickListener(mLeftListener);
            }
        }

        mRightBtn = findViewById(R.id.dlg_right_btn);
        if (TextUtils.isEmpty(mRightText)) {
            mRightBtn.setVisibility(View.GONE);
        } else {
            mRightBtn.setVisibility(View.VISIBLE);
            mRightBtn.setText(mRightText);
            if (mRightTextColorResId > 0) {
                mRightBtn.setTextColor(mRightTextColorResId);
            }
            if (mRightBgResId > 0) {
                mRightBtn.setBackgroundResource(mRightBgResId);
            }
            if (mRightListener != null) {
                mRightBtn.setOnClickListener(mRightListener);
            }
        }

//        Window window = getWindow();
//        WindowManager.LayoutParams wlp = window.getAttributes();
//        wlp.gravity = Gravity.CENTER;
//        wlp.width = UtilTool.dip2px(280);
//        wlp.height = WindowManager.LayoutParams.WRAP_CONTENT;
//        window.setAttributes(wlp);

        if (isLinkable) {
            mContentView.setMovementMethod(LinkMovementMethod.getInstance());
        }

//        setCancelable(true);
//        setCanceledOnTouchOutside(true);
    }


    public BaseDialog cancelable(boolean cancelable) {
        setCancelable(cancelable);
        setCanceledOnTouchOutside(cancelable);
        return this;
    }


    public BaseDialog setTitleText(int resId) {
        mTitleText = getContext().getString(resId);
        return this;
    }

    public BaseDialog setTitleText(CharSequence title) {
        mTitleText = title;
        return this;
    }

    public BaseDialog setContentText(int resId) {
        mContentText = getContext().getString(resId);
        return this;
    }

    public BaseDialog setContentText(CharSequence content) {
        mContentText = content;
        return this;
    }

    public BaseDialog setLeftButton(CharSequence left, int bgResId, View.OnClickListener listener) {
        mLeftText = left;
        mLeftListener = listener;
        if (bgResId != -1) {
            mLeftBgResId = bgResId;
        }
        return this;
    }

    public BaseDialog setTextColor(int left, int right) {
        mLeftTextColorResId = left;
        mRightTextColorResId = right;
        return this;
    }

    public BaseDialog setLeftButton(int resId, int bgResId, View.OnClickListener listener) {
        mLeftText = getContext().getString(resId);
        mLeftListener = listener;
        if (bgResId != -1) {
            mLeftBgResId = bgResId;
        }
        return this;
    }

    public BaseDialog setRightButton(CharSequence right, int bgResId, View.OnClickListener listener) {
        mRightText = right;
        mRightListener = listener;
        if (bgResId != -1) {
            mRightBgResId = bgResId;
        }
        return this;
    }


    public BaseDialog setLeftButton(CharSequence left, View.OnClickListener listener) {
        mLeftText = left;
        mLeftListener = listener;

        return this;
    }

    public BaseDialog setRightButton(CharSequence right, View.OnClickListener listener) {
        mRightText = right;
        mRightListener = listener;

        return this;
    }


    public BaseDialog setRightButton(int resId, int bgResId, View.OnClickListener listener) {
        mRightText = getContext().getString(resId);
        mRightListener = listener;
        if (bgResId != -1) {
            mRightBgResId = bgResId;
        }
        return this;
    }

    public BaseDialog setContainer(int resId) {
        mContainerLayoutId = resId;
        return this;
    }

    public void assembleChildView(View childView) {
    }

    public void setLinkable(boolean b) {
        isLinkable = b;
    }
}
