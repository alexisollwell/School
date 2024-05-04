import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/PruebasModel.dart';
import '../models/ResultadoPrueba.dart';
import '../models/ResultadoPruebaRequest.dart';

Future<List<PruebasModel>> consultAllPruebas() async {
  final url = Uri.parse('${urlServer}api/v1/prueba');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<PruebasModel>.from(
          parsed.map((x) => PruebasModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<PruebasModel> createPrueba({required PruebasModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/prueba');
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
      return PruebasModel.fromJson(parsed);
    } else {
      return PruebasModel(id: -1);
    }
  } catch (e) {
    return PruebasModel(id: -1);
  }
}

Future<PruebasModel> updatePrueba({required PruebasModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/prueba/${data.id}');
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
      return PruebasModel.fromJson(parsed);
    } else {
      return PruebasModel(id: -1);
    }
  } catch (e) {
    return PruebasModel(id: -1);
  }
}

Future<bool> deletePrueba({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/prueba/$id');
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

Future<List<ResultadoPrueba>> consulPruebasResultados(
    {required ResultadoPruebaRequest data}) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud-pruebas/resultados');
  print(url);
  try {
    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    final status = response.statusCode;
    print(status);
    if (status == 200) {
      var parsed = json.decode(response.body);
      print(parsed);
      return List<ResultadoPrueba>.from(
          parsed.map((x) => ResultadoPrueba.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}
