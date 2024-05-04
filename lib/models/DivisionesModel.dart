class DivisionesModel {
  final String? clave;
  final String? nombre;
  final String? estatus;
  final int id;

  DivisionesModel({this.clave, this.nombre, this.estatus, required this.id});

  factory DivisionesModel.fromJson(Map<String, dynamic> json) {
    return DivisionesModel(
        clave: json['Clave'].toString(),
        nombre: json['Nombre'].toString(),
        estatus: json['Estatus'].toString(),
        id: int.parse(
          json['id'].toString(),
        ));
  }

  // Método para serializar el objeto MiModelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'Clave': clave,
      'Nombre': nombre,
      'Estatus': estatus,
      'id': estatus,
    };
  }
}
