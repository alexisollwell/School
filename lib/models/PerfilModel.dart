class PerfilModel {
  final int id;
  final String? descripcion;
  final String? nombre;
  final String? estatus;

  PerfilModel({this.descripcion, this.nombre, this.estatus, required this.id});

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    return PerfilModel(
      descripcion: json['Descripcion'].toString(),
      nombre: json['Nombre'].toString(),
      estatus: json['Estatus'].toString(),
      id: int.parse(json['id'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Descripcion': descripcion,
      'Nombre': nombre,
      'Estatus': estatus,
      'id': id,
    };
  }
}
