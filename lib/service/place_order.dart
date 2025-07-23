import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PlaceOrderPage extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const PlaceOrderPage({super.key, required this.orderData});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generatePDF() async {
    final pdf = pw.Document();
    final order = widget.orderData;

    final time = (order['timestamp'] is DateTime)
        ? order['timestamp']
        : order['timestamp'].toDate();

    final formattedTotal = NumberFormat.currency(locale: 'en_IN', symbol: '₹')
        .format(int.tryParse(order['Total'].toString()) ?? 0);

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'Order Summary',
                style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey, width: 1),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              padding: const pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _pdfRow("Order ID:", order['OrderId']),
                  _pdfRow("Food:", order['FoodName']),
                  _pdfRow("Quantity:", order['quantity'].toString()),
                  _pdfRow("Total:", formattedTotal),
                  _pdfRow("Status:", order['Status'] == "pending" ? "Delivered" : order['Status']),
                  _pdfRow("Date:", DateFormat.yMMMd().add_jm().format(time)),
                  pw.SizedBox(height: 10),
                  pw.Text("Delivery Address:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text(order['Address'], style: pw.TextStyle(fontSize: 16)),
                ],
              ),
            ),
            pw.Spacer(),
            pw.Center(
              child: pw.Text(
                "Thank you for ordering with us!",
                style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 5),
          pw.Expanded(child: pw.Text(value, style: pw.TextStyle(fontSize: 18))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.orderData;

    final DateTime time = (order['timestamp'] is DateTime)
        ? order['timestamp']
        : order['timestamp'].toDate();

    final formattedTotal = NumberFormat.currency(locale: 'en_IN', symbol: '₹')
        .format(int.tryParse(order['Total'].toString()) ?? 0);

    return Scaffold(
      appBar: AppBar(title: const Text("Order Confirmation")),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🎉 Thank you for your order!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade100, Colors.orange.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Order ID:", order['OrderId'], icon: Icons.receipt_long),
                        _infoRow("Food:", order['FoodName'], icon: Icons.fastfood),
                        _infoRow("Quantity:", order['quantity'].toString(), icon: Icons.confirmation_number),
                        _infoRow("Total:", formattedTotal, icon: Icons.currency_rupee),
                        _infoRow("Status:", order['Status'] == "pending" ? "Delivered" : order['Status'], icon: Icons.local_shipping),
                        _infoRow("Date:", DateFormat.yMMMd().add_jm().format(time), icon: Icons.date_range),
                        const SizedBox(height: 20),
                        const Center(child: Text("QR Code for Order ID", style: TextStyle(fontWeight: FontWeight.bold))),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final qrSize = constraints.maxWidth < 300 ? 100.0 : 120.0;
                            return Center(
                              child: QrImageView(
                                data: order['OrderId'],
                                size: qrSize,
                                backgroundColor: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Delivery Address:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(order['Address']),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffef2b39),
                        ),
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        icon: const Icon(Icons.home),
                        label: const Text("Back to Home"),
                      ),
                      OutlinedButton.icon(
                        onPressed: _generatePDF,
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Download PDF"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 5,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
