import 'dart:math';

import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/Ride/ride_booked_model.dart';
import 'package:ez/screens/view/Ride/ride_calculation_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'finding_ride_screen.dart';

class BookYourRide extends StatefulWidget {
  const BookYourRide({Key? key}) : super(key: key);

  @override
  State<BookYourRide> createState() => _BookYourRideState();
}

class _BookYourRideState extends State<BookYourRide> {
  double pickLat = 0;
  double pickLong = 0;
  double dropLat = 0;
  double dropLong = 0;
  Position? currentLocation;
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropController = TextEditingController();


  double calculateDistance(lat1, lon1, lat2, lon2) {
    try {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    } on Exception catch (exception) {
      return 0; // only executed if error is of type Exception
    } catch (error) {
      return 0; // executed for errors of all types other than Exception
    }
  }
  double totalDistance = 0;
  distnce (){
    totalDistance =  calculateDistance(pickLat, pickLong, dropLat, dropLong);
  }

  Future<Null> refreshFunction()async{
  }

  RideCalculationModel? rideCalcData;
  RideData? rideData;
  String? userId;
  calculateRidePrice() async {
    print("Api Working");
    var headers = {
      'Cookie': 'ci_session=d9be05064d0216a7432b621660dc26feb4d030ed'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}/price_culculation_ride'));
    request.fields.addAll({
      'distance': '${calculateDistance(pickLat, pickLong, dropLat, dropLong).toString()}'
    });
    print("this is ride calculation param ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("Working Nowwwww");
      var finalResponse = await response.stream.bytesToString();
      rideCalcData = RideCalculationModel.fromJson(jsonDecode(finalResponse));
      await confirmRideDialog(context);
      print("this is ride calculation data ${rideCalcData!.subTotal.toString()}");
    }
    else {
      setState(() {});
      print(response.reasonPhrase);
    }
  }


  confirmRideBook() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("user_id");
    print("Api Working");
    var headers = {
      'Cookie': 'ci_session=d9be05064d0216a7432b621660dc26feb4d030ed'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}/ride_booking'));
    request.fields.addAll({
      'user_id':'${userId.toString()}',
      'transaction_type':'cash',
      'paid_amount':'${rideCalcData!.finalTotal.toString()}',
      'amount': '${rideCalcData!.subTotal.toString()}',
      'pickup_location': pickUpController.text.toString(),
      'drop_location':dropController.text.toString(),
      'distance': '${calculateDistance(pickLat, pickLong, dropLat, dropLong).toString()}',
      'latitude': '${pickLat.toString()}',
      'longitude':'${pickLong.toString()}',
      'drop_latitude':'${dropLat.toString()}',
      'drop_longitude': '${dropLong.toString()}',
      'gst_charge':'${rideCalcData!.gstCharge.toString()}',
      'culculate_gst_amount':'${rideCalcData!.gst.toString()}',
      'gst_type':'${rideCalcData!.gstType.toString()}',

    });
    print("this is ride booking param ---===>> ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("Working Nowwwww");
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if(jsonResponse['status']){
        Fluttertoast.showToast(msg: "${jsonResponse['message'].toString()}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => FindingRidePage(
            LatLng(pickLat, pickLong),
            LatLng(dropLat, dropLong),
            pickUpController.text,
            dropController.text,
            "Cash",
            "",
            '${rideCalcData!.finalTotal.toString()}',
            '${totalDistance.toStringAsFixed(2)}'
        )));
      }
      // print("this is ride calculation data ${rideCalcData!.subTotal.toString()}");
    }
    else {
      setState(() {});
      print(response.reasonPhrase);
    }
  }

  Future<void> confirmRideDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.zero,
              content: Container(
                height: MediaQuery.of(context).size.height/2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle
                              ),
                            ),
                          ),
                          const SizedBox(width: 6,),
                          Container(
                            width: MediaQuery.of(context).size.width - 70,
                            child: Text("${pickUpController.text.toString()}",
                              maxLines: 2,
                              style: TextStyle(
                              ),
                              overflow: TextOverflow.ellipsis,),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle
                              ),
                            ),
                          ),
                          const SizedBox(width: 6,),
                          Container(
                            width: MediaQuery.of(context).size.width - 70,
                            child: Text("${dropController.text.toString()}",
                                maxLines: 2,
                                style: TextStyle(
                                ),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      Divider(),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Distance : ", style: TextStyle(
                              fontWeight: FontWeight.w600
                          ),),
                          Text('${totalDistance.toStringAsFixed(2)} km')
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Price : ", style: TextStyle(
                                fontWeight: FontWeight.w600
                            ),),
                            Text('₹ ${rideCalcData!.subTotal.toString()}')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only( bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("GST Charge (${rideCalcData!.gstCharge.toString()}%) : ", style: TextStyle(
                                fontWeight: FontWeight.w600
                            ),),
                            Text('₹ ${rideCalcData!.gst.toString()}')
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only( bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total : ", style: TextStyle(
                                fontWeight: FontWeight.w600
                            ),),
                            Text('₹ ${rideCalcData!.finalTotal.toString()}')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                        child: InkWell(
                          onTap: (){
                            confirmRideBook();
                          },
                          child: Container(
                            height: 43,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),  color: appColorOrange),
                            child:
                            Center(
                                child: Text("Confirm", style: TextStyle(fontSize: 18, color: backgroundblack))
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Confirm Ride Request", style: TextStyle(
                    color: backgroundblack, fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColorOrange
                      ),
                      child: Icon(Icons.clear, color: backgroundblack, size: 14,),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  @override @override
  void initState() {
    markers.add(Marker( //add marker on google map
      markerId: MarkerId(showLocation.toString()),
      position: showLocation, //position of marker
      infoWindow: InfoWindow( //popup info
        title: 'My Custom Title',
        snippet: 'My Custom Subtitle',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    // TODO: implement initState
    super.initState();
  }
  GoogleMapController? mapController; //contrller for Google map
  Set<Marker> markers = Set(); //mark
  LatLng showLocation = LatLng(26.9351975, 75.7915031);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        centerTitle: true,
      leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: backgroundblack,)),
      backgroundColor: appColorWhite,
      elevation: 0,
      title: Text("Book Your Ride",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: backgroundblack)
      ),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  child: RefreshIndicator(
                    onRefresh: refreshFunction,
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.3,
                      child: ListView(
                        children: <Widget>[
                          Container(height: 15),
                          _mapLocation(context),
                          Container(height: 13),
                          _locationField(context),
                          Container(
                            child: InkWell(
                              onTap: () async{
                                distnce();
                                if(pickUpController.text.isEmpty && dropController.text.isEmpty) {
                                  Fluttertoast.showToast(msg: "Please select both locations");
                                }
                                else{
                                  calculateRidePrice();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, top: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 46,
                                    width: MediaQuery.of(context).size.width/3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                      color: Colors.black12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Text("BOOK NOW", style: TextStyle(fontSize: 15, color: appColorGreen, fontWeight: FontWeight.w600)
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                            child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void clearPickup() {
    pickUpController.clear();
  }

  void clearDrop() {
    dropController.clear();
  }
  Widget _locationField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          // height: 35,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: pickUpController,
            readOnly: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlacePicker(
                    apiKey: Platform.isAndroid
                        ? "AIzaSyBRnd5Bpqec-SYN-wAYFECRw3OHd4vkfSA"
                        : "AIzaSyBRnd5Bpqec-SYN-wAYFECRw3OHd4vkfSA",
                    onPlacePicked: (result) {
                      print(result.formattedAddress);
                      setState(() {
                        pickUpController.text = result.formattedAddress.toString();
                        pickLat = result.geometry!.location.lat;
                        pickLong = result.geometry!.location.lng;
                      });
                      Navigator.of(context).pop();
                      distnce();
                    },
                    initialPosition: LatLng(currentLocation!.latitude, currentLocation!.longitude),
                    useCurrentLocation: true,
                  ),
                ),
              );
            },
            decoration: InputDecoration(
              hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
              // labelText: "Pickup Location",
              filled: true,
              fillColor: Colors.white,
              //fillColor: appColorOrange,
              hintText: "Pickup Location",
              prefixIcon: Icon(Icons.search,color: appColorBlack,),
              suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      clearPickup();
                    });
                  },
                  child: Icon(Icons.clear,color: appColorBlack)),
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 15,),
        Container(
          color: Colors.white,
          // height: 35,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: dropController,
            readOnly: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlacePicker(
                    apiKey: Platform.isAndroid
                        ? "AIzaSyBRnd5Bpqec-SYN-wAYFECRw3OHd4vkfSA"
                        : "AIzaSyBRnd5Bpqec-SYN-wAYFECRw3OHd4vkfSA",
                    onPlacePicked: (result) {
                      print(result.formattedAddress);
                      setState(() {
                        dropController.text = result.formattedAddress.toString();
                        dropLat = result.geometry!.location.lat;
                        dropLong = result.geometry!.location.lng;
                      });
                      Navigator.of(context).pop();
                    },
                    initialPosition: dropLat != 0
                        ? LatLng(dropLat, dropLong)
                        : LatLng(currentLocation!.latitude, currentLocation!.longitude),
                    useCurrentLocation: true,
                  ),
                ),
              );
            },
            decoration: InputDecoration(
              hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
              // labelText: "Drop Location",
              hintText: "Drop Location",
              enabledBorder: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search,color: appColorBlack,),
              suffixIcon: InkWell(onTap: () {
                setState(() {
                  clearDrop();
                });
    },
    child: Icon(Icons.clear,color: appColorBlack)),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _mapLocation(BuildContext context) {
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 7)),
      child: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: showLocation,
          zoom: 10.0,
        ),
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }

}
