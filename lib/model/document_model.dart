class DocumentModel {
  String title; //name
  String content;
  List<String> contents;
  List<String> translateContents;
  String imagePath; //path
  List<String> imagePaths;
  String createTime;
  List<Map<String, dynamic>> results;
  Map<String, dynamic> result;
  List<String> mobiles;
  int currentIndex=0;

  // Audio Recorder File
  int seconds;
  List<int> dbList;

  static DocumentModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DocumentModel model = DocumentModel();
    model.title = map["title"];
    model.content = map["content"];
   return model;
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
  };
}