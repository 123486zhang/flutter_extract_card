import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/data/net/buried_point_api.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/utils/umeng_utils.dart';

class BuriedPointHelper {

  static const String kBuriedPointDataList = 'kBuriedPointDataList';

  static String buriedPointUrl = "";

  static List<BuriedPointModel> buriedPointDataList = [];

  static Timer timer;

  static init() {
    List dataList = StorageManager.localStorage.getItem(kBuriedPointDataList);
    if (dataList != null)
      buriedPointDataList = List<BuriedPointModel>.from(dataList.map((x) => BuriedPointModel.fromJson(x)));

    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    timer =  new Timer.periodic(new Duration(minutes: 1), (timer) {
      uploadBuriedPointData();
    });
  }

  static addBuriedPointModel(BuriedPointModel model) {
    buriedPointDataList.add(model);
    StorageManager.localStorage.setItem(
        kBuriedPointDataList,
        List<dynamic>.from(buriedPointDataList.map((x) => x.toJson())));
  }

  static clickBuriedPoint({String pageName = "", String clickName = "",}) {
    addBuriedPoint(
      eventType: BuriedPointEventType.CLICK,
      pageName: pageName,
      clickName: clickName,
    );
    UmengUtils.onEventValue(pageName, clickName);
  }

  static addBuriedPoint({
    BuriedPointEventType eventType = BuriedPointEventType.APP_START,
    String pageName = "",
    String clickName = "",
  }) {
    BuriedPointModel model = BuriedPointModel();
    model.eventType = eventType;
    model.pageName = pageName;
    model.clickName = clickName;
    model.createdAt = getBuriedPointCreatedTime();
    addBuriedPointModel(model);
  }

  static uploadBuriedPointData() {
    if (buriedPointDataList.isNotEmpty) {
      BuriedPointApi.requestUploadBuriedPoint(buriedPointDataList).then((value) {
        if (value) clearBuriedPointDataList();
      });
    }
  }

  static clearBuriedPointDataList() {
    buriedPointDataList = [];
    StorageManager.localStorage.setItem(
        kBuriedPointDataList, []);
  }

  static String getBuriedPointCreatedTime() {
    return formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }
}