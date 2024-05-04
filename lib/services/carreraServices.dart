import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/CarreraModel.dart';

Future<List<CarreraModel>> consultAllCarrera() async {
  final url = Uri.parse('${urlServer}api/v1/carrera');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<CarreraModel>.from(
          parsed.map((x) => CarreraModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<CarreraModel> createCarrera({required CarreraModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/carrera');
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
      return CarreraModel.fromJson(parsed);
    } else {
      return CarreraModel(id: -1);
    }
  } catch (e) {
    return CarreraModel(id: -1);
  }
}

Future<CarreraModel> updateCarrera({required CarreraModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/carrera/${data.id}');
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
      return CarreraModel.fromJson(parsed);
    } else {
      return CarreraModel(id: -1);
    }
  } catch (e) {
    return CarreraModel(id: -1);
  }
}

Future<bool> deleteCarrera({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/carrera/$id');
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
