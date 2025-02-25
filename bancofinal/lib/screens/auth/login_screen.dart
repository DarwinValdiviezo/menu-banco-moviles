import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  String errorMessage = '';

  void login() {
    if (emailController.text == "darwin.valdiviezo@gmail.com" &&
        passwordController.text == "darwin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        errorMessage = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo y título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  Icon(Icons.account_balance, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Banca Digital",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Tu dinero, tu control",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            // Tarjeta blanca con el formulario de inicio de sesión
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Campo de usuario
                  Text(
                    "Usuario",
                    style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 5),
                  _buildTextField(
                    emailController,
                    "Usuario",
                    Icons.person,
                    false,
                  ),
                  SizedBox(height: 15),
                  // Campo de contraseña
                  Text(
                    "Contraseña",
                    style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 5),
                  _buildTextField(
                    passwordController,
                    "Contraseña",
                    Icons.lock,
                    true,
                  ),
                  SizedBox(height: 10),
                  if (errorMessage.isNotEmpty)
                    Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  SizedBox(height: 20),
                  // Botón de inicio de sesión
                  Center(
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 40,
                        ),
                      ),
                      child: Text(
                        "INGRESAR",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Opción de recuperación de contraseña
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir campos de texto
  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscurePassword : false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
                : null,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
