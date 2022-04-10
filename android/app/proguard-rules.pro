#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in D:\android_sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontpreverify
-verbose

-obfuscationdictionary dic.txt
-classobfuscationdictionary dic.txt
-packageobfuscationdictionary dic.txt

-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-ignorewarnings

 -renamesourcefileattribute SourceFile
 -keepattributes SourceFile,LineNumberTable

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends java.io.Serializable
-keep public class com.tencent.mm.** {*;}
-keep public class com.tencent.mm.opensdk.** {*;}
-keep public class com.tencent.wxop.** {*;}
-keep public class com.tencent.mm.sdk.** {*;}
-keep public class com.alipay.** {*;}
-keep public class com.ta.utdid2.** {*;}
-keep public class com.ut.device.** {*;}
-keep public class org.json.alipay.** {*;}
-keep public class com.google.gson.Gson.** {*;}
-dontwarn com.alibaba.fastjson.**
-keep class com.alibaba.fastjson.** {*;}
-keep class net.sourceforge.pinyin4j.** {*;}
-keep class com.hp.hpl.sparta.** {*;}
-keep class com.umeng.** {*;}
-keep public class com.felix.jypay.** {*;}
-keep public class com.we.keyuan.bean.**{*;}

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends java.lang.Throwable {*;}
-keep public class * extends java.lang.Exception {*;}

-keep class com.alipay.android.app.IAlixPay{*;}
-keep class com.alipay.android.app.IAlixPay$Stub{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback$Stub{*;}
-keep class com.alipay.sdk.app.PayTask{ public *;}
-keep class com.alipay.sdk.app.AuthTask{ public *;}
-keep class com.alipay.sdk.app.H5PayCallback {
    <fields>;
    <methods>;
}
-keep class com.alipay.android.phone.mrpc.core.** { *; }
-keep class com.alipay.apmobilesecuritysdk.** { *; }
-keep class com.alipay.mobile.framework.service.annotation.** { *; }
-keep class com.alipay.mobilesecuritysdk.face.** { *; }
-keep class com.alipay.tscenter.biz.rpc.** { *; }
-keep class org.json.alipay.** { *; }
-keep class com.alipay.tscenter.** { *; }
-keep class com.ta.utdid2.** { *;}
-keep class com.ut.device.** { *;}
-keep class org.apache.http.** { *;}
-keep public class com.felix.jypay.** {*;}
-keep public class com.we.keyuan.floatwindow.FloatWindowService {*;}
-keep public class rx.internal.util.** {*;}
-keepclasseswithmembernames class * {
    native <methods>;
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;

}

-keep class com.we.keyuan.widget.** { *; }

# 如果有引用v4包可以添加下面这行
-keep public class * extends android.support.v4.app.Fragment

# 如果引用了v4或者v7包
-dontwarn android.support.**

# 如果引用了androidx包
-keep class com.google.android.material.** {*;}
-keep class androidx.** {*;}
-keep public class * extends androidx.**
-keep interface androidx.** {*;}
-dontwarn com.google.android.material.**
-dontnote com.google.android.material.**
-dontwarn androidx.**

# 保持 native 方法不被混淆
-keepclasseswithmembernames class * {
    native <methods>;
}
# greendao
-keep class org.greenrobot.greendao.**{*;}
-keepclassmembers class * extends org.greenrobot.greendao.AbstractDao {
public static java.lang.String TABLENAME;
}
-keep class **$Properties

# 保护注解
-keepattributes *Annotation*
-keep class * implements java.lang.annotation.Annotation {*;}

# 泛型与反射
-keepattributes Signature
-keepattributes EnclosingMethod

# 不混淆内部类
-keepattributes InnerClasses

# gson
-dontwarn com.google.**
-keep class com.google.gson.** {*;}



-keepclassmembers class **.R$* {
    public static <fields>;
}

-keepattributes Signature
-keepattributes EnclosingMethod

# 友盟统计R.java删除问题
-keep public class com.gdhbgh.activity.R$*{
    public static final int *;
}
# 友盟统计
-keepclassmembers class * {
    public <init> (org.json.JSONObject);
}


# 友盟统计5.0.0以上SDK需要
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
# OkHttp
-dontwarn com.squareup.okhttp.**
-keep class com.squareup.okhttp.** {*;}
-keep interface com.squareup.okhttp.** {*;}
-dontwarn okio.**

#所有bean都不要混淆
-keep class * implements java.io.Serializable {*;}
-keepclassmembers class * implements java.io.Serializable {*;}

-dontwarn com.jayfeng.lesscode.**

-dontwarn com.kingja.loadsir.**
-keep class com.kingja.loadsir.** {*;}

-dontoptimize
-dontpreverify

 -keepclassmembers class ** {
     public void onEvent*(**);
 }

#========================protobuf================================
-keep class com.google.protobuf.** {*;}

-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}
# tinker混淆规则
-dontwarn com.tencent.tinker.**
-keep class com.tencent.tinker.** { *; }

# 二维码库
-keep public class com.uuzuche.lib_zxing.** {*;}

#客服
-keep class udesk.** {*;}
-keep class cn.udesk.**{*; }

-keep class okhttp3.** {*;}
-keep class okio.** {*;}
-keep class com.qiniu.**{*;}
-keep class com.qiniu.**{public <init>();}
-ignorewarnings

-keep class org.jxmpp.** {*;}
-keep class de.measite.** {*;}
-keep class org.jivesoftware.** {*;}
-keep class org.xmlpull.** {*;}
-dontwarn org.xbill.**
-keep class org.xbill.** {*;}


-keepattributes *Annotation*
-keepclassmembers class ** {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }

# Only required if you use AsyncExecutor
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}


-keep class com.facebook.** {*; }
-keep class com.facebook.imagepipeline.** {*; }
-keep class com.facebook.animated.gif.** {*; }
-keep class com.facebook.drawee.** {*; }
-keep class com.facebook.drawee.backends.pipeline.** {*; }
-keep class com.facebook.imagepipeline.** {*; }
-keep class bolts.** {*; }
-keep class me.relex.photodraweeview.** {*; }

-keep,allowobfuscation @interface com.facebook.common.internal.DoNotStrip
-keep @com.facebook.common.internal.DoNotStrip class *
-keepclassmembers class * {
    @com.facebook.common.internal.DoNotStrip *;
}
# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

-dontwarn okio.**
-dontwarn com.squareup.okhttp.**
-dontwarn okhttp3.**
-dontwarn javax.annotation.**
-dontwarn com.android.volley.toolbox.**
-dontwarn com.facebook.infer.**

-keep class io.agora.**{*;}



# MiPush
#这里com.xiaomi.mipushdemo.DemoMessageRreceiver改成app中定义的完整类名
-keep class com.xiaomi.mipush.sdk.DemoMessageReceiver {*;}
#可以防止一个误报的 warning 导致无法成功编译，如果编译使用的 Android 版本是 23。
-dontwarn com.xiaomi.push.**

#Bugly
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}
# tinker混淆规则
-dontwarn com.tencent.tinker.**
-keep class com.tencent.tinker.** { *; }
 -keep class android.support.**{*;}

#多开
-keep class android.content.pm.**{*;}
-keepclasseswithmembers class com.lody.virtual.client.core.VirtualCore{
    <fields>;
    <methods>;
}

-keepclasseswithmembers class io.virtualapp.delegate.MyAppRequestListener {
    <fields>;
    <methods>;
}
-keepclasseswithmembers class com.lody.virtual.client.NativeEngine {
    <fields>;
    <methods>;
}
-keep class com.lody.virtual.client.natives.NativeMethods.**{*;}
-keep class com.lody.virtual.client.hook.proxies.**{*;}
-keep class com.huihui.newmultplugin.widget.**{*;}
-keep class com.huihui.newmultplugin.bean.**{*;}
-keep class com.huihui.newmultplugin.db.**{*;}
-keep class aidl.android.**{*;}
-keep class android.**{*;}
-keep class com.lody.virtual.server.**{*;}
-keep class * implements android.os.IInterface {*;}
#-keep class com.lody.virtual.server.**{*;}
#-keep class com.lody.virtual.client.**{*;}
-keep class com.lody.virtual.**{*;}
-keep class android.content.**{*;}
-keep class mirror.**{*;}

-keepclasseswithmembernames class * {
    native <methods>;
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# 实名
-keep class com.xinyan.** {*; }

# 分身里面的一些东西
 -keep public class org.zeroturnaround.zip.** {*;}
 -keep public class kellinwood.** {*;}
 -keep public class org.spongycastle.** {*;}
 -keep public class org.bouncycastle.** {*;}

 -keep class cn.linkface.** { *; }

 -keep public class com.dannyspark.dex.** {*;}
 -keep public class com.dannyspark.functions.** {*;}


 # ohter
 -keep class com.sangcomz.fishbun.** {*;}

 #垃圾代码混淆
 -keep class cn.fantasy.earth.ui.** {*;}
