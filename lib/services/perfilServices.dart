import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/PerfilModel.dart';
import '../models/PruebasPerfil.dart';

Future<List<PerfilModel>> consultAllPerfil() async {
  final url = Uri.parse('${urlServer}api/v1/perfil');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<PerfilModel>.from(parsed.map((x) => PerfilModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<PerfilModel> createPerfil({required PerfilModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/perfil');
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
      return PerfilModel.fromJson(parsed);
    } else {
      return PerfilModel(id: -1);
    }
  } catch (e) {
    return PerfilModel(id: -1);
  }
}

Future<PerfilModel> updatePerfil({required PerfilModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/perfil/${data.id}');
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
      return PerfilModel.fromJson(parsed);
    } else {
      return PerfilModel(id: -1);
    }
  } catch (e) {
    return PerfilModel(id: -1);
  }
}

Future<bool> deletePerfil({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/perfil/$id');
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

Future<List<PruebasPerfil>> consultAllPerfilTest({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/prueba/pruebas/$id');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<PruebasPerfil>.from(
          parsed.map((x) => PruebasPerfil.fromJson(x['pivot'])));
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<PruebasPerfil> createPerfilPrueba({required PruebasPerfil data}) async {
  final url = Uri.parse('${urlServer}api/v1/prueba/pruebas');
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
      return PruebasPerfil.fromJson(parsed);
    } else {
      return PruebasPerfil(prueba_id: -1, perfil_id: -1);
    }
  } catch (e) {
    return PruebasPerfil(prueba_id: -1, perfil_id: -1);
  }
}

Future<bool> deletePerfilPrueba({required PruebasPerfil data}) async {
  final url = Uri.parse('${urlServer}api/v1/prueba/elipruebas');
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
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
