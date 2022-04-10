class AnyEvent {
  static const String REFRESH_VIP = '刷新会员';
  static const String REFRESH_PHONE = '刷新绑定手机';
  static const String REFRESH_HEAD = '刷新头像';
  static const String REFRESH_CARDS = '刷新卡池';
  static const String REFRESH_RECORDS = '刷新记录';
  static const String REFRESH_VOICELIST = '刷新列表';
  static const String Share_Audio = '第三方分享音频';
  static const String Select_Media_Audio = '选择媒体库音乐';
  static const String REFRESH_LOGIN_STATE = '刷新登录状态';

  String type;
  dynamic content;

  AnyEvent(this.type, {this.content});
}
