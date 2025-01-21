import 'package:flutter/material.dart';
import '../modelo/usuarios_modelo.dart';
import 'agregar_monto_vista.dart';
import 'retirar_monto_vista.dart';
import 'calculo_intereses_vista.dart';
import '../tema/estilo.dart';

class HomeVista extends StatefulWidget {
  final UsuarioModelo usuario;

  HomeVista({required this.usuario});

  @override
  _HomeVistaState createState() => _HomeVistaState();
}

class _HomeVistaState extends State<HomeVista> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    "Banco EspeBandidos Corp",
    "Billetera",
    "Agregar Monto",
    "Retirar Monto",
    "Cálculo de Intereses",
  ];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildInicio(),
      _buildBilletera(),
      AgregarMontoVista(
        usuario: widget.usuario,
        actualizarSaldo: _actualizarSaldo,
      ),
      RetirarMontoVista(
        usuario: widget.usuario,
        actualizarSaldo: _actualizarSaldo,
      ),
      CalculoInteresesVista(usuario: widget.usuario),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: Estilo.tituloAppBar),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Estilo.verdeClaro, Estilo.verdePrimario],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: IndexedStack(
          key: ValueKey<int>(_selectedIndex),
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Estilo.verdePrimario,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        items: [
          _buildBarItem(Icons.home, "Inicio"),
          _buildBarItem(Icons.account_balance_wallet, "Billetera"),
          _buildBarItem(Icons.add_circle, "Agregar"),
          _buildBarItem(Icons.remove_circle, "Retirar"),
          _buildBarItem(Icons.percent, "Intereses"),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _selectedIndex == _titles.indexOf(label)
              ? Estilo.verdeClaro
              : Colors.transparent,
        ),
        padding: EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  Widget _buildInicio() {
    return Center(
      child: Text(
        "Bienvenido a EspeBandidos Corp",
        style: Estilo.tituloPantalla,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBilletera() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Usuario: ${widget.usuario.nombre}",
              style: Estilo.tituloPantalla,
            ),
            SizedBox(height: 10),
            Text(
              "Balance Total: \$${widget.usuario.saldo.toStringAsFixed(2)}",
              style: Estilo.textoSaldo,
            ),
          ],
        ),
      ),
    );
  }

  void _actualizarSaldo(double nuevoSaldo) {
    setState(() {
      widget.usuario.saldo = nuevoSaldo;
    });
  }
}
