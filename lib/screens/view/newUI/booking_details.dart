import 'dart:convert';

import 'package:ez/screens/chat_page.dart';
import 'package:ez/screens/view/models/cancel_booking_model.dart';
import 'package:ez/screens/view/models/getBookingModel.dart';
import 'package:ez/screens/view/newUI/newTabbar.dart';
import 'package:ez/screens/view/newUI/ratingService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../constant/global.dart';
import '../models/getUserModel.dart';

// ignore: must_be_immutable
class BookingDetailScreen extends StatefulWidget {
  Booking data;
  BookingDetailScreen(this.data);

  @override
  State<StatefulWidget> createState() {
    return _BookingDetailScreenState(this.data);
  }
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool isLoading = false;
  var rateValue;
  bool isPayment = false;
  Razorpay? _razorpay;
  String? orderid = '';

  checkOut() {
    _razorpay = Razorpay();
    generateOrderId(
        rozPublic, rozSecret, int.parse(widget.data.amount.toString()) * 100);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<String> generateOrderId(String key, String secret, int amount) async {
    setState(() {
      isPayment = true;
    });
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!
    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: headers, body: data);
    print('ORDER ID response => ${res.body}');
    orderid = json.decode(res.body)['id'].toString();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + orderid!);
    if (orderid!.length > 0) {
      openCheckout();
    } else {
      setState(() {
        isPayment = false;
      });
    }
    return json.decode(res.body)['id'].toString();
  }

  TextEditingController _ratingcontroller = TextEditingController();

  _BookingDetailScreenState(Booking data);

  bool isWallet = false;

  successPaymentApiCall() async {
    setState(() {
      isPayment = true;
    });
    var uri = Uri.parse("${baseUrl()}/payment_success");
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['txn_id'] = widget.data.txnId.toString();
    request.fields['amount'] = widget.data.amount.toString();
    request.fields['booking_id'] = widget.data.id.toString();
    request.fields['is_wallet'] = isWallet == true ? 'true' : 'false';
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream
        .transform(utf8.decoder)
        .join(); // decodes on response data using UTF8.decoder
    Map data = json.decode(responseData);
    print(data);

    setState(() {
      isPayment = false;

      if (data["response_code"] == "1") {
        print("working");
        Fluttertoast.showToast(msg: "Payment Success");
        // const snackBar = SnackBar(
        //   backgroundColor: Colors.green,
        //   content: Text('Payment successful'),
        // );
        //
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TabbarScreen()));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => BookingSccess(
        //           image: widget.restaurants!.restaurant!.allImage![0],
        //           name: widget.restaurants!.restaurant!.resName,
        //           location: _pickedLocation,
        //           date: widget.dateValue,
        //           time: widget.timeValue)
        //   ),
        // );
      } else {
        print("ook ");
        setState(() {
          isPayment = false;
          Fluttertoast.showToast(msg: "something went wrong. Try again");
        });
      }
    });
  }

  void openCheckout() async {
    var options = {
      'key': "rzp_test_CpvP0qcfS4CSJD",
      'amount': int.parse(widget.data.amount.toString()) * 100,
      'currency': 'INR',
      'name': 'Antsnest',
      'description': '',
      'prefill': {'contact': userMobile, 'email': userEmail},
    };

    print("Razorpay Option === $options");
    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS Order:" + response.paymentId!);
    // bookApiCall(response.paymentId!, "Razorpay");
    successPaymentApiCall();
    print(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isPayment = false;
    });
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    );
    print(response.code.toString() + " - " + response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName!);
    print(response.walletName);
  }

  GetUserModel? model;
  String walletAmount = "0";

  getUserDataApicall() async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;

      final response = await client.post(Uri.parse("${baseUrl()}/user_data"),
          headers: headers, body: map);
      print("sddddddd ${map} sdsd ${baseUrl()}/user_data");
      var dic = json.decode(response.body);
      Map<String, dynamic> userMap = jsonDecode(response.body);
      model = GetUserModel.fromJson(userMap);

      userEmail = model!.user!.email!;
      userMobile = model!.user!.mobile!;
      userName = model!.user!.username!;
      userPic = model!.user!.profilePic!;
      // walletAmount = model!.user!.wallet.toString();
      print("wallet balance here ${walletAmount}");
      // _username.text = model!.user!.username!;
      // _mobile.text = model!.user!.mobile!;
      // _address.text = model!.user!.address!;
      print("GetUserData>>>>>>");
      print(dic);
      setState(() {});
    } on Exception {
      Fluttertoast.showToast(msg: "No Internet connection");
      throw Exception('No Internet connection');
    }
  }
  int? currentIndex;

  TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      return getUserDataApicall();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        " para check ${widget.data.txnId} and ${widget.data.id} and ${widget.data.amount}");
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: backgroundblack,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        elevation: 0,
        title: Text(
          'Booking Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
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
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
            width: double.maxFinite, //set your width here
            decoration: BoxDecoration(
                // color: Colors.grey.shade200,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: widget.data.status == "Pending" ||
                              // widget.data.status == "Confirm" ||
                              widget.data.status == "On The Way"
                          ? ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return AlertDialog(
                                              content: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Are you sure ?\n Want to cancel service",
                                                    style: TextStyle(
                                                      color: appColorBlack,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentIndex = 0;
                                                      });
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  100),
                                                              color: currentIndex == 0 ? Colors
                                                                  .green : Colors.transparent,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Container(
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width / 1.8,
                                                            child: Text(
                                                              "Change of plans",
                                                              style: TextStyle(
                                                                  fontSize: 14),)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8,),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentIndex = 1;
                                                      });
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  100),
                                                              color: currentIndex ==
                                                                  1
                                                                  ? Colors.green
                                                                  : Colors
                                                                  .transparent,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Container(
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width / 1.8,
                                                            child: Text(
                                                              "Unavailability of needed services",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                              maxLines: 2,)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8,),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentIndex = 2;
                                                      });
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  100),
                                                              color: currentIndex ==
                                                                  2
                                                                  ? Colors.green
                                                                  : Colors
                                                                  .transparent,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Container(
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width / 1.8,
                                                            child: Text(
                                                              "Cost is too high",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                              maxLines: 2,)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8,),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentIndex = 3;
                                                      });
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  100),
                                                              color: currentIndex ==
                                                                  3
                                                                  ? Colors.green
                                                                  : Colors
                                                                  .transparent,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Container(
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width / 1.8,
                                                            child: Text(
                                                              "Canceling service to switch to another provider",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                              maxLines: 2,)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8,),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentIndex = 4;
                                                      });
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  100),
                                                              color: currentIndex ==
                                                                  4
                                                                  ? Colors.green
                                                                  : Colors
                                                                  .transparent,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Container(
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width / 1.8,
                                                            child: Text(
                                                              "Unavailable time slot",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                              maxLines: 2,)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8,),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentIndex = 5;
                                                      });
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  100),
                                                              color: currentIndex ==
                                                                  5
                                                                  ? Colors.green
                                                                  : Colors
                                                                  .transparent,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Container(
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width / 1.8,
                                                            child: Text(
                                                              "Others (If other please write down your reason)",
                                                              style: TextStyle(
                                                                fontSize: 14,),
                                                              maxLines: 2,)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8,),
                                                currentIndex == 5 ?  Container(
                                                    child: TextField(controller: reasonController,decoration: InputDecoration(
                                                      hintText: "Enter reason",
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10)
                                                      )
                                                    ),),
                                                  ) : SizedBox.shrink(),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 100,
                                                          alignment: Alignment
                                                              .center,
                                                          padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                          decoration: BoxDecoration(
                                                              color: backgroundblack,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                          child: Text(
                                                            "Discard",
                                                            style: TextStyle(
                                                                color: appColorWhite,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {

                                                            if(currentIndex == null){
                                                              Fluttertoast.showToast(msg: "Please select a reason");
                                                            }
                                                            else{
                                                              if (widget.data
                                                                  .status ==
                                                                  "Pending") {
                                                                CancelBookingModel cancelModel = await cancelBooking(widget.data.id);
                                                                if (cancelModel
                                                                    .responseCode ==
                                                                    "1") {
                                                                  Navigator.pop(
                                                                      context,
                                                                      true);
                                                                  Fluttertoast
                                                                      .showToast(
                                                                      msg: "Booking Cancelled Successfully!",
                                                                      toastLength: Toast
                                                                          .LENGTH_LONG,
                                                                      gravity: ToastGravity
                                                                          .BOTTOM,
                                                                      timeInSecForIosWeb: 1,
                                                                      backgroundColor:
                                                                      Colors.grey
                                                                          .shade200,
                                                                      textColor: Colors
                                                                          .black,
                                                                      fontSize: 13.0);
                                                                  // Navigator.pop(context);
                                                                  Navigator
                                                                      .pushAndRemoveUntil(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (
                                                                              context) =>
                                                                              TabbarScreen()), (
                                                                      route) => false);
                                                                }
                                                              }
                                                            }
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 100,
                                                          alignment: Alignment
                                                              .center,
                                                          padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .green,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                          child: Text(
                                                            "Proceed",
                                                            style: TextStyle(
                                                                color: appColorWhite,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    }
                                );
                              if(currentIndex == null){
                                Fluttertoast.showToast(msg: "Please select a reason");
                              }
                              else{
                                if(widget.data.status == "Pending"){
                                  CancelBookingModel cancelModel = await cancelBooking(widget.data.id);
                                  if(cancelModel.responseCode == "1"){
                                    Navigator.pop(context, true);

                                    Fluttertoast.showToast(
                                        msg: "Booking Cancelled Successfully!",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                        Colors.grey.shade200,
                                        textColor: Colors.black,
                                        fontSize: 13.0);
                                  }
                                }
                              }



                                /*widget.data.status == "Pending"
                              ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewService(widget.data)))
                              : changeStatusBloc
                              .changeStatusSink(
                              widget.data.id!, "Booking Cancel")
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            if (value.responseCode == "1") {
                              Fluttertoast.showToast(
                                  msg: "Booking cancel successfully",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                  Colors.grey.shade200,
                                  textColor: Colors.black,
                                  fontSize: 13.0);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookingList()));
                              getBookingBloc.getBookingSink(
                                  userID, "Confirm");
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Something went wrong",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                  Colors.grey.shade200,
                                  textColor: Colors.black,
                                  fontSize: 13.0);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          });*/
                              },
                              child: widget.data.status != "Pending"
                                  ? SizedBox.shrink()
                                  : Text("Cancel Service"),
                              style: ElevatedButton.styleFrom(
                                  primary: backgroundblack,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  textStyle: TextStyle(fontSize: 17),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                            )
                          : InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ReviewService(
                                  restID: widget.data.resId,
                                  restName: widget.data.service!.resName,
                                  restDesc: widget.data.service!.resDesc,
                                  resNameU: widget.data.service!.resNameU,
                                  resWebsite: widget.data.service!.resWebsite,
                                  resPhone: widget.data.service!.resPhone,
                                  resAddress: widget.data.service!.resAddress,
                                  restRatings: widget.data.service!.resRatings,
                                  images: widget.data.service!.allImage,
                                  refresh: (){}),
                            ),
                          );
                        },
                            child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: backgroundblack,
                        ),
                        child: Text("Rate your service",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                      ),
                          ) ),
                ],
              ),
            )),
      ),
      body: isLoading ? loader() : bodyData(),
    );
  }

  Widget bodyData() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                bookDetailCard(),
                bookcard(),
                // datetimecard(),
                // widget.data.isPaid == "1" ?
                InkWell(
                  onTap: () {
                    print("checking id here ${widget.data.id}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  providerId: widget.data.service!.vendorId,
                                  providerName: widget.data.service!.vendorName,
                                  providerImage:
                                      widget.data.service!.vendorImage,
                                  bookingId: widget.data.id,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: backgroundblack,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble,
                            color: appColorWhite,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Chat with service provider",
                            style: TextStyle(color: appColorWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // : SizedBox(),
                pricingcard(),
                widget.data.status == "Confirm" && widget.data.isPaid == "0"
                    ? paymentOption()
                    : SizedBox.shrink(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget paymentOption() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            title: Text(
              "Payment options",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              "Select your preferred payment mode",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            ),
          ),
          /*Card(
            child: ExpansionTile(
              tilePadding: const EdgeInsets.only(left: 10, right: 5),
              leading: Icon(Icons.payment),
              title: Text(
                "Cradit/Debit Card (STRIPE)",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // border: Border.all(),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Expanded(child: _cardNumber()),
                              _creditCradWidget(),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(child: _expiryDate()),
                            Expanded(child: _cvvNumber()),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black45,
                            onPrimary: Colors.grey,
                            onSurface: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.all(8.0),
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                          });
                          if (_pickedLocation.length > 0) {
                            String number =
                                maskFormatterNumber.getMaskedText().toString();
                            String cvv =
                                maskFormatterCvv.getMaskedText().toString();
                            String month = maskFormatterExpiryDate
                                .getMaskedText()
                                .toString()
                                .split("/")[0];
                            String year = maskFormatterExpiryDate
                                .getMaskedText()
                                .toString()
                                .split("/")[1];

                            setState(() {
                              isPayment = true;
                            });

                            getCardToken
                                .getCardToken(
                                    number, month, year, cvv, "test", context)
                                .then((onValue) {
                              print(onValue["id"]);
                              createCutomer
                                  .createCutomer(onValue["id"], "test", context)
                                  .then((cust) {
                                print(cust["id"]);
                                applyCharges
                                    .applyCharges(cust["id"], context,
                                        widget.selectedTypePrice.toString())
                                    .then((value) {
                                  bookApiCall(value["balance_transaction"], "Stripe");

                                  setState(() {
                                    isPayment = false;
                                  });
                                });
                              });
                            });
                          } else {
                            Fluttertoast.showToast(msg: "Select Address");
                            // Toast.show("Select Address", context,
                            //     duration: Toast.LENGTH_SHORT,
                            //     gravity: Toast.BOTTOM);
                          }
                        },
                        child: Text(
                          "Pay",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // fontFamily: ""
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),*/
          Card(
            child: ListTile(
              onTap: () {
                checkOut();
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(Icons.payment),
              title: Text(
                "Razorpay",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),

          Card(
            child: ListTile(
              onTap: () {
                //checkOut();
                if (walletAmount == "0" || walletAmount == 0 || walletAmount.contains('-') ) {
                  Fluttertoast.showToast(msg: "Wallet is empty");
                } else {
                  setState(() {
                    isWallet = true;
                  });
                  successPaymentApiCall();
                }
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(Icons.wallet),
              trailing: Container(
                child: walletAmount == null || walletAmount == "0"
                    ? Text("\u{20B9} 0.0")
                    : Text("\u{20B9} ${walletAmount}"),
              ),
              title: Text(
                "Wallet",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          // Card(
          //   child: ListTile(
          //     onTap: () {
          //       // if (_pickedLocation.length > 0) {
          //       //   // bookApiCall('' , 'Cash On Delivery');
          //       //   // Fluttertoast.showToast(msg: "Under Development");
          //       // } else {
          //       //   Fluttertoast.showToast(
          //       //       msg: "Select Address",
          //       //       gravity: ToastGravity.BOTTOM,
          //       //       toastLength: Toast.LENGTH_SHORT);
          //       // }
          //     },
          //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
          //     leading: Icon(Icons.attach_money_outlined, color: Colors.black),
          //     title: Text(
          //       "Cash On Delivery",
          //       style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          //       textAlign: TextAlign.start,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget bookDetailCard() {
    print(" checking date ${widget.data.date}");
    var dateFormate =
        DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.data.date ?? ""));
    // var bookingTime = TimeOfDay(hour: DateTime.parse(widget.data.createDate!).hour , minute: DateTime.parse(widget.data.createDate!).minute) ;
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Booking Id - ${widget.data.id}"),
                      Text(
                        widget.data.service?.resName ?? "",
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey.shade600,
                          ),
                          Flexible(
                              child: Text(
                            widget.data.address ?? "",
                            maxLines: 3,
                            style: TextStyle(fontSize: 11.0),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.blue.shade100,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${widget.data.slot}",
                                  style: TextStyle(
                                      color: appColorGreen,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  dateFormate,
                                  style: TextStyle(
                                      color: appColorGreen,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget bookcard() {
    var dateFormate = DateFormat("dd, MMMM yyyy")
        .format(DateTime.parse(widget.data.date.toString()));
    var bookingTime = TimeOfDay(
        hour: DateTime.parse(widget.data.date.toString()).hour,
        minute: DateTime.parse(widget.data.date.toString()).minute);
    var timeString =
        "${bookingTime.hour} : ${bookingTime.minute} ${bookingTime.period.name}";
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Detail',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("OTP"), Text("${widget.data.otp}")],
                ),
                SizedBox(height: 5),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Status',
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: widget.data.status == "Cancelled"
                          ? Text(
                              widget.data.status!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )
                          : widget.data.status != "Completed"
                              ? Text(
                                  widget.data.status!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  // widget.data.status!,
                                  "Completed",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                      // decoration: BoxDecoration(
                      //     color: Colors.grey.shade100,
                      //     borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Status',
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child: widget.data.isPaid == "0"
                            ? Text(
                                "Unpaid",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            : Text(
                                "Paid",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              )
                        // decoration: BoxDecoration(
                        //     color: Colors.grey.shade100,
                        //     borderRadius: BorderRadius.circular(5)),
                        ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment',
                    ),
                    Container(
                      height: 30,
                      width: 80,
                      alignment: Alignment.centerRight,
                      child: Text(
                        " \u{20B9} ${widget.data.total}",
                      ),
                      // decoration: BoxDecoration(
                      //     color: Colors.grey.shade100,
                      //     borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking At',
                    ),
                    Text(
                      widget.data.date! + "\n" + widget.data.slot.toString(),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget datetimecard() {
    var dateFormate =
        DateFormat("dd, MMMM yyyy").format(DateTime.parse(widget.data.date!));
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Date & Time',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking At',
                    ),
                    Text(
                      dateFormate + "\n" + widget.data.slot!,
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget pricingcard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Amount',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                    ),
                    Text(
                      "₹ " + widget.data.amount!,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future cancelBooking(id) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/cancel_booking'));

    request.fields.addAll({'id': '$id', 'status': 'Cancelled','reason': currentIndex == 5 ? reasonController.text : currentIndex == 0 ? 'Change of plans' : currentIndex == 1 ? 'Unavailability of needed services' : currentIndex == 2 ? 'Cost is too high' : currentIndex == 3 ? 'Canceling service to switch to another provider' :  'Unavailable time slot'
    });

    print(request);
    print(request.fields);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      return CancelBookingModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }
}
