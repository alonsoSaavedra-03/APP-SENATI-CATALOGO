/// Modelo de usuario registrado en el sistema y serializable a JSON.
class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String password;
  final String fechaRegistro;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.password,
    required this.fechaRegistro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: (json['id'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      correo: (json['correo'] ?? '').toString(),
      password: (json['password'] ?? '').toString(),
      fechaRegistro:
          (json['fechaRegistro'] ?? DateTime.now().toIso8601String()).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'password': password,
      'fechaRegistro': fechaRegistro,
    };
  }

  Map<String, dynamic> toSesionJson(String fechaIngreso) {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'ultimoIngreso': fechaIngreso,
    };
  }
}
