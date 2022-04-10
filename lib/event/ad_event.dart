class AdEvent {
  static const String AD_PangolinInit = '穿山甲初始化';
  static const String AD_TencentInit = '优量汇初始化';
  static const String AD_SplashOnShow = 'AD_SplashOnShow';
  static const String AD_SplashOnFail = 'AD_SplashOnFail';
  static const String AD_SplashOnClose = 'AD_SplashOnClose';
  static const String AD_SplashOnClick = 'AD_SplashOnClick';
  static const String AD_BannerOnShow = 'AD_BannerOnShow';
  static const String AD_BannerOnFail = 'AD_BannerOnFail';
  static const String AD_BannerOnClose = 'AD_BannerOnClose';
  static const String AD_BannerOnClick = 'AD_BannerOnClick';
  static const String AD_RewardOnShow = 'AD_RewardOnShow';
  static const String AD_RewardOnClose = 'AD_RewardOnClose';
  static const String AD_RewardOnClick = 'AD_RewardOnClick';
  static const String AD_RewardOnFail = 'AD_RewardOnFail';
  static const String AD_RewardOnReady = 'AD_RewardOnReady';
  static const String AD_RewardOnUnReady = 'AD_RewardOnUnReady';
  static const String AD_RewardOnVerify = 'AD_RewardOnVerify';
  static const String AD_ShowStatusUpdated = 'AD_ShowStatusUpdated';


  String type;
  dynamic content;

  AdEvent(this.type, {this.content});
}