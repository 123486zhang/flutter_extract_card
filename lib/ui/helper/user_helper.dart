import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:graphic_conversion/view_model/document_view_model.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/model/app_config.dart';
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';

class UserHelper {

  AppConfig appConfig;

  UserViewModel get userVM {
    UserViewModel vm = Provider.of<UserViewModel>(rootContext, listen: false);
    return vm;
  }

  DocumentViewModel get documentVM {
    DocumentViewModel vm = Provider.of<DocumentViewModel>(rootContext, listen: false);
    return vm;
  }

  BmobUserViewModel get bmobUserVM {
    BmobUserViewModel vm = Provider.of<BmobUserViewModel>(rootContext, listen: false);
    return vm;
  }


  /// iOS是否能打开微信
  bool iOSCanOpenWX = false;

  // 工厂模式
  factory UserHelper() => _getInstance();

  static UserHelper get instance => _getInstance();
  static UserHelper _instance;

  UserHelper._internal() {
    // 初始化
  }

  static UserHelper _getInstance() {
    if (_instance == null) {
      _instance = new UserHelper._internal();
    }
    return _instance;
  }

  /// 清除本地用户信息
  clearUserInfo() {
    userVM.clearUserModel();
    documentVM.clear();
    bmobUserVM.clear();
  }
}