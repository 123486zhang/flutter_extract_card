class WeChatUser {
  String unionId;
  String openId;
  String name;
  String accessToken;
  String refreshToken;
  String iconurl;
  int expires_in;
  String country;
  String city;
  String province;
  String language;
  String gender;

  static WeChatUser fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    WeChatUser userBean = WeChatUser();
    userBean.unionId = map['uid'];
    userBean.openId = map['openid'];
    userBean.name = map['name'];
    userBean.accessToken = map['accessToken'];
    userBean.refreshToken = map['refreshToken'];
    userBean.iconurl = map['iconurl'];
    userBean.gender = map['gender'];
    userBean.expires_in = map['expires_in'];
    userBean.country = map['country'];
    userBean.city = map['city'];
    userBean.province = map['province'];
    userBean.language = map['language'];

    return userBean;
  }

  Map toJson() => {
        'unionId': unionId,
        'openId': openId,
        'name': name,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'iconurl': iconurl,
        'expires_in': expires_in,
        'country': country,
        'city': city,
        'province': province,
        'language': language,
        'gender': gender,
      };
}
