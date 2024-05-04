class RespuestaTest {
  int solicitudId;
  int preguntaId;
  int respuestaId;
  int pruebaId;
  int punto;

  RespuestaTest({
    required this.solicitudId,
    required this.preguntaId,
    required this.respuestaId,
    required this.pruebaId,
    required this.punto,
  });

  factory RespuestaTest.fromJson(Map<String, dynamic> json) {
    return RespuestaTest(
      solicitudId: json['solicitud_id'],
      preguntaId: json['pregunta_id'],
      respuestaId: json['respuesta_id'],
      pruebaId: json['prueba_id'],
      punto: json['punto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'solicitud_id': solicitudId,
      'pregunta_id': preguntaId,
      'respuesta_id': respuestaId,
      'prueba_id': pruebaId,
      'punto': punto,
    };
  }
}
