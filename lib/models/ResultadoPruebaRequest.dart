class ResultadoPruebaRequest {
  final int solicitudId;
  final int pruebaId;

  ResultadoPruebaRequest({
    required this.solicitudId,
    required this.pruebaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'solicitud_id': solicitudId,
      'prueba_id': pruebaId,
    };
  }
}
