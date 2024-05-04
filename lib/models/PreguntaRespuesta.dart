class PreguntaRespuesta {
  Pregunta pregunta;
  List<Respuesta> respuestas;

  PreguntaRespuesta({
    required this.pregunta,
    required this.respuestas,
  });

  factory PreguntaRespuesta.fromJson(Map<String, dynamic> json) {
    return PreguntaRespuesta(
      pregunta: Pregunta.fromJson(json['pregunta']),
      respuestas: List<Respuesta>.from(json['respuestas'].map((x) => Respuesta.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    'pregunta': pregunta.toJson(),
    'respuestas': List<dynamic>.from(respuestas.map((x) => x.toJson())),
  };
}

class Pregunta {
  int id;
  String pregunta;
  int orden;
  int valor;
  int agrupador;
  int pruebasId;
  int grupoRespuestaId;
  int estatus;

  Pregunta({
    required this.id,
    required this.pregunta,
    required this.orden,
    required this.valor,
    required this.agrupador,
    required this.pruebasId,
    required this.grupoRespuestaId,
    required this.estatus,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
    id: json['id'],
    pregunta: json['pregunta'],
    orden: json['orden'],
    valor: json['valor'],
    agrupador: json['agrupador'],
    pruebasId: json['pruebas_id'],
    grupoRespuestaId: json['grupo_respuesta_id'],
    estatus: json['Estatus'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'pregunta': pregunta,
    'orden': orden,
    'valor': valor,
    'agrupador': agrupador,
    'pruebas_id': pruebasId,
    'grupo_respuesta_id': grupoRespuestaId,
    'Estatus': estatus,
  };
}

class Respuesta {
  int id;
  String respuesta;
  int orden;
  int valor;
  int grupoId;
  int estatus;

  Respuesta({
    required this.id,
    required this.respuesta,
    required this.orden,
    required this.valor,
    required this.grupoId,
    required this.estatus,
  });

  factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
    id: json['id'],
    respuesta: json['respuesta'],
    orden: json['orden'],
    valor: json['valor'],
    grupoId: json['grupo_id'],
    estatus: json['Estatus'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'respuesta': respuesta,
    'orden': orden,
    'valor': valor,
    'grupo_id': grupoId,
    'Estatus': estatus,
  };
}
