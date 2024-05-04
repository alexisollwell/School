import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/PeriodoModel.dart';

Future<List<PeriodoModel>> consultAllPeriodos() async {
  final url = Uri.parse('${urlServer}api/v1/periodo');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<PeriodoModel>.from(
          parsed.map((x) => PeriodoModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<PeriodoModel> createPeriodo({required PeriodoModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/periodo');
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
      return PeriodoModel.fromJson(parsed);
    } else {
      return PeriodoModel(id: -1);
    }
  } catch (e) {
    return PeriodoModel(id: -1);
  }
}

Future<PeriodoModel> updatePeriodo({required PeriodoModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/periodo/${data.id}');
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
      return PeriodoModel.fromJson(parsed);
    } else {
      return PeriodoModel(id: -1);
    }
  } catch (e) {
    return PeriodoModel(id: -1);
  }
}

Future<bool> deletePeriodo({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/periodo/$id');
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
