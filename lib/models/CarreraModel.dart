class CarreraModel {
  final String? clave;
  final String? nombre;
  final String? estatus;
  final int id;
  final int? id_division_fk;
  final int? modalidad;
  final int? tipo;

  CarreraModel(
      {this.clave,
      this.nombre,
      this.estatus,
      required this.id,
      this.id_division_fk,
      this.modalidad,
      this.tipo});

  factory CarreraModel.fromJson(Map<String, dynamic> json) {
    return CarreraModel(
      clave: json['Clave'].toString(),
      nombre: json['Nombre'].toString(),
      estatus: json['Estatus'].toString(),
      id: int.parse(
        json['id'].toString(),
      ),
      modalidad: int.parse(json['Modalidad'].toString()),
      tipo: int.parse(json['Tipo'].toString()),
      id_division_fk: int.parse(json['id_division_fk'].toString()),
    );
  }

  // Método para serializar el objeto MiModelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'Tipo': tipo,
      'id': id,
      'Nombre': nombre,
      'Clave': clave,
      'Estatus': estatus,
      'id_division_fk': id_division_fk,
      'Modalidad': modalidad,
    };
  }
}
