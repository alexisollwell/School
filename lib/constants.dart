import 'dart:ui';
import 'models/CampusModel.dart';
import 'models/CarreraModel.dart';
import 'models/DivisionesModel.dart';
import 'models/PerfilModel.dart';
import 'models/PeriodoModel.dart';
import 'models/PruebasModel.dart';
import 'models/SolicitudesModel.dart';
import 'models/user/PersonaModel.dart';

String urlServer = "http://192.168.4.179/";

Color orange1 = const Color(0xFFEC6C21);
Color orange2 = const Color(0xFFEC9F0A);
Color orange3 = const Color(0xFFED8D18);
Color orange4 = const Color(0xFFF1Bf86);
Color orange5 = const Color(0xFFCA7432);
Color orange6 = const Color(0xFFBA7646);
Color red1 = const Color(0xFFEA5949);
Color red2 = const Color(0xFFE87361);

List<CampusModel> campus = [];
List<DivisionesModel> listaDivisiones = [];
List<CarreraModel> listaCarrera = [];
List<PruebasModel> listaPruebas = [];
List<PerfilModel> listaPerfiles = [];
List<PeriodoModel> listaPeriodos = [];
List<PersonaModel> listaPersonas = [];
List<SolicitudesModel> listaSolicitudes = [];
List<String> typeUsers = ["Admin", "Psicologos", "Evaluado", "RH"];
List<String> statusTest = ["Generado", "En proceso", "Completado", "Cancelado"];
List<String> nationality = ["Mexicano(a)", "Extranjero"];
List<String> edoCivil = [
  "Soltero(a)",
  "Casado(a)",
  "Divorciado(a)",
  "Separado(a)",
  "Viudo(a)",
  "Unión libre"
];
PersonaModel loginPerson = PersonaModel(id: -1);
String token = "";
int userType = 1;
int userId = 1;
