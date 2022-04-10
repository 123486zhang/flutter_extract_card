
import 'package:graphic_conversion/view_model/document_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';

import '../bmob_user_view_model.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (ctx) => UserViewModel(),),
  ChangeNotifierProvider(create: (ctx) => DocumentViewModel(),),
  ChangeNotifierProvider(create: (ctx) => BmobUserViewModel(),),
];

BuildContext rootContext;
BuildContext navigatorContext;