import 'dart:convert';

import 'package:ez/screens/view/models/getUserModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/global.dart';
import '../../../models/TransactionModel.dart';
import '../../../models/refferal_list_model.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amtC = TextEditingController();
  TextEditingController msgC = TextEditingController();
  Razorpay _razorpay = Razorpay();

    @override
    void initState(){
      super.initState();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      gettransaction();
      getRefferal('level 1');
      // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      Future.delayed(Duration(milliseconds: 300),(){
        return getUserDataApicall();
      });
    }

    GetUserModel? model;
    double walletAmount = 0.0;
    String? referralCode;
    double referalAllamount = 0.0;

  RefferalListModel? refferalListModel;
  double referalAmount = 0.0;

  Future getRefferal(String level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("user_id");

    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl()}/referral_list_user'));
    request.fields.addAll({
      'user_id': '${userId.toString()}',
      'booking_type': level.toString()
      // '${userId.toString()}'
    });
    print("this is request !! ${request.fields}");
    http.StreamedResponse response = await request.send();
    print("this is request !! 11111${response}");
    if (response.statusCode == 200) {
      print("workingg Nowww@@@@");
      var finalResponse = await response.stream.bytesToString();
      final finalResult = RefferalListModel.fromJson(jsonDecode(finalResponse));
      setState(() {
        refferalListModel = finalResult;
      });
      referalAmount = double.parse(finalResult.data![0].amount.toString());
      print("Referal MAmount in wallet opage@@@@ ${referalAmount}");
    } else {
      print(response.reasonPhrase);
    }
  }

  int amount = 0;
  getUserDataApicall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("user_id");
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userId;
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
      print("Get User Data Model Here ${model}");
       walletAmount = double.parse(model!.user!.wallet!.toString());
      print("wallet balance here ${walletAmount}");
      // _username.text = model!.user!.username!;
      // _mobile.text = model!.user!.mobile!;
      // _address.text = model!.user!.address!;
      print("GetUserData>>>>>>");
      print(dic);
        setState(() {referralCode = model!.user!.refferalCode;});
        print("referal code in my wallet screen ${referralCode}");
    } on Exception {
      Fluttertoast.showToast(msg: "No Internet connection");
      throw Exception('No Internet connection');
    }
  }

  TransactionModel? transactionModel;
 gettransaction() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String? userId = prefs.getString("user_id");
   var headers = {
     'Cookie': 'ci_session=5691f07c9305b839acd4eac12577d810e0ffec32'
   };
   var request = http.MultipartRequest('POST', Uri.parse('https://sodindia.com/api/get_wallet_transactions_user'));
   request.fields.addAll({
     'user_id': userId.toString(),
   });
   request.headers.addAll(headers);
   http.StreamedResponse response = await request.send();
   if (response.statusCode == 200) {
     print("workingg tarnsaction apiii");
     var finalResponse = await response.stream.bytesToString();
     final finalResult = TransactionModel.fromJson(jsonDecode(finalResponse));
     setState(() {
       transactionModel = finalResult;
     });
   } else {
     print(response.reasonPhrase);
   }
 }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // var userId = await MyToken.getUserID();
      Fluttertoast.showToast(msg:"Payment Successful");
    //purchasePlan("$userId", planI,"${response.paymentId}");
      addMoneyToWallet();
      //addWalletMoney(response.paymentId);

    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("FAILURE === ${response.message}");
    // UtilityHlepar.getToast("${response.message}");
  Fluttertoast.showToast(msg: "Payment Failed");
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  checkOut() {
     amount  = int.parse(amtC.text.toString()) * 100;
    var options = {
      'key': "rzp_test_0JDIgD51ltx3rs",
      'amount': amount,
      'currency': 'INR',
      'name': 'SOD',
      'description': '',
      // 'prefill': {'contact': userMobile, 'email': userEmail},
    };
    print("OPTIONS ===== $options");
    _razorpay.open(options);
  }

  addMoneyToWallet()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("user_id");
    var headers = {
      'Cookie': 'ci_session=6529f44b19772c7e68705f973c1e1fb967bf6aba'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}update_wallet_amount'));
    request.fields.addAll({
      'user_id': '${userId}',
      'total': amtC.text,
      'txn_id': 'ADDTOWALLET'
    });
    print("Add wallet paraa ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse =  json.decode(finalResult);
      print("checking final result ${jsonResponse}");
      setState(() {
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        getUserDataApicall();
        amtC.clear();
      });
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<Null> refreshFunction()async{
    await gettransaction();
    await getUserDataApicall();
  }


  _showDialog() async {
    bool payWarn = false;
    await showDialog(context: context, builder: (context){
      return  AlertDialog(
        contentPadding: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                child: Text("Add Money",
                  // getTranslated(context, 'ADD_MONEY')!,
                  style: Theme.of(this.context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: backgroundblack),
                  //  Theme.of(context).colorScheme.fontColor),
                ),
              ),
              Divider(),
              Form(
                key: _formKey,
                child: Flexible(
                  child: SingleChildScrollView(
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (val){
                                    if(val!.isEmpty){
                                      return "Enter amount";
                                    }
                                  },
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Amount",
                                    // getTranslated(context, "AMOUNT"),
                                    hintStyle: Theme.of(this.context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  controller: amtC,
                                )),
                            // Padding(
                            //     padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            //     child: TextFormField(
                            //       autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //       style: TextStyle(
                            //         color:Colors.black,
                            //       ),
                            //       decoration: new InputDecoration(
                            //         hintText: "Message",
                            //         //(context, 'MSG'),
                            //         hintStyle: Theme.of(this.context)
                            //             .textTheme
                            //             .subtitle1!
                            //             .copyWith(
                            //             color: Colors.black,
                            //             // Theme.of(context)
                            //             //     .colorScheme
                            //             //     .lightBlack,
                            //             fontWeight: FontWeight.normal),
                            //       ),
                            //       controller: msgC,
                            //     )),
                            //Divider(),
                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(20.0, 10, 20.0, 5),
                            //   child: Text("Select Payment Method",
                            //     //getTranslated(context, 'SELECT_PAYMENT')!,
                            //     style: Theme.of(context).textTheme.subtitle2,
                            //   ),
                            // ),
                            Divider(),
                            payWarn
                                ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Text("Please Select Payment Method..!!",
                                //  getTranslated(context, 'payWarning')!,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.red),
                              ),
                            )
                                : Container(),
                            // paypal == null
                            //     ? Center(child: CircularProgressIndicator())
                            //     : Column(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: getPayList()),
                          ]
                      ),
                  ),
                ),
              )
            ]),
        actions: <Widget>[
          new ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: backgroundblack
              ),
              child: Text("Cancel",
                // getTranslated(context, 'CANCEL')!,
                style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                  // color: AppColor().colorTextSecondary(),
                  // Theme.of(context).colorScheme.lightBlack,
                  color: appColorOrange,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // amtC.clear();
                msgC.clear();
                Navigator.pop(context);
              }),
          new ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: backgroundblack
              ),
              child: Text("Send",
                // getTranslated(context, 'SEND')!,
                style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                    color: appColorOrange,
                    //Theme.of(context).colorScheme.fontColor,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                final form = _formKey.currentState!;
                if (form.validate() && amtC.text != '0') {
                  form.save();
                  print("purchase Plan");
                  // print("purchase Plan2 ==== $price");
                  // price = int.parse(item.price.toString()) * 100;
                  checkOut();
                  // amtC.clear();
                  msgC.clear();
                  // if (payMethod == null) {
                  //   dialogState!(() {
                  //     payWarn = true;
                  //   });
                  // } else {
                  //   if (payMethod!.trim() ==
                  //       getTranslated(context, 'STRIPE_LBL')!.trim()) {
                  //     stripePayment(int.parse(amtC.text));
                  //   } else if (payMethod!.trim() ==
                  //       getTranslated(context, 'RAZORPAY_LBL')!.trim())
                  //     razorpayPayment(double.parse(amtC.text));
                  //   else if (payMethod!.trim() ==
                  //       "Pay Now"){
                  //     CashFreeHelper cashFreeHelper = new CashFreeHelper(amtC.text.toString(), context, (result){
                  //       print(result['txMsg']);
                  //       // setSnackbar(result['txMsg'], _checkscaffoldKey);
                  //       if(result['txStatus']=="SUCCESS"){
                  //         sendRequest(result['signature'], "CashFree");
                  //       }else{
                  //         setSnackbar1("Transaction cancelled and failed",context );
                  //       }
                  //       //placeOrder(result.paymentId);
                  //     });
                  //
                  //     cashFreeHelper.init();
                  //   }
                  //   else if (payMethod!.trim() ==
                  //       getTranslated(context, 'PAYSTACK_LBL')!.trim())
                  //     paystackPayment(context, int.parse(amtC.text));
                  //   else if (payMethod == getTranslated(context, 'PAYTM_LBL'))
                  //     paytmPayment(double.parse(amtC.text));
                  //   else if (payMethod ==
                  //       getTranslated(context, 'PAYPAL_LBL')) {
                  //     paypalPayment((amtC.text).toString());
                  //   } else if (payMethod ==
                  //       getTranslated(context, 'FLUTTERWAVE_LBL'))
                  //     flutterwavePayment(amtC.text);
                  Navigator.pop(context);
                }
              }
            // }
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: backgroundblack,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        elevation: 0,
        title: Text(
          'My Wallet',
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        child: walletAmount == null || walletAmount == "" ? Center(child: CircularProgressIndicator(),):
        SingleChildScrollView(
          // controller: controller,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                // color: Theme.of(context).colorScheme.fontColor,
                              ),
                              Text(
                                "Current Balance ",
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: walletAmount == null || walletAmount == "" ? Text(
                              "₹ 0.0",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
                            ) : Text(
                              "₹ ${walletAmount}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top:15, bottom: 15),
                              child: InkWell(
                                onTap: () {
                                  // Fluttertoast.showToast(msg: "Coming Soon....");
                                  _showDialog();
                                  // print("okkkkkkkkkkkkk");
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: backgroundblack
                                  ),
                                  child: Text("Add Money",style: TextStyle(color: Colors.white)),
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                transactionModel?.data?.length == null || transactionModel?.data?.length == ""? Center(child: CircularProgressIndicator(color: backgroundblack,),):
                ListView.builder(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: transactionModel!.data!.length,
            itemBuilder: (context, int index,) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: backgroundblack)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Id : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack),),
                                  SizedBox(height: 7),
                                  Text("Amount : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                                  SizedBox(width: 130),
                                  SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Text("Transaction Id : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text("Date : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${transactionModel!.data![index].id}",
                                  style: TextStyle(
                                      color: backgroundblack,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                SizedBox(height: 9),
                                Text("₹ ${transactionModel!.data![index].amount}",  style: TextStyle(
                                    color: backgroundblack,
                                    fontWeight: FontWeight.w600
                                ),),
                                SizedBox(height: 9),
                                Text("${transactionModel!.data![index].transactionId}",  style: TextStyle(
                                    color: backgroundblack,
                                    fontWeight: FontWeight.w600
                                ),),
                                SizedBox(height: 9),
                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: Text("${transactionModel!.data![index].createdAt}",  style: TextStyle(
                                      color: backgroundblack,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis),maxLines: 2),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Status : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack),),
                            Padding(
                              padding: const EdgeInsets.only(right: 140),
                              child: Container(
                                width: 90,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: appColorOrange,
                                    borderRadius: BorderRadius.circular(8), border: Border.all(color: backgroundblack)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    transactionModel!.data![index].status == null || transactionModel!.data![index].status == "" ? Center(child: Text("--", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: backgroundblack))):
                                    Text("${transactionModel!.data![index].status}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: backgroundblack),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(context, MaterialPageRoute(builder: (context) => ));
                            //   },
                            //   child: Container(
                            //       width: 100,
                            //       height: 40,
                            //       decoration: BoxDecoration(
                            //           color: appColorOrange,
                            //           borderRadius: BorderRadius.circular(8), border: Border.all(color: backgroundblack)),
                            //       child: Center(
                            //           child: Text("View Orders", style: TextStyle(color: backgroundblack, fontWeight: FontWeight.w600),))),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )

                // FutureBuilder<WalletHistory>(
                //     future: getWalletHistory(),
                //     builder: (context, snapshot){
                //       if(snapshot.hasData){
                //         return Container(
                //           height: 400,
                //           child: ListView.builder(
                //               itemCount: walletHistory.length,
                //               itemBuilder: (context, index){
                //                 return Card(
                //                   child: Padding(
                //                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //                     child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Row(
                //                           children: [
                //                             Container(
                //                               width: 60,
                //                               height: 60,
                //                               color: Colors.white,
                //                               child: ClipRRect(
                //                                   borderRadius:
                //                                   BorderRadius.circular(10.0),
                //                                   child:
                //                                   Image.asset(
                //                                     "images/wallet_icon.png",
                //                                     fit: BoxFit.cover,
                //                                     width: 100,
                //                                     height: 200,)
                //                               ),
                //                             ),
                //                             Column(
                //                               crossAxisAlignment: CrossAxisAlignment.start,
                //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                               children: [
                //
                //                                 Text(
                //                                   "Amount added",
                //                                   //  ['amount'].toString(),
                //                                   style: TextStyle(
                //                                     color: Colors.green,
                //                                     fontSize: 15,
                //                                     fontWeight: FontWeight.w500,
                //
                //                                   ),
                //                                 ),
                //                                 Text(
                //                                   walletHistory[index].createdAt.toString(),
                //                                   //  ['amount'].toString(),
                //                                   style: TextStyle(
                //                                     color: AppColor().colorTextPrimary(),
                //                                     fontSize: 13,
                //                                     fontWeight: FontWeight.w500,
                //
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           ],
                //                         ),
                //                         Text(
                //                           "₹ " + walletHistory[index].amount.toString(),
                //                           //  ['amount'].toString(),
                //                           style: TextStyle(
                //                             color: AppColor().colorPrimary(),
                //                             fontSize: 18,
                //                             fontWeight: FontWeight.w600,
                //
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 );
                //               }),
                //         );
                //       }
                //       return Container(child: Center(child: Image.asset("images/icons/loader.gif"),),);
                //     }
                //
                // )
              ]),
        ),
      ),
    );
  }
}
