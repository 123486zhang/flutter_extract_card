
enum BuriedPointEventType {
  APP_START,
  APP_STOP,
  PAGE_SHOW,
  PAGE_HIDE,
  CLICK,
}

final buriedPointEventTypeNameValues = BuriedPointEventTypeEnumValues({
  "appstart": BuriedPointEventType.APP_START,
  "appstop": BuriedPointEventType.APP_STOP,
  "pageshow": BuriedPointEventType.PAGE_SHOW,
  "pagehide": BuriedPointEventType.PAGE_HIDE,
  "click": BuriedPointEventType.CLICK
});

class BuriedPointEventTypeEnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  BuriedPointEventTypeEnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class BuriedPointModel {

  BuriedPointEventType eventType;
  String pageName;
  String clickName;
  String createdAt;

  BuriedPointModel({this.eventType, this.pageName, this.clickName, this.createdAt});

  factory BuriedPointModel.fromJson(Map<String, dynamic> json) => BuriedPointModel(
    eventType: buriedPointEventTypeNameValues.map[json["eventType"]],
    pageName: json["pageName"],
    clickName: json["clickName"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "eventType": buriedPointEventTypeNameValues.reverse[eventType],
    "pageName": pageName,
    "clickName": clickName,
    "createdAt": createdAt,
  };
}