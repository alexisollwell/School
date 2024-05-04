import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/DivisionesModel.dart';

Future<List<DivisionesModel>> consultAllDivisionActive() async {
  final url = Uri.parse('${urlServer}api/v1/division/activo/');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<DivisionesModel>.from(
          parsed.map((x) => DivisionesModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List<DivisionesModel>> consultAllDivision() async {
  final url = Uri.parse('${urlServer}api/v1/division');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<DivisionesModel>.from(
          parsed.map((x) => DivisionesModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<DivisionesModel> createDivision({required DivisionesModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/division');
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
      return DivisionesModel.fromJson(parsed);
    } else {
      return DivisionesModel(id: -1);
    }
  } catch (e) {
    return DivisionesModel(id: -1);
  }
}

Future<DivisionesModel> updateDivision({required DivisionesModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/division/${data.id}');
  try {
    final response = await http.put(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(data));
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return DivisionesModel.fromJson(parsed);
    } else {
      return DivisionesModel(id: -1);
    }
  } catch (e) {
    return DivisionesModel(id: -1);
  }
}

Future<bool> deleteDivision({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/division/$id');
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
