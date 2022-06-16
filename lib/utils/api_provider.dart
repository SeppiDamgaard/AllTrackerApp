import 'package:alltracker_app/main.dart';
import 'package:alltracker_app/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'dart:convert';


// main class for make request
class ApiProvider {
  // final String _baseUrl = AppConfig.getInstance().apiUrl;

  Future<dynamic> get(String url,
      [Map<String, dynamic> queryParams = const {}]) async {
    Dio httpClient = await DioClient.getInstance();

    String fullUrl;
    if (url.startsWith('http')) {
      fullUrl = url;
    } else {
      fullUrl = serverIp + url;
    }

    dynamic response;
    response = await httpClient.get(fullUrl, queryParameters: queryParams);
        

    return response.data;
  }

  Future<dynamic> post(String url,
      {Map<String, dynamic> jsonBody = const {}, bool formData = false}) async {
    Dio httpClient = await DioClient.getInstance();

    String fullUrl;
    if (url.startsWith('http')) {
      fullUrl = url;
    } else {
      fullUrl = serverIp + url;
    }

    dynamic body;

    if (formData) {
      body = FormData.fromMap(jsonBody);
    } else {
      body = jsonBody;
    }

    final response = await httpClient.post(fullUrl, data: body);

    return response.data;
  }

  Future<dynamic> put(String url,
      {Map<String, dynamic> jsonBody = const {}, bool formData = false}) async {
    Dio httpClient = await DioClient.getInstance();

    String fullUrl;
    if (url.startsWith('http')) {
      fullUrl = url;
    } else {
      fullUrl = serverIp + url;
    }

    String encodedBody = json.encode(jsonBody);

    dynamic body;

    if (formData) {
      body = FormData.fromMap(jsonBody);
    } else {
      body = encodedBody;
    }

    final response = await httpClient.put(fullUrl, data: body);

    return response.data;
  }

  Future<dynamic> patch(String url,
      {Map<String, dynamic> jsonBody = const {}, bool formData = false}) async {
    Dio httpClient = await DioClient.getInstance();

    String fullUrl;
    if (url.startsWith('http')) {
      fullUrl = url;
    } else {
      fullUrl = serverIp + url;
    }

    String encodedBody = json.encode(jsonBody);

    dynamic body;

    if (formData) {
      body = FormData.fromMap(jsonBody);
    } else {
      body = encodedBody;
    }

    final response = await httpClient.patch(fullUrl, data: body);

    return response.data;
  }

  Future<dynamic> delete(String url) async {
    Dio httpClient = await DioClient.getInstance();

    String fullUrl;
    if (url.startsWith('http')) {
      fullUrl = url;
    } else {
      fullUrl = serverIp + url;
    }

    final response = await httpClient.delete(fullUrl);

    return response.data;
  }
}
