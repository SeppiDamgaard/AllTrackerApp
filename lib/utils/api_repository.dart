import 'package:alltracker_app/models/consumption_post.dart';
import 'package:alltracker_app/models/consumption_registration.dart';
import 'package:alltracker_app/utils/api_provider.dart';
import 'package:alltracker_app/utils/extensions.dart';
import 'package:dio/dio.dart';
import 'package:easy_cron/easy_cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiRepository {
  final ApiProvider _provider = ApiProvider();

  Future<bool> verifyLogin() async {
    try {
      await _provider.get("Login/Status");
      return true;
    } on DioError {
      return false;
    }
  }

  Future<String> attemptLogIn(String username, String password) async {
    Map<String, dynamic> body = {
      "identifier": username,
      "password": password
    };
    try {
      final res = await _provider.post("Login/Login", jsonBody: body);
      const FlutterSecureStorage().write(key: "jwt", value: res["token"]);
      return "";
    } on DioError catch (e) {
      debugPrint(e.response?.data ?? "error");
      return e.response?.data ?? "Unhandled error";
    }
  }

  Future<String> registerUser(String username, String password) async {
    Map<String, dynamic> body = {
      "identifier": username,
      "password": password
    };

    try {
      await _provider.post("RegisterUser", jsonBody: body);
      return await attemptLogIn(username, password);
    } on DioError catch (e) {
      return e.message; 
    }
  }

  Future<List<ConsumptionPost>> makeRegistrations() async {
    final parser = UnixCronParser();
    DateTime now = DateTime.now().onlyDate();
    String dateString = now.toIso8601String();
    try {
      final res = await _provider.get("ConsumptionPost/GetPosts");
        // ..removeWhere((cp) => !parser.parse(cp["cronString"])
        //   .next(date).time.isSameDate(date));
      
      List<ConsumptionPost> allPosts = res
        .map<ConsumptionPost>((cp) => ConsumptionPost.fromJson(cp)).toList();
      List<ConsumptionPost> output = [];
      for (var post in allPosts) {
        bool valid = false;

        if(post.cronString.contains("/")){
          int incrementValue = int.parse(post.cronString.split(" ")
            .firstWhere((c) => c.contains("/")).substring(2));
          if(now.difference(post.lastModified!).inDays % incrementValue == 0){
            valid = true;
          }
        } else {
          if(parser.parse(post.cronString).next(now).time.isSameDate(now)) {
            valid = true;
          }
        }
        if(valid){
          final res = await _provider.get(
            "ConsumptionRegistration/GetDailyRegistration",
            <String, dynamic> {
              "postId": post.id,
              "date": dateString
            }
          );
          post.registrations.add(ConsumptionRegistration.fromJson(res));
          output.add(post);
        }
      }
      return output;
    } on DioError catch (e) {
      return e.response?.data;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<ConsumptionRegistration> updateRegistrationAmount(ConsumptionRegistration registration) async {
    final res = await _provider.patch(
      "ConsumptionRegistration/PatchRegistration",
      jsonBody: <String, dynamic> {
        "id": registration.id,
        "amount": registration.amount
      }
    );
    return ConsumptionRegistration.fromJson(res);
  }

  Future<List<ConsumptionRegistration>> getRegistrations(String postId) async {
    try {
      final res = await _provider.get("ConsumptionRegistration/GetRegistrations/$postId");
      var tmp = res.map<ConsumptionRegistration>((cr) => ConsumptionRegistration.fromJson(cr)).toList();
      return tmp;
    } on DioError catch (e) {
      return e.response?.data;
    } catch (q) {
      debugPrint(q.toString());
      return [];
    }
  }

  Future<ConsumptionPost> createPost({
    required String name, 
    required String unit, 
    required String cronString,
    required double firstIncrement,
    required double secondIncrement,
    required double thirdIncrement}) async {

    final body = {
      "name": name,
      "unit": unit,
      "cronString": cronString,
      "firstIncrement": firstIncrement,
      "secondIncrement": secondIncrement,
      "thirdIncrement": thirdIncrement
    };

    try {
      final res = await _provider.post("ConsumptionPost/CreatePost", jsonBody: body);
      return ConsumptionPost.fromJson(res);
    } on DioError catch (e) {
      debugPrint(e.response?.data ?? "error");
      return e.response?.data ?? "Unhandled error";
    }
  }

  Future<ConsumptionPost> updatePost({
    required String id, 
    required String name, 
    required String unit, 
    required String cronString,
    required double firstIncrement,
    required double secondIncrement,
    required double thirdIncrement
  }) async {
    final body = {
      "id": id,
      "name": name,
      "unit": unit,
      "cronString": cronString,
      "firstIncrement": firstIncrement,
      "secondIncrement": secondIncrement,
      "thirdIncrement": thirdIncrement
    };
    try {
      final res = await _provider.put("ConsumptionPost/PutPost", jsonBody: body);
      return ConsumptionPost.fromJson(res);
    } on DioError catch (e) {
      return e.response?.data ?? "Unhandled error";
    }
  }

  Future<String> deletePost (String id) async {
    try {
      _provider.delete("ConsumptionPost/DeletePost/$id");
      return "";
    } on DioError catch (e) {
      return e.response?.data ?? "Unhandled error";
    }
  }
}