import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Import the razorpay_flutter package

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PaymentScreen({super.key, required this.bookingData});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _firestore = FirebaseFirestore.instance;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Add the booking data to the Firestore database
    _firestore.collection('turfBookings').add(widget.bookingData).then((value) {
      print('Turf booking added: ${value.id}');
      // Show a success message or navigate to a success screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful!'),
        ),
      );
    }).catchError((error) {
      print('Failed to add turf booking: $error');
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Show an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment error: ${response.code} - ${response.message}'),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payments
  }

  void _openRazorpayPayment() {
    var options = {
      'key': 'YOUR_RAZOR_PAY_KEY', // Replace with your Razorpay key
      'amount': 100, // Amount in paise, e.g., 100 = ₹1
      'name': 'Turf Booking',
      'description': 'Turf Booking Payment',
      'prefill': {
        'contact': widget.bookingData['contact'],
        'email': 'example@example.com', // Replace with a valid email
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _openRazorpayPayment,
          child: const Text('Pay with Razorpay'),
        ),
      ),
    );
  }
}