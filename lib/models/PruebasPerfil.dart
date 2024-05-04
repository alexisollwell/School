class PruebasPerfil {
  late int perfil_id;
  late int prueba_id;
  late String? Descripcion;
  late String? Tiempo;

  PruebasPerfil(
      {required this.perfil_id,
      required this.prueba_id,
      this.Descripcion,
      this.Tiempo});

  factory PruebasPerfil.fromJson(Map<String, dynamic> json) {
    int pruebaId = 0;
    try {
      pruebaId = int.parse(json['prueba_id'].toString());
    } catch (ex) {
      pruebaId = int.parse(json['pruebas_id'].toString());
    }
    return PruebasPerfil(
      Tiempo: json['Tiempo'].toString(),
      Descripcion: json['Descripcion'].toString(),
      perfil_id: int.parse(json['perfil_id'].toString()),
      prueba_id: pruebaId,
    );
  }

  // Método para serializar el objeto MiModelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'perfil_id': perfil_id,
      'prueba_id': prueba_id,
      'Descripcion': Descripcion,
      'Tiempo': Tiempo,
    };
  }
}
