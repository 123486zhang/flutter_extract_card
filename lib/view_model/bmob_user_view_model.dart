import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/model/user_model.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';

class BmobUserViewModel extends ChangeNotifier {
  static const String kUser = 'bmobUser';

  // bool get isVip => hasUser
  //     && userModel.vipType != null
  //     && userModel.vipType.isNotEmpty
  //     && userModel.vipType != "0";

  bool get isVip => _userModel.isVip; //测试有vip

  String get vipEndAt =>_userModel.vipEndAt;

  bool get isExpire => DateTime.parse(_userModel.vipEndAt).isBefore(DateTime.now()); //

  BmobUser _userModel;

  BmobUser get bmobUserModel => _userModel;

  bool get hasUser =>
      (_userModel.objectId != null) && (_userModel.objectId.isNotEmpty);

  BmobUserViewModel() {
    var userMap = StorageManager.localStorage.getItem(kUser);
    debugPrint('userMap->${userMap.toString()}');
    bmobUserModel =
        userMap != null ? BmobUser().fromJsons(userMap) : BmobUser();
  }

  set bmobUserModel(BmobUser model) {
    _userModel = model;
    notifyListeners();
    // UserHelper().userVM = this;
    StorageManager.localStorage.setItem(kUser, _userModel);
  }

  /// 清除本地持久化的用户数据
  clear() {
    _userModel.objectId = null;
    _userModel.username = null;
    _userModel.password = null;
    _userModel.mobilePhoneNumber = null;
    _userModel.coins = null;
    _userModel.email = null;
    _userModel.isVip=null;
    bmobUserModel = _userModel;
  }
}
