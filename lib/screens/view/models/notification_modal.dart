/// status : true
/// message : "Notifications list"
/// data : [{"not_id":"1571","user_id":"62","data_id":"305","type":"","title":"New order","message":"order place Dear Shivani, Thanks for placing order 305 with SOD. We have received your order of amount Rs1185.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"1569","user_id":"62","data_id":"304","type":"","title":"New order","message":"order place Dear new, Thanks for placing order 304 with SOD. We have received your order of amount Rs. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"1491","user_id":"62","data_id":"283","type":"","title":"New order","message":"order place Dear new, Thanks for placing order 283 with SOD. We have received your order of amount Rs149.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"1322","user_id":"62","data_id":"201","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 201 with SOD. We have received your order of amount Rs828.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"972","user_id":"62","data_id":"183","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 183 with SOD. We have received your order of amount Rs303.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"956","user_id":"62","data_id":"181","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 181 with SOD. We have received your order of amount Rs303.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"938","user_id":"62","data_id":"180","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 180 with SOD. We have received your order of amount Rs303.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"923","user_id":"62","data_id":"179","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 179 with SOD. We have received your order of amount Rs303.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"911","user_id":"62","data_id":"178","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 178 with SOD. We have received your order of amount Rs303.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"810","user_id":"62","data_id":"173","type":"","title":"New order","message":"order place Dear karan, Thanks for placing order 173 with SOD. We have received your order of amount Rs303.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"767","user_id":"62","data_id":"172","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 172 with SOD. We have received your order of amount Rs198.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"460","user_id":"62","data_id":"","type":"Food","title":"Approved Profile","message":"Hello  Food Service ,Your Profile is approved by admin","date":"0000-00-00 00:00:00"},{"not_id":"459","user_id":"62","data_id":"","type":"Food","title":"Disapproved Profile","message":"Hello  Food Service ,Your Profile is Disapproved by admin","date":"0000-00-00 00:00:00"},{"not_id":"416","user_id":"62","data_id":"160","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 160 with SOD. We have received your order of amount Rs198.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"405","user_id":"62","data_id":"159","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 159 with SOD. We have received your order of amount Rs303.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"381","user_id":"62","data_id":"157","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 157 with SOD. We have received your order of amount Rs135.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"358","user_id":"62","data_id":"156","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 156 with SOD. We have received your order of amount Rs303.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"},{"not_id":"334","user_id":"62","data_id":"152","type":"","title":"New order","message":"order place Dear Karan, Thanks for placing order 152 with SOD. We have received your order of amount Rs247.00. ServiceOnDemand RKRS Tech PVT LTD","date":"0000-00-00 00:00:00"}]

class NotificationModal {
  NotificationModal({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  NotificationModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Data>? _data;
NotificationModal copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => NotificationModal(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// not_id : "1571"
/// user_id : "62"
/// data_id : "305"
/// type : ""
/// title : "New order"
/// message : "order place Dear Shivani, Thanks for placing order 305 with SOD. We have received your order of amount Rs1185.00. ServiceOnDemand RKRS Tech PVT LTD"
/// date : "0000-00-00 00:00:00"

class Data {
  Data({
      String? notId, 
      String? userId, 
      String? dataId, 
      String? type, 
      String? title, 
      String? message, 
      String? date,}){
    _notId = notId;
    _userId = userId;
    _dataId = dataId;
    _type = type;
    _title = title;
    _message = message;
    _date = date;
}

  Data.fromJson(dynamic json) {
    _notId = json['not_id'];
    _userId = json['user_id'];
    _dataId = json['data_id'];
    _type = json['type'];
    _title = json['title'];
    _message = json['message'];
    _date = json['date'];
  }
  String? _notId;
  String? _userId;
  String? _dataId;
  String? _type;
  String? _title;
  String? _message;
  String? _date;
Data copyWith({  String? notId,
  String? userId,
  String? dataId,
  String? type,
  String? title,
  String? message,
  String? date,
}) => Data(  notId: notId ?? _notId,
  userId: userId ?? _userId,
  dataId: dataId ?? _dataId,
  type: type ?? _type,
  title: title ?? _title,
  message: message ?? _message,
  date: date ?? _date,
);
  String? get notId => _notId;
  String? get userId => _userId;
  String? get dataId => _dataId;
  String? get type => _type;
  String? get title => _title;
  String? get message => _message;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['not_id'] = _notId;
    map['user_id'] = _userId;
    map['data_id'] = _dataId;
    map['type'] = _type;
    map['title'] = _title;
    map['message'] = _message;
    map['date'] = _date;
    return map;
  }

}