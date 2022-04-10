
class UserModel {
  String Authorization;
  String unionId;
  String nickName;
  String sex;
  String mobile;
  String userDesc;
  String accessToken;
  String userHeader;
  String userId;
  String userCode;
  String isBindingWechat;
  String userName;
  String vipType;
  String vipEndTime;

  Map<String, dynamic> iosPayInfo = {};

  static UserModel fromLoginMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserModel userBean = UserModel();
    userBean.Authorization = UserModel.noNull(map['Authorization']);
    userBean.unionId = UserModel.noNull(map['unionId']);
    userBean.nickName = UserModel.noNull(map['nickName']);
    userBean.sex = UserModel.noNull(map['sex']);
    userBean.mobile = UserModel.noNull(map['mobile']);
    userBean.userDesc = UserModel.noNull(map['userDesc']);
    userBean.accessToken = UserModel.noNull(map['accessToken']);
    userBean.userHeader = UserModel.noNull(map['userHeader']);
    userBean.userId = UserModel.noNull(map['userId'].toString());
    userBean.userCode = UserModel.noNull(map['userCode'].toString());
    userBean.isBindingWechat = UserModel.noNull(map['isBindingWechat'].toString());
    userBean.userName = UserModel.noNull(map['userName']);
    if (map['iosPayInfo'] is Map) userBean.iosPayInfo = map['iosPayInfo'];
    return userBean;
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserModel userBean = UserModel();
    userBean.Authorization = UserModel.noNull(map['Authorization']);
    userBean.unionId = UserModel.noNull(map['unionId']);
    userBean.nickName = UserModel.noNull(map['nickName']);
    userBean.sex = UserModel.noNull(map['sex']);
    userBean.mobile = UserModel.noNull(map['mobile']);
    userBean.userDesc = UserModel.noNull(map['userDesc']);
    userBean.accessToken = UserModel.noNull(map['accessToken']);
    userBean.userHeader = UserModel.noNull(map['userHeader']);
    userBean.userId = UserModel.noNull(map['userId']);
    userBean.userCode = UserModel.noNull(map['userCode']);
    userBean.isBindingWechat = UserModel.noNull(map['isBindingWechat']);
    userBean.userName = UserModel.noNull(map['userName']);
    userBean.vipType = UserModel.noNull(map['vipType']);
    userBean.vipEndTime = UserModel.noNull(map['vipEndTime']);
    if (map['iosPayInfo'] is Map) userBean.iosPayInfo = map['iosPayInfo'];
    return userBean;
  }

  static dynamic noNull(objc) {
    if (objc == null) {
      return "";
    } else {
      return objc;
    }
  }

  Map<String, dynamic> toJson() => {
    "Authorization": Authorization,
    "unionId": unionId,
    "nickName": nickName,
    "sex": sex,
    "mobile": mobile,
    "userDesc": userDesc,
    "accessToken": accessToken,
    "userHeader": userHeader,
    "userId": userId,
    "userCode": userCode,
    "isBindingWechat": isBindingWechat,
    "userName": userName,
    "vipType": vipType,
    "vipEndTime": vipEndTime,
    "iosPayInfo": iosPayInfo,
  };
}