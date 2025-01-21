class UsuarioModelo {
  final String nombre;
  final String contrasena;
  double saldo;

  UsuarioModelo({
    required this.nombre,
    required this.contrasena,
    this.saldo = 0.0,
  });
}
