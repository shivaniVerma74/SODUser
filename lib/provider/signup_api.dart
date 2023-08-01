import 'dart:convert';
import 'package:ez/constant/global.dart';
import 'package:ez/models/signup_model.dart';
import 'package:http/http.dart' as http;

class SignupApi {
  Future<signupModel> signupApi(
    String email,
    String password,
    String username,
      String mobile,
  ) async {
    var responseJson;
    var uri = Uri.parse('${baseUrl()}/register');
    var request = http.MultipartRequest('POST', uri)
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['mobile'] = mobile
      ..fields['username'] = username;

    print(uri.toString());
    print(request.fields);
    // var response = await request.send();
    http.Response response =
    await http.Response.fromStream(await request.send());
    responseJson = _returnResponse(response);
    return signupModel.fromJson(responseJson);

    // var responseJson;
    // await http.post('${baseUrl()}/register', body: {
    //   'email': email,
    //   'password': password,
    //   'username': username,
    //   'profile_pic': image,
    // }).then((response) {
    //   responseJson = _returnResponse(response);
    // }).catchError((onError) {
    //   print(onError);
    // });
    // return SignUpModel.fromJson(responseJson);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());

        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 401:
        throw Exception(response.body.toString());
      case 403:
        throw Exception(response.body.toString());
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
