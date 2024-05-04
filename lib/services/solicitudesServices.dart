import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:school/services/updatePruebaModelo.dart';
import '../constants.dart';
import '../models/PreguntaRespuesta.dart';
import '../models/Respuesta.dart';
import '../models/SolicitudPrueba.dart';
import '../models/SolicitudesModel.dart';

Future<List<SolicitudesModel>> consultAllSolicitudes(int usuarioId) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud/usuario/$usuarioId');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return List<SolicitudesModel>.from(
          parsed.map((x) => SolicitudesModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print("consult solicitude : $e");
    return [];
  }
}

Future<List<SolicitudesModel>> consultAllSolicitudesALL() async {
  final url = Uri.parse('${urlServer}api/v1/solicitud');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      print(parsed);
      return List<SolicitudesModel>.from(
          parsed.map((x) => SolicitudesModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print("consult solicitude : $e");
    return [];
  }
}

Future<List<SolicitudesModel>> consultAllSolicitudesByPersona(int id) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud/persona/$id');
  print(url);
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      print(parsed);
      return List<SolicitudesModel>.from(
          parsed.map((x) => SolicitudesModel.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print("consult solicitude : $e");
    return [];
  }
}

Future<List<SolicitudPrueba>> consultAllSolicitudesPruebaByPersona(
    int id) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud-pruebas/solicitud/$id');
  print(url);
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      print(parsed);
      return List<SolicitudPrueba>.from(
          parsed.map((x) => SolicitudPrueba.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print("consult solicitude : $e");
    return [];
  }
}

Future<SolicitudesModel> createSolicitudes(
    {required SolicitudesModel data, required List<int> tests}) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud');
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
      SolicitudesModel resp = SolicitudesModel.fromJson(parsed);

      for (int item in tests) {
        await createSolicitudesPruebas(
            data: SolicitudPrueba(
                id: -1,
                fechaAplicacion: data.fechaAplicacion!,
                personaId: data.personaId!,
                periodoId: data.periodoId!,
                pruebasId: item,
                comentarios: "",
                estatus: '1',
                solicitudId: resp.id));
      }

      return resp;
    } else {
      return SolicitudesModel(id: -1);
    }
  } catch (e) {
    return SolicitudesModel(id: -1);
  }
}

Future<List<PreguntaRespuesta>> consultaPreguntas(int id) async {
  final url = Uri.parse('${urlServer}api/v1/preguntas/prueba/$id');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      //var parsed = json.decode(response.body);
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((dynamic item) {
        Pregunta pregunta = Pregunta.fromJson(item[0]);
        List<Respuesta> respuestas =
            List<Respuesta>.from(item[1].map((r) => Respuesta.fromJson(r)));
        return PreguntaRespuesta(pregunta: pregunta, respuestas: respuestas);
      }).toList();
      //return List<PreguntaRespuesta>.from(parsed.map((x) => PreguntaRespuesta.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    print("consult solicitude : $e");
    return [];
  }
}

Future<bool> guardarRespuesta({required RespuestaTest data}) async {
  final url = Uri.parse('${urlServer}api/v1/respuestaevaluado');
  try {
    final response = await http.post(
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
      //SolicitudesModel resp = SolicitudesModel.fromJson(parsed);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> createSolicitudesPruebas({required SolicitudPrueba data}) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud-pruebas');
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

Future<bool> updateSolicitudesPrueba({required updatePruebaModelo data}) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud-pruebas/${data.id}');
  print(url);
  print(jsonEncode(data));
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
      print(parsed);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<SolicitudesModel> updateSolicitudes(
    {required SolicitudesModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud/${data.id}');
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
      return SolicitudesModel.fromJson(parsed);
    } else {
      return SolicitudesModel(id: -1);
    }
  } catch (e) {
    print(e);
    return SolicitudesModel(id: -1);
  }
}

Future<bool> deleteSolicitudes({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/solicitud/$id');
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
