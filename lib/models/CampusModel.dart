class CampusModel {
  final int id;
  final String? nombre;
  final String? estatus;

  CampusModel({
    this.nombre, 
    this.estatus, 
    required this.id
  });

  factory CampusModel.fromJson(Map<String, dynamic> json) {
    return CampusModel(
      nombre: json['Nombre'].toString(),
      estatus: json['Estatus'].toString(),
      id: int.parse(json['id'].toString()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'Nombre': nombre,
      'Estatus': estatus,
      'id': id,
    };
  }
}