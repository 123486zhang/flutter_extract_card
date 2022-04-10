/// Version : ""
/// InnerVersion : 0
/// UpdateTime : ""
/// UpdateContent : ""
/// Url : ""
/// Message : ""
/// Status : 0

class CheckUpgrade {
  String Version;
  int InnerVersion;
  String UpdateTime;
  String UpdateContent;
  String Url;
  String Message;
  int Status;

  static CheckUpgrade fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CheckUpgrade checkUpgradeBean = CheckUpgrade();
    checkUpgradeBean.Version = map['Version'];
    checkUpgradeBean.InnerVersion = map['InnerVersion'];
    checkUpgradeBean.UpdateTime = map['UpdateTime'];
    checkUpgradeBean.UpdateContent = map['UpdateContent'];
    checkUpgradeBean.Url = map['Url'];
    checkUpgradeBean.Message = map['Message'];
    checkUpgradeBean.Status = map['Status'];
    return checkUpgradeBean;
  }

  Map toJson() => {
        "Version": Version,
        "InnerVersion": InnerVersion,
        "UpdateTime": UpdateTime,
        "UpdateContent": UpdateContent,
        "Url": Url,
        "Message": Message,
        "Status": Status,
      };
}
