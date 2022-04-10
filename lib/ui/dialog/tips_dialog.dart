import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:flutter/material.dart';

class TipsDialog extends StatelessWidget {

  final String title;
  final String message;
  final String disable;
  final String prominent;
  final VoidCallback disableCall;
  final VoidCallback prominentCall;

  TipsDialog({this.title, this.message, this.disable, this.prominent, this.disableCall, this.prominentCall});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Container(
              width: 335,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 19,
                            color: ColorHelper.color_333,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    // alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 15, bottom: 25, left: 30, right: 30),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 17,
                        color: ColorHelper.color_333,
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                  Row(
                    children: <Widget>[
                      disable == null
                          ? Container()
                          : Expanded(
                          child: GestureDetector(
                            onTap: disableCall,
                            child: Container(
                              height: 50,
                              alignment: Alignment(0, 0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    disable,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF666666)),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Container(
                        width: 1,
                        height: 15,
                        color: Color(0xFFEEEEEE),
                      ),
                      prominent == null
                          ? Container()
                          : Expanded(
                          child: GestureDetector(
                            onTap: prominentCall,
                            child: Container(
                              height: 50,
                              alignment: Alignment(0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                color: Colors.white,),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    prominent,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF00C27C)),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
