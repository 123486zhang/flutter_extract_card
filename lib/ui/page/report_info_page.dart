import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/widget/navigation_back_button.dart';
import 'package:graphic_conversion/ui/widget/navigator_title.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ReportInfoPage extends StatefulWidget {

  @override
  _ReportInfoPageState createState() => _ReportInfoPageState();
}

class _ReportInfoPageState extends State<ReportInfoPage> {
  bool _isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NabigationBackButton.back(context),
        centerTitle: true,
        elevation: 0.5,
        title: NavigatorTitle(title: "用户参与和用户反馈",),
      ),
      body: _isAgree ? buildReportSuccess() : Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextHelper.TextCreateWith(
                    maxLines: 10000,
                    fontSize: 15,
                    text: "      欢迎您加入“用户反馈项目”，为了改善产品的用户体验，我们需要采集部分用户数据（包括终端属性数据和产品使用数据等），汇总之后分析统计这些数据以持续不断地提升产品的操作体验、运行性能，有针对性地改善功能设计，推出对用户有帮助的新功能和新服务等。在未经您许可的情况下，本软件不会将信息披露或向第三方提供；本协议是参与用户反馈体验的不可分割的一部份，一旦您选择【参与用户体验反馈】[类似“同意”按钮的选项]并进行后续操作，即表示您同意遵循本协议条款之所有约定。如果您有任何疑问、意见或建议，请通过以下任意一种方式与我们取得联系：\n"
                          "1.电子邮箱：【2146185892@qq.com】；\n"
                          "2.客服热线：【4006530189 】（服务时间：9：00-24：00）。\n"
                          "请您仔细阅读《用户反馈项目》的具体内容\n"
                          "1、适用范围\n"
                          "1)设备属性，如操作系统、硬件版本、设备设置、设备载体、设备安装应用、设备广告标识符等；\n"
                          "2)除终端信息之外，我们还需要采集一些与操作行为相关的特定数据，比如您与产品交互中的特定适用行为，当前功能名称等；\n"
                          "3)我们承诺，在此项计划中绝不会涉及您的个人身份信息或隐私数据，包括姓名、地址、电子邮箱、财务信息、付款信息、身份证号、非公开的电话簿或联系人等。\n"
                          "2、信息的使用\n"
                          "我们搜集到您的相关信息之后，可能自己对相关信息进行统计分析，并以以下一种或者多种形式使用该汇总分析结果：\n"
                          "1)通过分析结果，改进产品的功能体验等；\n"
                          "2)其他基于统计层面结果的应用行为。\n"
                          "3、信息的储存\n"
                          "本软件收集的有关您的信息和资料将保存在本软件及（或）其关联公司的服务器上，这些信息和资料可能传送至您所在国家、地区或本软件收集信息和资料所在地的境外并在境外被访问、存储和展示。\n"
                          "4、信息安全\n"
                          "1)本软件不会将您的信息披露给不受信任的第三方。\n"
                          "2)根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；\n"
                          "3)如您出现违反中国有关法律、法规或者相关规则的情况，需要向第三方披露。\n"
                          "5、您不应以任何将会违反国家、地方法律法规、行业惯例和社会公共道德，及影响、损害或可能影响、损害本软件利益的方式或目的使用本用户反馈服务；\n"
                          "6、您理解并认可，我们保留随时修改、取消、增强用户反馈服务一项或多项功能或全部服务的权利，如修改或增强功能的，我们有权要求您使用最新更新的版本；届时，我们将以提前通过在软件内合适版面发布公告或发送站内通知等方式通知您；\n"
                          "7、如果本协议条款中的任何条款无论因何种原因完全或部分无效或不具有执行力，或违反任何适用的法律，则该条款被视为删除，但本协议条款的其余条款仍应有效并且有约束力；\n"
                          "8、本协议条款受中华人民共和国法律管辖。在执行本协议条款过程中如发生纠纷，双方应及时协商解决。协商不成时，任何一方可直接向长沙市岳麓区人民法院提起诉讼。\n",
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: () {
                if (Platform.isAndroid) {
                  AndroidMethodChannel.uploadLog();
                }
                setState(() {
                  _isAgree = true;
                });
              },
              child: Container(
                height: ScreenUtil().setHeight(50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFF00C27C),
                ),
                child: TextHelper.TextCreateWith(
                  text: "同意协议并上报反馈",
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildReportSuccess() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(80),),
              Image.asset(
                ImageHelper.imageRes("report_success.png"),
                width: ScreenUtil().setWidth(90),
                height: ScreenUtil().setHeight(90),
              ),
              SizedBox(height: ScreenUtil().setHeight(15),),
              TextHelper.TextCreateWith(
                text: "成功参与用户体验反馈",
                fontSize: 15,
              )
            ],
          )
        ],
      ),
    );
  }
}
