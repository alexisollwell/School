class PersonaModel {
  final int id;
  final String? nombre;
  final String? apellido;
  final String? fechaNaC;
  final String? domicilio;
  final String? telefono;
  final String? correo;
  final String? edoCivil;
  final String? nacionalidad;
  final String? estatus;
  final int? campusId;
  late int? usuarioId;
  final int? tipo;

  PersonaModel(
      {required this.id,
      this.nombre,
      this.apellido,
      this.fechaNaC,
      this.domicilio,
      this.telefono,
      this.correo,
      this.edoCivil,
      this.nacionalidad,
      this.estatus,
      this.campusId,
      this.usuarioId,
      this.tipo});

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      id: int.parse(json['id'].toString()),
      nombre: json['Nombre'].toString(),
      apellido: json['Apellido'].toString(),
      fechaNaC: json['Fecha_nacimiento'].toString(),
      domicilio: json['Domicilio'].toString(),
      telefono: json['Telefono'].toString(),
      correo: json['Correo'].toString(),
      edoCivil: json['Estado_civil'].toString(),
      nacionalidad: json['Nacionalidad'].toString(),
      estatus: json['Estatus'].toString(),
      campusId: int.parse(json['campus_id'].toString()),
      usuarioId: int.parse(json['usuario_id'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Nombre': nombre,
      'Apellido': apellido,
      'Fecha_nacimiento': fechaNaC,
      'Domicilio': domicilio,
      'Telefono': telefono,
      'Correo': correo,
      'Estado_civil': edoCivil,
      'Nacionalidad': nacionalidad,
      'Estatus': estatus,
      'campus_id': campusId,
      'usuario_id': usuarioId,
    };
  }
}
