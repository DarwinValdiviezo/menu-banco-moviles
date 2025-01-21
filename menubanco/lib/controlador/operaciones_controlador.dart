class OperacionesControlador {
  double agregarMonto(double saldoActual, double monto) {
    if (monto <= 0) throw Exception("El monto debe ser mayor a 0.");
    if (monto > 10000)
      throw Exception("No se puede ingresar más de \$10,000 por día.");
    return saldoActual + monto;
  }

  double retirarMonto(double saldoActual, double monto) {
    if (monto <= 0) throw Exception("El monto debe ser mayor a 0.");
    if (monto > saldoActual) throw Exception("Saldo insuficiente.");
    return saldoActual - monto;
  }

  double calcularInteres(double saldoActual, double tasaInteres) {
    if (tasaInteres <= 0) throw Exception("La tasa debe ser mayor a 0.");
    return saldoActual * (tasaInteres / 100);
  }
}
