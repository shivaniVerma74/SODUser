import 'package:ez/Helper/helperFunction.dart';
import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/newUI/newTabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'booking.dart';
import 'home1.dart';
// ignore: must_be_immutable
class PlaceOrderSuccess extends StatefulWidget {
  String? price;
  PlaceOrderSuccess({this.price});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<PlaceOrderSuccess> {
  final GlobalKey<ScaffoldState> _scaffoldsKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookingScreen()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("ORDER CONFIRMED"),
                    content: Text("Thank you order has been confirmed!"),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 40),
                              primary: appColorOrange
                          ),
                          child: Text("Back To Home", style: TextStyle(color: colors.primary),),
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> TabbarScreen()));
                          },
                        ),
                      ),
                    ],
                  );
                }
            );
            return true;
          },
          child:
          Scaffold(key: _scaffoldsKey, body: mainBody())
      );
  }

  Widget mainBody() {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: appColorWhite,
          body: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(child: Image.asset("assets/images/place order.png")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Order Confirmed",
                          style: TextStyle(
                              color: appColorBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30),
                      child: Text(
                        "Thank you! your ordered has been Confirmed.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              bottom()
            ],
          ),
        ),
      ],
    );
  }

  Widget top(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                  BoxDecoration(color: appGreen, shape: BoxShape.circle),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TabbarScreen()),
              );
            },
            child: SizedBox(
                height: 60,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                      color: appColorOrange,
                      // gradient: new LinearGradient(
                      //     colors: [
                      //       const Color(0xFF4b6b92),
                      //       const Color(0xFF619aa5),
                      //     ],
                      //     begin: const FractionalOffset(0.0, 0.0),
                      //     end: const FractionalOffset(1.0, 0.0),
                      //     stops: [0.0, 1.0],
                      //     tileMode: TileMode.clamp),
                      // border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: 50.0,
                  // ignore: deprecated_member_use
                  child: Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Back to Home ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: backgroundblack,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
