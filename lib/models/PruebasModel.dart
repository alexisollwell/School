class PruebasModel {
  int id;
  int? pruebaSolicitudId;
  final String? nombre;
  final String? descripcion;
  final String? tiempo;
  late String? estatus;
  final String? Instruccion;
  final int? minutos;

  PruebasModel(
      {required this.id,
      this.descripcion,
      this.nombre,
      this.tiempo,
      this.pruebaSolicitudId,
      this.estatus,
      this.Instruccion,
      this.minutos});

  factory PruebasModel.fromJson(Map<String, dynamic> json) {
    return PruebasModel(
      id: int.parse(json['id'].toString()),
      nombre: json['Nombre'].toString(),
      descripcion: json['Descripcion'].toString(),
      tiempo: json['Tiempo'].toString(),
      estatus: json['Estatus'].toString(),
      Instruccion: json['Instruccion'] ?? "",
      minutos: int.parse(json['Minutos'].toString()),
    );
  }

  // Método para serializar el objeto MiModelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Nombre': nombre,
      'Estatus': estatus,
      'Descripcion': descripcion,
      'Instruccion': Instruccion,
      'Tiempo': tiempo,
      'Minutos': minutos,
    };
  }
}
