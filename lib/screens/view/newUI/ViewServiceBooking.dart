import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/global.dart';
import '../../../models/ServiceDetailsModel.dart';

class ViewServiceBooking extends StatefulWidget {
  var id;
   ViewServiceBooking({Key? key, this.id}) : super(key: key);

  @override
  State<ViewServiceBooking> createState() => _ViewServiceBookingState();
}

class _ViewServiceBookingState extends State<ViewServiceBooking> {

  ServiceDetailsModel? serviceDetailsModel;
  String? booking_id;
  getServiceBooking() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    booking_id = preferences.getString("booking_id");
    var headers = {
      'Cookie': 'ci_session=d2eb7ff74134ed8797a27ad46e3b1aea333c5050'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://sodindia.com/api/get_booking_by_id_user'));
    request.fields.addAll({
      'booking_id': booking_id.toString(),
    });

    print("Booking id in details page${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("workingg@@@@@@@");
      var finalResponse = await response.stream.bytesToString();
      final finalResult = ServiceDetailsModel.fromJson(jsonDecode(finalResponse));
      setState(() {
        serviceDetailsModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: backgroundblack)
        ),
        backgroundColor: appColorWhite,
        centerTitle: true,
        elevation: 0,
        title: Text("Service Details", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: backgroundblack),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 50,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: backgroundblack, //<-- SEE HERE
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Booking Id: ",
                                style: TextStyle(fontWeight: FontWeight.w800, color: appColorBlack, fontSize: 14)),
                            // serviceDetailsModel!.data![0].id== null || serviceDetailsModel!.data![0].id =="" ?
                            Text("--",  style: TextStyle(fontWeight: FontWeight.w800, color: backgroundblack, fontSize: 12),),
                            Text("${serviceDetailsModel?.data?[0].id}",
                                style: TextStyle(fontWeight: FontWeight.w800, color: backgroundblack, fontSize: 14)),
                            SizedBox(width: 180),
                            Text("Date: ",
                                style: TextStyle(fontWeight: FontWeight.w800, color: appColorBlack, fontSize: 14)),
                            Text("${serviceDetailsModel?.data?[0].date}",
                                style: TextStyle(fontWeight: FontWeight.w800, color: backgroundblack, fontSize: 14)),
                            // SizedBox(width: 15,),
                          ],
                        ),
                        // SizedBox(height: 6,),
                        // Column(
                        //   children: [
                        //     Row(children: [
                        //       Text("Restaurant:  ",
                        //           style: TextStyle(fontWeight: FontWeight.w800, color: appColorBlack, fontSize: 14)),
                        //       Text("${widget.data['store_name']}",
                        //           style: TextStyle(fontWeight: FontWeight.w800, color: backgroundblack, fontSize: 14)),
                        //     ],)
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text("Items Summary", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),),
            itemSummary(context),
            SizedBox(height: 10,),
            Text("Delivery Location", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),),
            SizedBox(height: 10,),
            deliveryLocation(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order Summary", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),),
                  // Text("Cancel Order", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.red, decoration: TextDecoration.underline),),
                ],
              ),
            ),
            orderSummary(),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Widget itemCard(int index){
    return Padding(
      padding: EdgeInsets.all(5),
      child: Scrollbar(
        thickness: 10,
        trackVisibility: true,
        // isAlwaysShown: true,
        thumbVisibility: true,
        radius: Radius.circular(10),
        child: Container(
          height: 140,
          child: Card(
            elevation: 5,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: backgroundblack, //<-- SEE HERE
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 15),
                  child: Container(
                    // color: Colors.white,
                    height: 100,
                    width: 100,
                    child: Image.network("${serviceDetailsModel!.data![index].productsDetails![index].servicesImage}", height: 70, width: 70, fit: BoxFit.fill,),
                  ),
                ),
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 125,
                        child: Text("${serviceDetailsModel!.data![index].productsDetails![index].artistName}", maxLines: 2,style: TextStyle(color: backgroundblack, overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,fontSize: 15)
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("${serviceDetailsModel!.data![index].productsDetails![index].mrpPrice}",style: TextStyle(color: appColorBlack,fontWeight: FontWeight.bold,fontSize: 13),),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text("Price",style: TextStyle(color: appColorOrange,fontSize: 13)),
                          SizedBox(width: 7),
                          Text("₹ ${serviceDetailsModel!.data![index].productsDetails![index].specialPrice}",style: TextStyle(color: appColorBlack,fontWeight: FontWeight.bold,fontSize: 13)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Subtotal:",style: TextStyle(color: appColorOrange,fontSize: 13)),
                          SizedBox(width: 7),
                          Text("${serviceDetailsModel!.data![index].productsDetails![index].specialPrice}",style: TextStyle(color: appColorBlack,fontWeight: FontWeight.bold,fontSize: 13)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Total Price",style: TextStyle(color: appColorOrange,fontSize: 13)),
                          SizedBox(width: 7),
                          Text("₹ ${serviceDetailsModel!.data![index].productsDetails![index].roll}",style: TextStyle(color: appColorBlack,fontWeight: FontWeight.bold,fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemSummary(BuildContext context) {
    return serviceDetailsModel!.data!.isEmpty
        ? Center(
      child: Image.asset("assets/images/loader1.gif", scale: 3),
     ): serviceDetailsModel!.data!.isNotEmpty
        ? ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: serviceDetailsModel!.data!.length,
        itemBuilder: (BuildContext context, int index){
          return  itemCard(index);
        }): Center(
      child: Text(
        "Don't have any Orders",
        style: TextStyle(
          color: appColorBlack,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget orderSummary() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: backgroundblack)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("SubTotal: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack),),
                        SizedBox(height: 7),
                        Text("GST: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                        SizedBox(width: 130),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Text("Delivery Charge: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                          ],
                        ),
                        SizedBox(height: 7),
                        Text("Delivery GST Charge: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                        SizedBox(height: 7),
                        Text("Distance: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                        SizedBox(height: 7),
                        Text("Total: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                        SizedBox(height: 7),
                        Text("Payment Method: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                        SizedBox(height: 7),
                        Text("Status: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                      ],
                    ),
                  ),
                  // SizedBox(width: 150,),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text("₹ ${widget.data['subtotal']}",
                  //       style: TextStyle(
                  //           color: backgroundblack,
                  //           fontWeight: FontWeight.w600
                  //       ),
                  //     ),
                  //     SizedBox(height: 5),
                  //     Text("₹ ${widget.data['user_pay_gst']}",  style: TextStyle(
                  //         color: backgroundblack,
                  //         fontWeight: FontWeight.w600
                  //     ),),
                  //     SizedBox(height: 5),
                  //     Text("₹ ${widget.data['delivery_charge']}",  style: TextStyle(
                  //         color: backgroundblack,
                  //         fontWeight: FontWeight.w600,
                  //         overflow: TextOverflow.ellipsis),maxLines: 2),
                  //     SizedBox(height: 5),
                  //     Text("₹ ${widget.data['user_gst']}",  style: TextStyle(
                  //         color: backgroundblack,
                  //         fontWeight: FontWeight.w600,
                  //         overflow: TextOverflow.ellipsis),maxLines: 2),
                  //     SizedBox(height: 5),
                  //     Text("${widget.data['distance']}",  style: TextStyle(
                  //         color: backgroundblack,
                  //         fontWeight: FontWeight.w600
                  //     ),),
                  //     SizedBox(height: 5),
                  //     Text("₹ ${widget.data['total']}", style: TextStyle(
                  //         color: backgroundblack,
                  //         fontWeight: FontWeight.w600
                  //     ),),
                  //     SizedBox(height: 5),
                  //     Text("${widget.data['payment_mode']}",  style: TextStyle(
                  //         color: backgroundblack,
                  //         fontWeight: FontWeight.w600,
                  //         overflow: TextOverflow.ellipsis),maxLines: 2),
                  //     SizedBox(height: 5),
                  //     Container(
                  //         width: 90,
                  //         height: 30,
                  //         decoration: BoxDecoration(
                  //             color: appColorOrange,
                  //             borderRadius: BorderRadius.circular(8), border: Border.all(color: backgroundblack)),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             widget.data['order_status'] == "0" ? Text("Pending", style: TextStyle(
                  //                 color: backgroundblack,
                  //                 fontWeight: FontWeight.w600
                  //             ),):
                  //             widget.data['order_status'] == "1" ? Text("Preparing",  style: TextStyle(
                  //                 color: backgroundblack,
                  //                 fontWeight: FontWeight.w600
                  //             ),):
                  //             widget.data['order_status'] == "2" ? Text("Picked Up",  style: TextStyle(
                  //                 color: backgroundblack,
                  //                 fontWeight: FontWeight.w600
                  //             ),):
                  //             widget.data['order_status'] == "3" ? Text("Delivered",  style: TextStyle(
                  //                 color: backgroundblack,
                  //                 fontWeight: FontWeight.w600
                  //             ),): Text(''),
                  //           ],)
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text("Order Status : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack),),
            //       Padding(
            //         padding: const EdgeInsets.only(right: 120),
            //         child: Container(
            //           width: 100,
            //           height: 40,
            //           decoration: BoxDecoration(
            //               color: appColorOrange,
            //               borderRadius: BorderRadius.circular(8), border: Border.all(color: backgroundblack)),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               ordersList[index]['order_status'] == "0" ? Text("Pending", style: TextStyle(
            //                   color: backgroundblack,
            //                   fontWeight: FontWeight.w600
            //               ),):
            //               ordersList[index]['order_status'] == "1" ? Text("Preparing",  style: TextStyle(
            //                   color: backgroundblack,
            //                   fontWeight: FontWeight.w600
            //               ),):
            //               ordersList[index]['order_status'] == "2" ? Text("Picked Up",  style: TextStyle(
            //                   color: backgroundblack,
            //                   fontWeight: FontWeight.w600
            //               ),):
            //               ordersList[index]['order_status'] == "3" ? Text("Delivered",  style: TextStyle(
            //                   color: backgroundblack,
            //                   fontWeight: FontWeight.w600
            //               ),): Text('')
            //             ],
            //           ),
            //         ),
            //       ),
            //       // InkWell(
            //       //   onTap: () {
            //       //     Navigator.push(context, MaterialPageRoute(builder: (context) => ));
            //       //   },
            //       //   child: Container(
            //       //       width: 100,
            //       //       height: 40,
            //       //       decoration: BoxDecoration(
            //       //           color: appColorOrange,
            //       //           borderRadius: BorderRadius.circular(8), border: Border.all(color: backgroundblack)),
            //       //       child: Center(
            //       //           child: Text("View Orders", style: TextStyle(color: backgroundblack, fontWeight: FontWeight.w600),))),
            //       // ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget deliveryLocation() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: backgroundblack)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("User: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack),),
                      SizedBox(height: 10),
                      Text("Address: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                      SizedBox(width: 130),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Mobile: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: appColorBlack)),
                        ],
                      ),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text("${widget.data['username']}",
                  //       style: TextStyle(
                  //           color: backgroundblack,
                  //           fontWeight: FontWeight.w600
                  //       ),
                  //     ),
                  //     SizedBox(height: 5),
                  //     Container(
                  //       width: MediaQuery.of(context).size.width/2.5,
                  //       child: Text("${widget.data['address']}",  style: TextStyle(
                  //         color: backgroundblack,
                  //         fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis,
                  //       ), maxLines: 2,
                  //       ),
                  //     ),
                  //     SizedBox(height: 5),
                  //     Text("${widget.data['mobile_no']}",  style: TextStyle(
                  //         color: backgroundblack,
                  //         fontWeight: FontWeight.w600
                  //     ),),
                  //   ],
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
