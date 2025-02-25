import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../services/transaction_service.dart';
import '../../models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<TransactionModel> transactions = [];
  String selectedFilter = "Todos";

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    List<TransactionModel> savedTransactions =
        await TransactionService.getTransactions();
    setState(() {
      transactions = savedTransactions;
    });
  }

  // Filtrar transacciones
  List<TransactionModel> getFilteredTransactions() {
    if (selectedFilter == "Todos") return transactions;
    return transactions.where((tx) => tx.type == selectedFilter).toList();
  }

  // Exportar a PDF
  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Historial de Transacciones",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...transactions.map(
                (tx) => pw.Text(
                  "${tx.date} - ${tx.type}: \$${tx.amount.toStringAsFixed(2)}",
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionModel> filteredTransactions = getFilteredTransactions();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          "Historial de Transacciones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: _generatePDF,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtro de transacciones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Filtrar por: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                  items:
                      ["Todos", "Pago", "Recarga", "Transferencia"].map((
                        filter,
                      ) {
                        return DropdownMenuItem<String>(
                          value: filter,
                          child: Text(filter),
                        );
                      }).toList(),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Lista de transacciones
            Expanded(
              child:
                  filteredTransactions.isEmpty
                      ? Center(
                        child: Text(
                          "No hay transacciones registradas",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          TransactionModel tx = filteredTransactions[index];

                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _getTransactionIcon(tx.type),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.details,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "${_formatDate(tx.date)} - ${tx.type}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Text(
                                  "\$${tx.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        tx.type == "Recarga"
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // Obtener ícono según el tipo de transacción
  Widget _getTransactionIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case "Pago":
        icon = Icons.payment;
        color = Colors.redAccent;
        break;
      case "Recarga":
        icon = Icons.add_circle_outline;
        color = Colors.green;
        break;
      case "Transferencia":
        icon = Icons.swap_horiz;
        color = Colors.blue;
        break;
      default:
        icon = Icons.receipt;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color),
    );
  }

  // Formatear fecha en un formato más legible
  String _formatDate(String dateString) {
    try {
      DateTime date = DateFormat("dd/MM/yyyy").parse(dateString);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (e) {
      return dateString;
    }
  }
}
