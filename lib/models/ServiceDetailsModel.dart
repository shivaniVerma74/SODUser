/// response_code : "1"
/// msg : "My Bookings"
/// data : [{"id":"193","date":"0000-00-00","slot":"1:11 AM","user_id":"62","res_id":"69","size":"vuvu","status":"2","a_status":"1","reason":null,"is_paid":"0","otp":"1466","amount":"1180","txn_id":"","address":"[101, Badi Bhamori, Indore, Madhya Pradesh 452011, India, 22.7454425, 75.8927447]","address_id":"240","payment_type":"COD","created_at":"2023-05-22 17:44:00","subtotal":"1180.00","discount":"0.00","addons":"0.00","total":"1180.00","pickup_location":"","drop_location":"","assign_for":"0","booking_status":"","paid_amount":"","km":"","latitude":"","longitude":"","drop_latitude":"","drop_longitude":"","booking_type":"","service_id":"0","no_of_person":"0","type_of_booking":"","gst_amount":"72","items":[{"service_id":"45","hours":"1","subtotal":"400","no_of_person":""}],"gst_charge":"","delivery_charge":"","vendor_delivery_charge":"","hours":"","user_name":"cychvy","user_mobile":"7417447708","fixed_amount":"100","p_date":"2023-05-22 13:17:26","uname":"Devesh 1","roll":"Handy Man Service","products_details":[{"id":"45","artist_name":"handysdfsdf","category_id":"70","sub_id":"0","services_image":"https://sodindia.com/uploads/1684563994Screenshot_2023-05-15-13-30-06-374_com_sahayatri_driver.jpg","profile_image":"6468681a8e9fd.jpg","mrp_price":"200","special_price":"400","v_id":"69","roll":"7","ser_desc":"test yfydfsdggshg yufuddd jthuf","service_status":"1","tax_status":"0","gst_amount":"0","per_day_charge":""}]}]

class ServiceDetailsModel {
  ServiceDetailsModel({
      String? responseCode, 
      String? msg, 
      List<Data>? data,}){
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
}

  ServiceDetailsModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _msg;
  List<Data>? _data;
ServiceDetailsModel copyWith({  String? responseCode,
  String? msg,
  List<Data>? data,
}) => ServiceDetailsModel(  responseCode: responseCode ?? _responseCode,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get msg => _msg;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "193"
/// date : "0000-00-00"
/// slot : "1:11 AM"
/// user_id : "62"
/// res_id : "69"
/// size : "vuvu"
/// status : "2"
/// a_status : "1"
/// reason : null
/// is_paid : "0"
/// otp : "1466"
/// amount : "1180"
/// txn_id : ""
/// address : "[101, Badi Bhamori, Indore, Madhya Pradesh 452011, India, 22.7454425, 75.8927447]"
/// address_id : "240"
/// payment_type : "COD"
/// created_at : "2023-05-22 17:44:00"
/// subtotal : "1180.00"
/// discount : "0.00"
/// addons : "0.00"
/// total : "1180.00"
/// pickup_location : ""
/// drop_location : ""
/// assign_for : "0"
/// booking_status : ""
/// paid_amount : ""
/// km : ""
/// latitude : ""
/// longitude : ""
/// drop_latitude : ""
/// drop_longitude : ""
/// booking_type : ""
/// service_id : "0"
/// no_of_person : "0"
/// type_of_booking : ""
/// gst_amount : "72"
/// items : [{"service_id":"45","hours":"1","subtotal":"400","no_of_person":""}]
/// gst_charge : ""
/// delivery_charge : ""
/// vendor_delivery_charge : ""
/// hours : ""
/// user_name : "cychvy"
/// user_mobile : "7417447708"
/// fixed_amount : "100"
/// p_date : "2023-05-22 13:17:26"
/// uname : "Devesh 1"
/// roll : "Handy Man Service"
/// products_details : [{"id":"45","artist_name":"handysdfsdf","category_id":"70","sub_id":"0","services_image":"https://sodindia.com/uploads/1684563994Screenshot_2023-05-15-13-30-06-374_com_sahayatri_driver.jpg","profile_image":"6468681a8e9fd.jpg","mrp_price":"200","special_price":"400","v_id":"69","roll":"7","ser_desc":"test yfydfsdggshg yufuddd jthuf","service_status":"1","tax_status":"0","gst_amount":"0","per_day_charge":""}]

class Data {
  Data({
      String? id, 
      String? date, 
      String? slot, 
      String? userId, 
      String? resId, 
      String? size, 
      String? status, 
      String? aStatus, 
      dynamic reason, 
      String? isPaid, 
      String? otp, 
      String? amount, 
      String? txnId, 
      String? address, 
      String? addressId, 
      String? paymentType, 
      String? createdAt, 
      String? subtotal, 
      String? discount, 
      String? addons, 
      String? total, 
      String? pickupLocation, 
      String? dropLocation, 
      String? assignFor, 
      String? bookingStatus, 
      String? paidAmount, 
      String? km, 
      String? latitude, 
      String? longitude, 
      String? dropLatitude, 
      String? dropLongitude, 
      String? bookingType, 
      String? serviceId, 
      String? noOfPerson, 
      String? typeOfBooking, 
      String? gstAmount, 
      List<Items>? items, 
      String? gstCharge, 
      String? deliveryCharge, 
      String? vendorDeliveryCharge, 
      String? hours, 
      String? userName, 
      String? userMobile, 
      String? fixedAmount, 
      String? pDate, 
      String? uname, 
      String? roll, 
      List<ProductsDetails>? productsDetails,}){
    _id = id;
    _date = date;
    _slot = slot;
    _userId = userId;
    _resId = resId;
    _size = size;
    _status = status;
    _aStatus = aStatus;
    _reason = reason;
    _isPaid = isPaid;
    _otp = otp;
    _amount = amount;
    _txnId = txnId;
    _address = address;
    _addressId = addressId;
    _paymentType = paymentType;
    _createdAt = createdAt;
    _subtotal = subtotal;
    _discount = discount;
    _addons = addons;
    _total = total;
    _pickupLocation = pickupLocation;
    _dropLocation = dropLocation;
    _assignFor = assignFor;
    _bookingStatus = bookingStatus;
    _paidAmount = paidAmount;
    _km = km;
    _latitude = latitude;
    _longitude = longitude;
    _dropLatitude = dropLatitude;
    _dropLongitude = dropLongitude;
    _bookingType = bookingType;
    _serviceId = serviceId;
    _noOfPerson = noOfPerson;
    _typeOfBooking = typeOfBooking;
    _gstAmount = gstAmount;
    _items = items;
    _gstCharge = gstCharge;
    _deliveryCharge = deliveryCharge;
    _vendorDeliveryCharge = vendorDeliveryCharge;
    _hours = hours;
    _userName = userName;
    _userMobile = userMobile;
    _fixedAmount = fixedAmount;
    _pDate = pDate;
    _uname = uname;
    _roll = roll;
    _productsDetails = productsDetails;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _date = json['date'];
    _slot = json['slot'];
    _userId = json['user_id'];
    _resId = json['res_id'];
    _size = json['size'];
    _status = json['status'];
    _aStatus = json['a_status'];
    _reason = json['reason'];
    _isPaid = json['is_paid'];
    _otp = json['otp'];
    _amount = json['amount'];
    _txnId = json['txn_id'];
    _address = json['address'];
    _addressId = json['address_id'];
    _paymentType = json['payment_type'];
    _createdAt = json['created_at'];
    _subtotal = json['subtotal'];
    _discount = json['discount'];
    _addons = json['addons'];
    _total = json['total'];
    _pickupLocation = json['pickup_location'];
    _dropLocation = json['drop_location'];
    _assignFor = json['assign_for'];
    _bookingStatus = json['booking_status'];
    _paidAmount = json['paid_amount'];
    _km = json['km'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _dropLatitude = json['drop_latitude'];
    _dropLongitude = json['drop_longitude'];
    _bookingType = json['booking_type'];
    _serviceId = json['service_id'];
    _noOfPerson = json['no_of_person'];
    _typeOfBooking = json['type_of_booking'];
    _gstAmount = json['gst_amount'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _gstCharge = json['gst_charge'];
    _deliveryCharge = json['delivery_charge'];
    _vendorDeliveryCharge = json['vendor_delivery_charge'];
    _hours = json['hours'];
    _userName = json['user_name'];
    _userMobile = json['user_mobile'];
    _fixedAmount = json['fixed_amount'];
    _pDate = json['p_date'];
    _uname = json['uname'];
    _roll = json['roll'];
    if (json['products_details'] != null) {
      _productsDetails = [];
      json['products_details'].forEach((v) {
        _productsDetails?.add(ProductsDetails.fromJson(v));
      });
    }
  }
  String? _id;
  String? _date;
  String? _slot;
  String? _userId;
  String? _resId;
  String? _size;
  String? _status;
  String? _aStatus;
  dynamic _reason;
  String? _isPaid;
  String? _otp;
  String? _amount;
  String? _txnId;
  String? _address;
  String? _addressId;
  String? _paymentType;
  String? _createdAt;
  String? _subtotal;
  String? _discount;
  String? _addons;
  String? _total;
  String? _pickupLocation;
  String? _dropLocation;
  String? _assignFor;
  String? _bookingStatus;
  String? _paidAmount;
  String? _km;
  String? _latitude;
  String? _longitude;
  String? _dropLatitude;
  String? _dropLongitude;
  String? _bookingType;
  String? _serviceId;
  String? _noOfPerson;
  String? _typeOfBooking;
  String? _gstAmount;
  List<Items>? _items;
  String? _gstCharge;
  String? _deliveryCharge;
  String? _vendorDeliveryCharge;
  String? _hours;
  String? _userName;
  String? _userMobile;
  String? _fixedAmount;
  String? _pDate;
  String? _uname;
  String? _roll;
  List<ProductsDetails>? _productsDetails;
Data copyWith({  String? id,
  String? date,
  String? slot,
  String? userId,
  String? resId,
  String? size,
  String? status,
  String? aStatus,
  dynamic reason,
  String? isPaid,
  String? otp,
  String? amount,
  String? txnId,
  String? address,
  String? addressId,
  String? paymentType,
  String? createdAt,
  String? subtotal,
  String? discount,
  String? addons,
  String? total,
  String? pickupLocation,
  String? dropLocation,
  String? assignFor,
  String? bookingStatus,
  String? paidAmount,
  String? km,
  String? latitude,
  String? longitude,
  String? dropLatitude,
  String? dropLongitude,
  String? bookingType,
  String? serviceId,
  String? noOfPerson,
  String? typeOfBooking,
  String? gstAmount,
  List<Items>? items,
  String? gstCharge,
  String? deliveryCharge,
  String? vendorDeliveryCharge,
  String? hours,
  String? userName,
  String? userMobile,
  String? fixedAmount,
  String? pDate,
  String? uname,
  String? roll,
  List<ProductsDetails>? productsDetails,
}) => Data(  id: id ?? _id,
  date: date ?? _date,
  slot: slot ?? _slot,
  userId: userId ?? _userId,
  resId: resId ?? _resId,
  size: size ?? _size,
  status: status ?? _status,
  aStatus: aStatus ?? _aStatus,
  reason: reason ?? _reason,
  isPaid: isPaid ?? _isPaid,
  otp: otp ?? _otp,
  amount: amount ?? _amount,
  txnId: txnId ?? _txnId,
  address: address ?? _address,
  addressId: addressId ?? _addressId,
  paymentType: paymentType ?? _paymentType,
  createdAt: createdAt ?? _createdAt,
  subtotal: subtotal ?? _subtotal,
  discount: discount ?? _discount,
  addons: addons ?? _addons,
  total: total ?? _total,
  pickupLocation: pickupLocation ?? _pickupLocation,
  dropLocation: dropLocation ?? _dropLocation,
  assignFor: assignFor ?? _assignFor,
  bookingStatus: bookingStatus ?? _bookingStatus,
  paidAmount: paidAmount ?? _paidAmount,
  km: km ?? _km,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  dropLatitude: dropLatitude ?? _dropLatitude,
  dropLongitude: dropLongitude ?? _dropLongitude,
  bookingType: bookingType ?? _bookingType,
  serviceId: serviceId ?? _serviceId,
  noOfPerson: noOfPerson ?? _noOfPerson,
  typeOfBooking: typeOfBooking ?? _typeOfBooking,
  gstAmount: gstAmount ?? _gstAmount,
  items: items ?? _items,
  gstCharge: gstCharge ?? _gstCharge,
  deliveryCharge: deliveryCharge ?? _deliveryCharge,
  vendorDeliveryCharge: vendorDeliveryCharge ?? _vendorDeliveryCharge,
  hours: hours ?? _hours,
  userName: userName ?? _userName,
  userMobile: userMobile ?? _userMobile,
  fixedAmount: fixedAmount ?? _fixedAmount,
  pDate: pDate ?? _pDate,
  uname: uname ?? _uname,
  roll: roll ?? _roll,
  productsDetails: productsDetails ?? _productsDetails,
);
  String? get id => _id;
  String? get date => _date;
  String? get slot => _slot;
  String? get userId => _userId;
  String? get resId => _resId;
  String? get size => _size;
  String? get status => _status;
  String? get aStatus => _aStatus;
  dynamic get reason => _reason;
  String? get isPaid => _isPaid;
  String? get otp => _otp;
  String? get amount => _amount;
  String? get txnId => _txnId;
  String? get address => _address;
  String? get addressId => _addressId;
  String? get paymentType => _paymentType;
  String? get createdAt => _createdAt;
  String? get subtotal => _subtotal;
  String? get discount => _discount;
  String? get addons => _addons;
  String? get total => _total;
  String? get pickupLocation => _pickupLocation;
  String? get dropLocation => _dropLocation;
  String? get assignFor => _assignFor;
  String? get bookingStatus => _bookingStatus;
  String? get paidAmount => _paidAmount;
  String? get km => _km;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get dropLatitude => _dropLatitude;
  String? get dropLongitude => _dropLongitude;
  String? get bookingType => _bookingType;
  String? get serviceId => _serviceId;
  String? get noOfPerson => _noOfPerson;
  String? get typeOfBooking => _typeOfBooking;
  String? get gstAmount => _gstAmount;
  List<Items>? get items => _items;
  String? get gstCharge => _gstCharge;
  String? get deliveryCharge => _deliveryCharge;
  String? get vendorDeliveryCharge => _vendorDeliveryCharge;
  String? get hours => _hours;
  String? get userName => _userName;
  String? get userMobile => _userMobile;
  String? get fixedAmount => _fixedAmount;
  String? get pDate => _pDate;
  String? get uname => _uname;
  String? get roll => _roll;
  List<ProductsDetails>? get productsDetails => _productsDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['date'] = _date;
    map['slot'] = _slot;
    map['user_id'] = _userId;
    map['res_id'] = _resId;
    map['size'] = _size;
    map['status'] = _status;
    map['a_status'] = _aStatus;
    map['reason'] = _reason;
    map['is_paid'] = _isPaid;
    map['otp'] = _otp;
    map['amount'] = _amount;
    map['txn_id'] = _txnId;
    map['address'] = _address;
    map['address_id'] = _addressId;
    map['payment_type'] = _paymentType;
    map['created_at'] = _createdAt;
    map['subtotal'] = _subtotal;
    map['discount'] = _discount;
    map['addons'] = _addons;
    map['total'] = _total;
    map['pickup_location'] = _pickupLocation;
    map['drop_location'] = _dropLocation;
    map['assign_for'] = _assignFor;
    map['booking_status'] = _bookingStatus;
    map['paid_amount'] = _paidAmount;
    map['km'] = _km;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['drop_latitude'] = _dropLatitude;
    map['drop_longitude'] = _dropLongitude;
    map['booking_type'] = _bookingType;
    map['service_id'] = _serviceId;
    map['no_of_person'] = _noOfPerson;
    map['type_of_booking'] = _typeOfBooking;
    map['gst_amount'] = _gstAmount;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['gst_charge'] = _gstCharge;
    map['delivery_charge'] = _deliveryCharge;
    map['vendor_delivery_charge'] = _vendorDeliveryCharge;
    map['hours'] = _hours;
    map['user_name'] = _userName;
    map['user_mobile'] = _userMobile;
    map['fixed_amount'] = _fixedAmount;
    map['p_date'] = _pDate;
    map['uname'] = _uname;
    map['roll'] = _roll;
    if (_productsDetails != null) {
      map['products_details'] = _productsDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "45"
/// artist_name : "handysdfsdf"
/// category_id : "70"
/// sub_id : "0"
/// services_image : "https://sodindia.com/uploads/1684563994Screenshot_2023-05-15-13-30-06-374_com_sahayatri_driver.jpg"
/// profile_image : "6468681a8e9fd.jpg"
/// mrp_price : "200"
/// special_price : "400"
/// v_id : "69"
/// roll : "7"
/// ser_desc : "test yfydfsdggshg yufuddd jthuf"
/// service_status : "1"
/// tax_status : "0"
/// gst_amount : "0"
/// per_day_charge : ""

class ProductsDetails {
  ProductsDetails({
      String? id, 
      String? artistName, 
      String? categoryId, 
      String? subId, 
      String? servicesImage, 
      String? profileImage, 
      String? mrpPrice, 
      String? specialPrice, 
      String? vId, 
      String? roll, 
      String? serDesc, 
      String? serviceStatus, 
      String? taxStatus, 
      String? gstAmount, 
      String? perDayCharge,}){
    _id = id;
    _artistName = artistName;
    _categoryId = categoryId;
    _subId = subId;
    _servicesImage = servicesImage;
    _profileImage = profileImage;
    _mrpPrice = mrpPrice;
    _specialPrice = specialPrice;
    _vId = vId;
    _roll = roll;
    _serDesc = serDesc;
    _serviceStatus = serviceStatus;
    _taxStatus = taxStatus;
    _gstAmount = gstAmount;
    _perDayCharge = perDayCharge;
}

  ProductsDetails.fromJson(dynamic json) {
    _id = json['id'];
    _artistName = json['artist_name'];
    _categoryId = json['category_id'];
    _subId = json['sub_id'];
    _servicesImage = json['services_image'];
    _profileImage = json['profile_image'];
    _mrpPrice = json['mrp_price'];
    _specialPrice = json['special_price'];
    _vId = json['v_id'];
    _roll = json['roll'];
    _serDesc = json['ser_desc'];
    _serviceStatus = json['service_status'];
    _taxStatus = json['tax_status'];
    _gstAmount = json['gst_amount'];
    _perDayCharge = json['per_day_charge'];
  }
  String? _id;
  String? _artistName;
  String? _categoryId;
  String? _subId;
  String? _servicesImage;
  String? _profileImage;
  String? _mrpPrice;
  String? _specialPrice;
  String? _vId;
  String? _roll;
  String? _serDesc;
  String? _serviceStatus;
  String? _taxStatus;
  String? _gstAmount;
  String? _perDayCharge;
ProductsDetails copyWith({  String? id,
  String? artistName,
  String? categoryId,
  String? subId,
  String? servicesImage,
  String? profileImage,
  String? mrpPrice,
  String? specialPrice,
  String? vId,
  String? roll,
  String? serDesc,
  String? serviceStatus,
  String? taxStatus,
  String? gstAmount,
  String? perDayCharge,
}) => ProductsDetails(  id: id ?? _id,
  artistName: artistName ?? _artistName,
  categoryId: categoryId ?? _categoryId,
  subId: subId ?? _subId,
  servicesImage: servicesImage ?? _servicesImage,
  profileImage: profileImage ?? _profileImage,
  mrpPrice: mrpPrice ?? _mrpPrice,
  specialPrice: specialPrice ?? _specialPrice,
  vId: vId ?? _vId,
  roll: roll ?? _roll,
  serDesc: serDesc ?? _serDesc,
  serviceStatus: serviceStatus ?? _serviceStatus,
  taxStatus: taxStatus ?? _taxStatus,
  gstAmount: gstAmount ?? _gstAmount,
  perDayCharge: perDayCharge ?? _perDayCharge,
);
  String? get id => _id;
  String? get artistName => _artistName;
  String? get categoryId => _categoryId;
  String? get subId => _subId;
  String? get servicesImage => _servicesImage;
  String? get profileImage => _profileImage;
  String? get mrpPrice => _mrpPrice;
  String? get specialPrice => _specialPrice;
  String? get vId => _vId;
  String? get roll => _roll;
  String? get serDesc => _serDesc;
  String? get serviceStatus => _serviceStatus;
  String? get taxStatus => _taxStatus;
  String? get gstAmount => _gstAmount;
  String? get perDayCharge => _perDayCharge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['artist_name'] = _artistName;
    map['category_id'] = _categoryId;
    map['sub_id'] = _subId;
    map['services_image'] = _servicesImage;
    map['profile_image'] = _profileImage;
    map['mrp_price'] = _mrpPrice;
    map['special_price'] = _specialPrice;
    map['v_id'] = _vId;
    map['roll'] = _roll;
    map['ser_desc'] = _serDesc;
    map['service_status'] = _serviceStatus;
    map['tax_status'] = _taxStatus;
    map['gst_amount'] = _gstAmount;
    map['per_day_charge'] = _perDayCharge;
    return map;
  }

}

/// service_id : "45"
/// hours : "1"
/// subtotal : "400"
/// no_of_person : ""

class Items {
  Items({
      String? serviceId, 
      String? hours, 
      String? subtotal, 
      String? noOfPerson,}){
    _serviceId = serviceId;
    _hours = hours;
    _subtotal = subtotal;
    _noOfPerson = noOfPerson;
}

  Items.fromJson(dynamic json) {
    _serviceId = json['service_id'];
    _hours = json['hours'];
    _subtotal = json['subtotal'];
    _noOfPerson = json['no_of_person'];
  }
  String? _serviceId;
  String? _hours;
  String? _subtotal;
  String? _noOfPerson;
Items copyWith({  String? serviceId,
  String? hours,
  String? subtotal,
  String? noOfPerson,
}) => Items(  serviceId: serviceId ?? _serviceId,
  hours: hours ?? _hours,
  subtotal: subtotal ?? _subtotal,
  noOfPerson: noOfPerson ?? _noOfPerson,
);
  String? get serviceId => _serviceId;
  String? get hours => _hours;
  String? get subtotal => _subtotal;
  String? get noOfPerson => _noOfPerson;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['service_id'] = _serviceId;
    map['hours'] = _hours;
    map['subtotal'] = _subtotal;
    map['no_of_person'] = _noOfPerson;
    return map;
  }

}