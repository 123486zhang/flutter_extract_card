import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/model/document_model.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';

import '../configs.dart';

class DocumentViewModel extends ChangeNotifier {

  static String kDocument = UserHelper().bmobUserVM.bmobUserModel.objectId;

  List<DocumentModel> _documents = [];

  List<DocumentModel> get documents => _documents;

  set documents(List<DocumentModel> value) {
    _documents = value;
    notifyListeners();
  }

  init() async {
    if (UserHelper().bmobUserVM.hasUser) {
      if(false){
        var userDocumentList = StorageManager.localStorage.getItem(kDocument);
        if(userDocumentList==null||(userDocumentList!=null&&userDocumentList.length<=0)){
          saveDocument();
        }else{
          if(_documents!=null&&_documents.length>0){
            _documents.addAll(userDocumentList);
            saveDocument();
          }
        }
        List<Map<String, dynamic>> list = [];
        StorageManager.localStorage.setItem(UserHelper().bmobUserVM.bmobUserModel.objectId, list);
      }
    }else{
      kDocument = UserHelper().bmobUserVM.bmobUserModel.objectId;
    }
    var documentList = StorageManager.localStorage.getItem(kDocument);
    debugPrint('documentList->${documentList.toString()}');
    if (documentList != null) {
      List<DocumentModel> list = [];
      for (Map document in documentList) {
        DocumentModel model = DocumentModel.fromMap(document);
        String lastCompose = model.imagePath.substring(model.imagePath.lastIndexOf("/") + 1);
        model.imagePath = await CacheAudioManager.getImageFile(lastCompose);
        list.add(model);
      }
      documents = list;
    }
  }

  saveDocument() async {
    List<Map<String, dynamic>> list = [];
    _documents.forEach((document) {
      Map<String, dynamic> jsonMap = document?.toJson();
      list.add(jsonMap);
    });
    StorageManager.localStorage.setItem(kDocument, list);
    notifyListeners();
  }

  addDocument(DocumentModel model) async {
    _documents.insert(0, model);
    await saveDocument();
  }

  changeDocument({int index, DocumentModel model}) {
    _documents.removeAt(index);
    addDocument(model);
  }

  clear() {
    kDocument = UserHelper().bmobUserVM.bmobUserModel.objectId;
    documents = [];
    saveDocument();
  }
}