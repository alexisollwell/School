import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:school/models/CampusModel.dart';
import '../constants.dart';

Future<List<CampusModel>> consultAllCampus() async {
  final url = Uri.parse('${urlServer}api/v1/campus');
  try {
    final response = await http.get(url, 
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<CampusModel>.from(parsed.map((x) => CampusModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<CampusModel> createCampus({required CampusModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/campus');
  try {
    final response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(data));
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return CampusModel.fromJson(parsed);
    } else {
      return CampusModel(id: -1);
    }
  } catch (e) {
    return CampusModel(id: -1);
  }
}

Future<CampusModel> updateCampus({required CampusModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/campus/${data.id}');
  try {
    final response = await http.put(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(data),
    );
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return CampusModel.fromJson(parsed);
    } else {
      return CampusModel(id: -1);
    }
  } catch (e) {
    print(e);
    return CampusModel(id: -1);
  }
}

Future<bool> deleteCampus({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/campus/$id');
  try {
    final response = await http.delete(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}