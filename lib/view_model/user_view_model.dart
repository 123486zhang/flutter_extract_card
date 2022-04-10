import 'package:flutter/material.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/model/user_model.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';

class UserViewModel extends ChangeNotifier {
  static const String kUser = 'kUser';

  bool get isVip => hasUser
      && userModel.vipType != null
      && userModel.vipType.isNotEmpty
      && userModel.vipType != "0";

 // bool get isVip => true; //测试有vip

  UserModel _userModel;

  UserModel get userModel => _userModel;

  bool get hasUser => (_userModel.userId != null)&&(_userModel.userId.isNotEmpty);

  UserViewModel() {
    var userMap = StorageManager.localStorage.getItem(kUser);
    debugPrint('userMap->${userMap.toString()}');
    userModel = userMap != null ? UserModel.fromMap(userMap) : UserModel();
  }

  set userModel(UserModel model) {
    _userModel = model;
    notifyListeners();
    // UserHelper().userVM = this;
    StorageManager.localStorage.setItem(kUser, _userModel);
  }

  /// 获取用户会员信息
  getUserInfo() async {
    var value = await FIZZApi.requestGetUserInfo();
    if (value != null) {
      var model = userModel;
      model.vipType = CommonUtils.noNull(value["vipType"].toString());
      model.vipEndTime = CommonUtils.noNull(value["vipEndTime"]);
      model.mobile = CommonUtils.noNull(value["mobile"]);
      userModel = model;
    }
  }

  /// 清除本地持久化的用户数据
  clearUserModel() {
    _userModel.userId = null;
    _userModel.Authorization = null;
    _userModel.unionId = null;
    _userModel.nickName = null;
    _userModel.sex = null;
    _userModel.mobile = null;
    _userModel.userDesc = null;
    _userModel.accessToken = null;
    _userModel.userHeader = "";
    _userModel.userCode = null;
    _userModel.isBindingWechat = null;
    _userModel.userName = null;
    _userModel.vipType = null;
    _userModel.vipEndTime = null;
    userModel = _userModel;
  }
}
