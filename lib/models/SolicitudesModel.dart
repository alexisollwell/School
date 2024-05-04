class SolicitudesModel {
  int id;
  String? fechaAplicacion;
  String? estatus;
  String? comentarios;
  int? usuarioCapturoId;
  int? carreraId;
  int? periodoId;
  int? personaId;
  String? Resultados;
  String? Fecha_analisis;

  SolicitudesModel({
    required this.id,
    this.fechaAplicacion,
    this.estatus,
    this.comentarios,
    this.usuarioCapturoId,
    this.carreraId,
    this.periodoId,
    this.personaId,
    this.Resultados,
    this.Fecha_analisis,
  });

  factory SolicitudesModel.fromJson(Map<String, dynamic> json) {
    return SolicitudesModel(
      id: int.parse(json['id'].toString()),
      fechaAplicacion: json['Fecha_aplicacion'],
      estatus: json['Estatus']==null?"1":json['Estatus'].toString(),
      comentarios: json['Comentarios'],
      usuarioCapturoId: int.parse(json['Usuario_capturo_id'].toString()),
      carreraId: int.parse(json['Carrera_id'].toString()),
      periodoId: int.parse(json['Periodo_id'].toString()),
      personaId: int.parse(json['Persona_id'].toString()),
      Resultados: json['Resultados'],
      Fecha_analisis: json['Fecha_analisis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Fecha_aplicacion': fechaAplicacion,
      'Estatus': estatus,
      'Comentarios': comentarios,
      'Usuario_capturo_id': usuarioCapturoId,
      'Carrera_id': carreraId,
      'Periodo_id': periodoId,
      'Persona_id': personaId,
      'Resultados': Resultados,
      'Fecha_analisis': Fecha_analisis,
    };
  }
}
