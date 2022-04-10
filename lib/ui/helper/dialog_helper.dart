
import 'dart:io';

import 'package:graphic_conversion/model/order_model.dart';
import 'package:graphic_conversion/table/person.dart';
import 'package:graphic_conversion/ui/dialog/conversion_loading_dialog.dart';
import 'package:graphic_conversion/ui/dialog/document_share_dialog.dart';
import 'package:graphic_conversion/ui/dialog/document_title_dialog.dart';
import 'package:graphic_conversion/ui/dialog/permission_dialog.dart';
import 'package:graphic_conversion/ui/dialog/photo_generate_dialog.dart';
import 'package:graphic_conversion/ui/dialog/re_save_dialog.dart';
import 'package:graphic_conversion/ui/dialog/save_dialog.dart';
import 'package:graphic_conversion/ui/dialog/send_email_dialog.dart';
import 'package:graphic_conversion/ui/dialog/tips_dialog.dart';
import 'package:graphic_conversion/ui/dialog/add_person_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/model/app_config.dart';
import 'package:graphic_conversion/model/check_upgrade.dart';
import 'package:graphic_conversion/ui/dialog/agreement_dialog.dart';
import 'package:graphic_conversion/ui/dialog/update_person_dialog.dart';
import 'package:graphic_conversion/ui/dialog/agreement_ensure_dialog.dart';
import 'package:graphic_conversion/ui/dialog/logout_dialog.dart';
import 'package:graphic_conversion/ui/dialog/permission_tipe_dialog.dart';
import 'package:graphic_conversion/ui/dialog/share_dialog.dart';
import 'package:graphic_conversion/ui/dialog/delete_card_dialog.dart';
import 'package:graphic_conversion/ui/dialog/unsubscribe_dialog.dart';
import 'package:graphic_conversion/ui/dialog/extract_result_dialog.dart';
import 'package:graphic_conversion/ui/dialog/update_dialog.dart';
import 'package:graphic_conversion/ui/dialog/vip_dialog.dart';
import 'package:graphic_conversion/ui/dialog/vip_retain_dialog.dart';
import 'package:graphic_conversion/ui/dialog/bind_phone_dialog.dart';
import 'package:graphic_conversion/ui/dialog/document_share_dialog1.dart';
import 'package:graphic_conversion/ui/dialog/document_telephone_dialog.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class DialogHelper {

  static BuildContext dialogContext;

  static Future<bool> showAgreementDialog(
      context, String yhxy, String yszc) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => AgreementDialog(yhxy: yhxy, yszc: yszc),
    );
  }

  static Future<bool> showAgreementEnsureDialog(context) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => AgreementEnsureDialog(),
    );
  }

  static showStartUpdateDialog(
      context,
      MessageInfos messageInfos,
      ) async {
    return await showCupertinoDialog(
        context: context,
        builder: (context) => UpdateDialog(
          url: messageInfos.downloadUrl,
          message: messageInfos.title,
          isForce: messageInfos.messageType == 2,
        ));
  }

  static showCheckUpdateDialog(
      context,
      MessageInfos messageInfos,
      ) async {
    return await showCupertinoDialog(
        context: context,
        builder: (context) => UpdateDialog(
          url: messageInfos.downloadUrl,
          message: messageInfos.title,
          isForce: false,
        ));
  }

  static Future<bool> showPermissionTipDialog(
      context, String permissionStr) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => PermissionTipDialog(permissionStr: permissionStr),
    );
  }

  static showUnsubscribeDialog(context) async {
    var dialog = UnsubscribeDialog();
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showLogOutDialog(
      context, {
        String title,
        String content,
        String cancel,
        String ensure,
      }) async {
    var dialog = LogoutDialog();
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showDeleteCardDialog(
      context, {
        String title,
        String content,
        String cancel,
        String ensure,
        Person person,
      }) async {
    var dialog = DeleteCardDialog(content:content,person:person);
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showDocumentTelephoneDialog(context,{String telephone, TelephoneCallback callback}) async {
    var dialog = DocumentTelephoneDialog(
      title: telephone,
      callback: callback,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showShareDialog(context, {String shareImage}) async {
    var dialog = ShareDialog(shareImage: shareImage,);
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showDocumentShareDialog1(context, {File file, List<TextEditingController> contentControllers, List<TextEditingController> translateControllers,DocumentShareCallback1 callback,String title}) async {
    var dialog = DocumentShareDialog1(
      file: file,
      contentControllers: contentControllers,
      translateControllers: translateControllers,
      callback: callback,
      title: title,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showVipRetainDialog(context,) async {
    var dialog = VipRetainDialog();
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showBindPhoneDialog(context,) async {
    var dialog = BindPhoneDialog();
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }
  static showTipsDialog(
      context, {
        String title = "温馨提示",
        String message,
        String disable,
        String prominent,
        VoidCallback disableCall,
        VoidCallback prominentCall
      }) async {
    var dialog = TipsDialog(
      title: title,
      message: message,
      disable: disable,
      prominent: prominent,
      disableCall: disableCall,
      prominentCall: prominentCall,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showSaveDialog(context, {ClickCallback callback}) async {
    var dialog = SaveDialog(
      callback: callback,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showSendEmailDialog(context, {OrderModel model, VoidCallback callback,}) async {
    var dialog = SendEmailDialog(
      model: model,
      callback: callback,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showPhotoGenerateDialog(context, {VoidCallback callback,}) async {
    var dialog = PhotoGenerateDialog(
      callback: callback,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showVipDialog(context,) async {
    var dialog = VipDialog();
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showDocumentTitleDialog(context,{String title, TitleCallback callback}) async {
    var dialog = DocumentTitleDialog(
      title: title,
      callback: callback,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showAddPersonDialog(context,{String name,String weight}) async {
    var dialog = AddPersonDialog(
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showExtractResultDialog(context,{List<Person> result,String resultDesc,bool isVertical,int type}) async {
    var dialog = ExtractResultDialog(result: result,resultDesc: resultDesc,isVertical: isVertical,type: type,);
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showUpdatePersonDialog(context,{String name,String weight, PersonCallback callback,Person person}) async {
    var dialog = UpdatePersonDialog(
      callback: callback,
      name:name,
      weight:weight,
      person: person,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showDocumentShareDialog(context, {File file, DocumentShareCallback callback}) async {
    var dialog = DocumentShareDialog(
      file: file,
      callback: callback,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static Future showConversionLoadingDialog(context,) async {
    var dialog = ConversionLoadingDialog();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        dialogContext = context;
        return dialog;
      },
    );
  }

  static Future showPermissionDialog(context,) async {
    var dialog = PermissionDialog();
    return showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return dialog;
      },
    );
  }

  static Future<bool> showReSaveDialog(context) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => ReSaveDialog(),
    );
  }

}