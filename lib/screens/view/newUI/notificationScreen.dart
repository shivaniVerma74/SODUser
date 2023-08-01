import 'dart:convert';
import 'package:ez/constant/global.dart';
import 'package:ez/constant/sizeconfig.dart';
import 'package:ez/screens/view/models/bookingNotification_modal.dart';
import 'package:ez/screens/view/models/notification_modal.dart';
import 'package:ez/screens/view/newUI/viewBookingNotification.dart';
import 'package:ez/screens/view/newUI/viewNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => new _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  NotificationModal? modal;
  BookingNotificationModal? bookingNotificationModal;
  @override
  void initState() {
    _getData();
    // _getData2();
    super.initState();
  }

  String? user_id;
  _getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user_id = preferences.getString("user_id");
    var headers = {
      'Cookie': 'ci_session=a9c3a2d504a09aaaeb6c54079ea0a95605d28ccf'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}notifications_user'));
    request.fields.addAll({
      'user_id': user_id.toString(),
    });
    print("notification para${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = NotificationModal.fromJson(json.decode(finalResponse));
      print("notifictionnnn$jsonResponse");
      setState(() {
        modal = NotificationModal.fromJson(json.decode(finalResponse));
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  // _getData2() async {
  //   var uri = Uri.parse('${baseUrl()}/booking_notification_listing');
  //   var request = new http.MultipartRequest("Post", uri);
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //   };
  //   request.headers.addAll(headers);
  //   request.fields.addAll({'user_id': userID});
  //   request.fields['user_id'] = userID;
  //   var response = await request.send();
  //   print("booking listing here ${response.statusCode}");
  //   String responseData = await response.stream.transform(utf8.decoder).join();
  //   var userData = json.decode(responseData);
  //   if (mounted) {
  //     setState(() {
  //       bookingNotificationModal = BookingNotificationModal.fromJson(userData);
  //       // print("notification list is here ${bookingNotificationModal!.notifications!.length}");
  //     });
  //   }
  // }


  Future<Null> refreshFunction()async{
    await _getData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: new BoxDecoration(),
      child: Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
              )
          ),
          backgroundColor: backgroundblack,
          elevation: 2,
          title: Text(
            'Notification',
            style: TextStyle(color: appColorWhite, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading:  Padding(
            padding: const EdgeInsets.all(12),
            child: RawMaterialButton(
              shape: CircleBorder(),
              padding: const EdgeInsets.all(0),
              fillColor: Colors.white,
              splashColor: Colors.grey[400],
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: appColorBlack,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refreshFunction,
          child: modal?.data?.length == null || modal?.data?.length == " " ? Center(child: CircularProgressIndicator(color: backgroundblack,),):
          Column(
            children: [
              Container(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: DefaultTabController(
                    length: 1,
                    initialIndex: 0,
                    child: Column(
                      children: <Widget>[
                        /*Container(
                          width: 250,
                          height: 40,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[300]),
                          child: Center(
                            child: TabBar(
                              labelColor: appColorWhite,
                              unselectedLabelColor: appColorBlack,
                              labelStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: appColorWhite,
                                  fontWeight: FontWeight.bold),
                              unselectedLabelStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: appColorBlack,
                                  fontWeight: FontWeight.bold),
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xFF619aa5)),
                              tabs: <Widget>[
                                Tab(
                                  text: 'Orders',
                                ),
                                Tab(
                                  text: 'Booking',
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              orderWidget(),
                              // bookingWidget()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderWidget() {
    return
      modal!.data == null ||  modal!.data == " "
        ? Align(
            alignment: Alignment.center,
            child: Container(
                height: 20,
                width: 20,
                child: Image.asset("assets/images/loader1.gif"),
                ),
          )
        : Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: modal!.data!.length,
                    itemBuilder: (context, index) => dataWidget(index)),
              );
            // Container(
            //     height: SizeConfig.screenHeight,
            //     child: Padding(
            //       padding: const EdgeInsets.only(bottom: 100),
            //       child: Center(
            //           child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Container(
            //             width: double.infinity,
            //             child: Image.asset(
            //               "assets/images/emptyNotification.png",
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //           Text(
            //             'Notification list is empty',
            //             style: TextStyle(
            //                 fontSize: 17, fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       )
            //       ),
            //     ),
            //   );
  }

  Widget dataWidget(int index) {
    return Column(
      children: [
        Container(
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(5.0),
            child: InkWell(
              splashColor: Colors.grey[200],
              focusColor: Colors.grey[200],
              highlightColor: Colors.grey[200],
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ViewNotification(
                //           products: modal!.notifications![index].products!)),
                // );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   decoration: BoxDecoration(
                    //       color: index % 3 == 0
                    //           ? Color(0xFFE9E4B2)
                    //           : index % 3 == 1
                    //               ? Color(0xFFEBBFA1)
                    //               : Color(0xFFC6D3EF),
                    //       shape: BoxShape.circle),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: modal!.notifications![index].title ==
                    //             "Order Placed"
                    //         ? Image.asset(
                    //             "assets/images/orderPlaced.png",
                    //           )
                    //         : modal!.notifications![index].title ==
                    //                 "Order Dispatch"
                    //             ? Image.asset(
                    //                 "assets/images/order Dispatch.png",
                    //                 height: 20)
                    //             : modal!.notifications![index].title ==
                    //                     "Order Deliver"
                    //                 ? Image.asset(
                    //                     "assets/images/orderDeliver.png",
                    //                     height: 20)
                    //                 : modal!.notifications![index].title ==
                    //                         "Order Cancel"
                    //                     ? Image.asset(
                    //                         "assets/images/orderCancel.png",
                    //                         height: 20)
                    //                     : Icon(
                    //                         FontAwesomeIcons.truckMonster,
                    //                         size: 20,
                    //                         color:
                    //                             Colors.black.withOpacity(0.2),
                    //                       ),
                    //   ),
                    // ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Title: ${modal!.data![index].title!}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: appColorGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Order Id: ${modal!.data![index].dataId}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: appColorGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Message: ${modal!.data![index].message}',
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(color: Colors.black45, thickness: 0.3)
      ],
    );
  }

  Widget bookingWidget() {
    return bookingNotificationModal == null
        ? Align(
            alignment: Alignment.center,
            child: Container(
                height: 20,
                width: 20,
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ))),
          )
        : bookingNotificationModal!.responseCode == '1'
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: bookingNotificationModal!.notifications!.length,
                    itemBuilder: (context, index) => bookingItemWidget(index)),
              )
            : Container(
                height: SizeConfig.screenHeight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/emptyNotification.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'Notification list is empty',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              );
  }

  Widget bookingItemWidget(int index) {
    var dateFormate = DateFormat("dd/MM/yyyy").format(DateTime.parse(bookingNotificationModal!
        .notifications![index].date! ?? ""));
    return Column(
      children: [
        Container(
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(5.0),
            child: InkWell(
              splashColor: Colors.grey[200],
              focusColor: Colors.grey[200],
              highlightColor: Colors.grey[200],
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ViewBookingNotification(
                //           booking: bookingNotificationModal!.notifications![index].booking!)),
                // );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: index % 3 == 0
                              ? Color(0xFFE9E4B2)
                              : index % 3 == 1
                                  ? Color(0xFFEBBFA1)
                                  : Color(0xFFC6D3EF),
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: bookingNotificationModal!
                                    .notifications![index].title ==
                                "Booking Confirm"
                            ? Image.asset(
                                "assets/images/orderPlaced.png",
                              )
                            : bookingNotificationModal!
                                        .notifications![index].title ==
                                    "Booking On Way"
                                ? Image.asset(
                                    "assets/images/order Dispatch.png",
                                    height: 20)
                                : bookingNotificationModal!
                                            .notifications![index].title ==
                                        "Booking Completed"
                                    ? Image.asset(
                                        "assets/images/orderDeliver.png",
                                        height: 20)
                                    : bookingNotificationModal!
                                                .notifications![index].title ==
                                            "Booking Cancel"
                                        ? Image.asset(
                                            "assets/images/orderCancel.png",
                                            height: 20)
                                        : Icon(
                                            FontAwesomeIcons.truckMonster,
                                            size: 20,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    bookingNotificationModal!
                                        .notifications![index].message!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: appColorGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Booking Id: ${bookingNotificationModal!.notifications![index].dataId}',
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${dateFormate}",
                                  // format(
                                  //   DateTime.parse(bookingNotificationModal!
                                  //       .notifications![index].date!),
                                  // ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(color: Colors.black45, thickness: 0.3)
      ],
    );
  }
}
