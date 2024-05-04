class SolicitudPrueba {
  int id;
  String fechaAplicacion;
  String estatus;
  String comentarios;
  int solicitudId;
  int pruebasId;
  int periodoId;
  int personaId;

  SolicitudPrueba({
    required this.id,
    required this.fechaAplicacion,
    required this.estatus,
    required this.comentarios,
    required this.solicitudId,
    required this.pruebasId,
    required this.periodoId,
    required this.personaId,
  });

  factory SolicitudPrueba.fromJson(Map<String, dynamic> json) {
    return SolicitudPrueba(
      id: int.parse(json['id'].toString()),
      fechaAplicacion: json['Fecha_aplicacion'],
      estatus: json['Estatus'].toString(),
      comentarios: json['Comentarios'] ?? "",
      solicitudId: json['solicitud_id'],
      pruebasId: json['pruebas_id'] ?? 0,
      periodoId: json['Periodo_id'] ?? 0,
      personaId: json['Persona_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Fecha_aplicacion': fechaAplicacion,
      'Estatus': estatus,
      'Comentarios': comentarios,
      'solicitud_id': solicitudId,
      'pruebas_id': pruebasId,
      'Periodo_id': periodoId,
      'Persona_id': personaId,
    };
  }
}
