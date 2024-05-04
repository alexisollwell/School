import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user/PersonaModel.dart';
import '../models/user/UserRegisterRequest.dart';
import '../models/user/UserRegisterResponse.dart';
import '../models/user/login.dart';
import '../models/user/updatePassword.dart';

Future<UserCredentialsResponse> loginService({
  required UserCredentials request,
}) async {
  try {
    var response = await http.post(
      Uri.parse("${urlServer}api/login"),
      body: jsonEncode(request),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);
      UserCredentialsResponse resp = UserCredentialsResponse.fromJson(parsed);
      token = resp.token!;
      loginPerson = await consultPersonByIdUser(id: resp.idUsuario!);
      userType = resp.tipo!;
      //userType = 2;
      //userType = 1;
      userId = resp.idUsuario!;

      return resp;
    }
    return UserCredentialsResponse();
  } catch (error) {
    return UserCredentialsResponse();
  }
}

Future<UserRegisterResponse> createUser(
    {required UserRegisterRequest data, required PersonaModel request}) async {
  final url = Uri.parse('${urlServer}api/register');
  try {
    final response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: jsonEncode(data));
    final status = response.statusCode;
    if (status == 200 || status == 201) {
      var parsed = json.decode(response.body);
      try {
        UserRegisterResponse resp = UserRegisterResponse.fromJson(parsed);
        request.usuarioId = resp.user!.id;
        await createPersona(data: request);
        return resp;
      } catch (error) {
        return UserRegisterResponse();
      }
    } else {
      return UserRegisterResponse();
    }
  } catch (e) {
    return UserRegisterResponse();
  }
}

Future<PersonaModel> consultPersonByIdUser({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/persona/usuario/$id');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return PersonaModel.fromJson(parsed[0]);
    } else {
      return PersonaModel(id: -1);
    }
  } catch (e) {
    return PersonaModel(id: -1);
  }
}

Future<User> consultUser({required int id}) async {
  final url = Uri.parse('${urlServer}api/user/$id');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      return User.fromJson(parsed);
    } else {
      return User(id: -1);
    }
  } catch (e) {
    return User(id: -1);
  }
}

Future<List<PersonaModel>> consultAllPersonas() async {
  final url = Uri.parse('${urlServer}api/v1/persona');
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      //HttpHeaders.contentTypeHeader: 'application/json',
    });
    final status = response.statusCode;
    if (status == 200) {
      var parsed = json.decode(response.body);
      List<PersonaModel> temporal =
          List<PersonaModel>.from(parsed.map((x) => PersonaModel.fromJson(x)));

      List<PersonaModel> resp = [];
      for (int index = 0; index < temporal.length; index++) {
        User tmp = await consultUser(id: temporal[index].usuarioId!);
        if (tmp.id > 0) {
          resp.add(PersonaModel(
              id: temporal[index].id,
              nombre: temporal[index].nombre,
              apellido: temporal[index].apellido,
              fechaNaC: temporal[index].fechaNaC,
              domicilio: temporal[index].domicilio,
              telefono: temporal[index].telefono,
              correo: temporal[index].correo,
              edoCivil: temporal[index].edoCivil,
              nacionalidad: temporal[index].nacionalidad,
              estatus: temporal[index].estatus,
              campusId: temporal[index].campusId,
              usuarioId: temporal[index].usuarioId,
              tipo: tmp.tipo));
        }
      }
      return resp;
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<PersonaModel> createPersona({required PersonaModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/persona');
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
      return PersonaModel.fromJson(parsed);
    } else {
      return PersonaModel(id: -1);
    }
  } catch (e) {
    return PersonaModel(id: -1);
  }
}

Future<PersonaModel> updatePersona({required PersonaModel data}) async {
  final url = Uri.parse('${urlServer}api/v1/persona/${data.id}');
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
      return PersonaModel.fromJson(parsed);
    } else {
      return PersonaModel(id: -1);
    }
  } catch (e) {
    return PersonaModel(id: -1);
  }
}

Future<bool> updatePersonaPassword(
    {required PersonaModel data, required UpdatePassword pss}) async {
  final url = Uri.parse('${urlServer}api/update/${data.id}');
  try {
    final response = await http.put(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(pss));
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

Future<bool> deletePersona({required int id}) async {
  final url = Uri.parse('${urlServer}api/v1/persona/$id');
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
