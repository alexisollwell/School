class ResultadoPrueba {
  final int solicitudId;
  final int pruebaId;
  final int agrupador;
  final String descripcion;
  final String puntos;

  ResultadoPrueba({
    required this.solicitudId,
    required this.pruebaId,
    required this.agrupador,
    required this.descripcion,
    required this.puntos,
  });

  factory ResultadoPrueba.fromJson(Map<String, dynamic> json) {
    return ResultadoPrueba(
      solicitudId: json['solicitud_id'],
      pruebaId: json['prueba_id'],
      agrupador: json['agrupador'],
      descripcion: json['descripcion'],
      puntos: json['Puntos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'solicitud_id': solicitudId,
      'prueba_id': pruebaId,
      'agrupador': agrupador,
      'descripcion': descripcion,
      'Puntos': puntos,
    };
  }
}
