class updatePruebaModelo {
  int id;
  String fechaInicio;
  String fechaTermino;
  int estatus;

  updatePruebaModelo({
    required this.id,
    required this.fechaInicio,
    required this.fechaTermino,
    required this.estatus,
  });

  // Método para deserializar el JSON a un objeto de Evento
  factory updatePruebaModelo.fromJson(Map<String, dynamic> json) {
    return updatePruebaModelo(
      id: int.parse(json['id']),
      fechaInicio: json['Fecha_inicio'],
      fechaTermino: json['Fecha_termino'],
      estatus: json['Estatus'],
    );
  }

  // Método para serializar el objeto de Evento a JSON
  Map<String, dynamic> toJson() {
    return {
      'Fecha_inicio': fechaInicio,
      'Fecha_termino': fechaTermino,
      'Estatus': estatus,
    };
  }
}
