import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter_grocery/Widgets/app_constant.dart';
import 'package:flutter_grocery/Widgets/pref_string.dart';
import 'package:http/http.dart' as http;


class HttpHandler {
  static String endPointUrl = APIEndpoints.endPoint;

  static Future<Map<String, String>> getHeaders() async {


    // final token = SharedPreferenceIml.shared.instance.getString('token');

    // if (token != null) {
    //   debugPrint("Token -- '$token'");
    //   return {
    //     'Content-type': 'application/json',
    //     'Accept': 'application/json',
    //     "token": token
    //   };
    // } else {
    //   return {
    //     'Content-type': 'application/json',
    //     'Accept': 'application/json',
    //   };
    // }
  }

  static Future<Map<String, dynamic>> getHttpMethod({@required String url, headers}) async {
    var header = await getHeaders();
    debugPrint("Get URL -- '$endPointUrl$url'");
    debugPrint("Get Data -- 'null'");
    debugPrint("Get Header -- '$header'");
    http.Response response = await http.get(
      Uri.parse("$endPointUrl$url"),
      headers: headers ?? header,
    );
    debugPrint("Get Response Code -- '${response.statusCode}'");
    debugPrint("Get Response -- '${response.body}'");
    if (response.statusCode == 200) {
      debugPrint("In Get '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      return data;
    } else if (response.statusCode == 401) {
      debugPrint("In Get '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      // pref!.clear();
      // Get.offAll(() => const SplashScreen());
      return data;
    } else {
      debugPrint("In Get 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  static Future<Map<String, dynamic>> postHttpMethod({@required String url, Map<String, dynamic> data}) async {
    var header = await getHeaders();
    debugPrint("Post URL -- '$endPointUrl$url'");
    debugPrint("Post Data -- '$data'");
    debugPrint("Post Header -- '$header'");
    http.Response response = await http.post(
      Uri.parse("$endPointUrl$url"),
      headers: header,
      body: data == null ? null : jsonEncode(data),
    );
    debugPrint("Post Response Code -- '${response.statusCode}'");
    debugPrint("Post Response -- '${response.body}'");
    if (response.statusCode == 200) {
      return {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
    } else if (response.statusCode == 401) {
      debugPrint("In Get '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      // pref!.clear();
      // Get.offAll(() => const SplashScreen());
      return data;
    } else {
      debugPrint("In Post 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  static Future<Map<String, dynamic>> patchHttpMethod({@required String url, Map<String, dynamic> data}) async {
    var header = await getHeaders();
    debugPrint("Patch URL -- '$endPointUrl$url'");
    debugPrint("Patch Data -- '$data'");
    debugPrint("Patch Header -- '$header'");
    http.Response response = await http.patch(
      Uri.parse("$endPointUrl$url"),
      headers: header,
      body: data == null ? null : jsonEncode(data),
    );
    debugPrint("Patch Response Code -- '${response.statusCode}'");
    debugPrint("Patch Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("In Patch '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      return data;
    } else if (response.statusCode == 401) {
      debugPrint("In Get '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      // pref!.clear();
      // Get.offAll(() => const SplashScreen());
      return data;
    } else {
      debugPrint("In Patch 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  static Future<Map<String, dynamic>> putHttpMethod({@required String url, Map<String, dynamic> data}) async {
    var header = await getHeaders();
    debugPrint("Put URL -- '$endPointUrl$url'");
    debugPrint("Put Data -- '$data'");
    debugPrint("Put Header -- '$header'");
    http.Response response = await http.put(
      Uri.parse("$endPointUrl$url"),
      headers: header,
      body: data == null ? null : jsonEncode(data),
    );
    debugPrint("PUT Response code -- '${response.statusCode}'");
    debugPrint("PUT Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("In Put '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      return data;
    } else if (response.statusCode == 401) {
      debugPrint("In Get '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      // pref!.clear();
      // Get.offAll(() => const SplashScreen());
      return data;
    } else {
      debugPrint("In Put 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  static Future<Map<String, dynamic>> deleteHttpMethod({@required String url}) async {
    var header = await getHeaders();
    debugPrint("Delete URL -- '$endPointUrl$url'");
    debugPrint("Delete Data -- 'null'");
    debugPrint("Delete Header -- '$header'");
    http.Response response = await http.delete(
      Uri.parse("$endPointUrl$url"),
      headers: header,
    );
    debugPrint("Delete Response Code -- '${response.statusCode}'");
    debugPrint("Delete Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("In Delete '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      return data;
    } else if (response.statusCode == 401) {
      debugPrint("In Get '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      // pref!.clear();
      // Get.offAll(() => const SplashScreen());
      return data;
    } else {
      debugPrint("In Delete 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  static Future<Map<String, dynamic>> formHttpMethod(
      {@required String methodType,
        @required String url,
        Map<String, String> data,
        File singleFile,
        File singleFile2,
        String singleFileKey,
        String singleFileKey2,
        List<File> multipleFile,
        String multipleFileKey}) async {
    var header = await getHeaders();
    debugPrint("Form URL -- '$endPointUrl$url'");
    debugPrint("Form Header -- '$header'");
    http.MultipartRequest request = http.MultipartRequest(methodType, Uri.parse("$endPointUrl$url"));
    request.headers.addAll(header);
    if (data != null) {
      request.fields.addAll(data);
    }
    if (singleFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        singleFileKey,
        singleFile.path,
      ));
    }
    if (singleFile2 != null) {
      request.files.add(await http.MultipartFile.fromPath(
        singleFileKey2,
        singleFile2.path,
      ));
    }
    if (multipleFile.isNotEmpty) {
      for (File element in multipleFile) {
        request.files.add(await http.MultipartFile.fromPath(
          multipleFileKey,
          element.path,
        ));
      }
    }

    debugPrint("FORM FIELDS - ${request.fields}");
    debugPrint("FORM FILES - ${request.files}");
    http.StreamedResponse streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
      http.Response response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("In Post '${response.statusCode}'");
        debugPrint("FORM RESPONSE -- '${response.body}'");
        int status = json.decode(response.body)["status"];
        if (kDebugMode) {
          print("STATUS _+_+_+_+_+_+_ $status");
        }
        Map<String, dynamic> data;
        if (status == 1) {
          data = {
            'body': response.body,
            'headers': response.headers,
            'error': null,
          };
        } else {
          data = {
            'body': response.body,
            'headers': response.headers,
            'error': status,
          };
        }
        return data;
      } else if (response.statusCode == 401) {
        debugPrint("In Get '${response.statusCode}'");
        Map<String, dynamic> data = {
          'body': response.body,
          'headers': response.headers,
          'error': null,
        };
        // pref!.clear();
        // Get.offAll(() => const SplashScreen());
        return data;
      } else {
        debugPrint("In Form 'else - ${response.statusCode}'");
        return {
          'body': response.body,
          'headers': response.headers,
          'error': "${response.statusCode}",
        };
      }
    } else {
      debugPrint("In Form 'else ---- ${streamedResponse.statusCode}'");
      return {
        'headers': streamedResponse.headers,
        'error': "${streamedResponse.statusCode}",
      };
    }
  }
}
