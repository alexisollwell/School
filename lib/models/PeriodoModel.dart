class PeriodoModel {
  final String? clave;
  final String? nombre;
  final String? estatus;
  final String? startDate, endDate;
  final int id;

  PeriodoModel(
      {this.clave,
      this.nombre,
      this.estatus,
      this.endDate,
      this.startDate,
      required this.id});

  factory PeriodoModel.fromJson(Map<String, dynamic> json) {
    return PeriodoModel(
      clave: json['Clave'].toString(),
      nombre: json['Nombre'].toString(),
      estatus: json['Estatus'].toString(),
      startDate: json['Fecha_Inicio'].toString(),
      endDate: json['Fecha_Fin'].toString(),
      id: int.parse(json['id'].toString()),
    );
  }

  // Método para serializar el objeto MiModelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Clave': clave,
      'Nombre': nombre,
      'Estatus': estatus,
      'Fecha_Fin': endDate,
      'Fecha_Inicio': startDate,
    };
  }
}
