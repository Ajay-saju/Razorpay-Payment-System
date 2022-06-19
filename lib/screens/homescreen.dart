import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:razorpayintegration/core/colors.dart';
import 'package:razorpayintegration/core/size.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? amount;
  String? name;
  String? email;
  String? mobileNumber;
  String? description;

  final _razorpay = Razorpay();
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

 

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_DWWTTXLxY806V8',
      'amount': num.parse(amount.toString())*100,
      'name': name,
      'description': description,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': mobileNumber, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Hemmmeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee :$e');
      // print(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // print('Payment success');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Success')));
    
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    // print('error');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Error')));

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    // print('Externel wallet');
  }
   @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 70, 45, 74),
        elevation: 20,
        title: Text(
          'Razorpay Payment System',
          style: GoogleFonts.outfit(
              textStyle: const TextStyle(
                  fontSize: 18, color: cwhite, fontWeight: FontWeight.bold)),
        ),
        titleSpacing: 1,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              h50,
              Padding(
                padding:const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    CustomeTextFormField(
                      hintText: 'Name',
                      iconSymbol: '👤',
                      textInputType: TextInputType.name,
                      textInput: 1,
                      onChanged: (String value) {
                        name = value;
                      },
                    ),
                    h25,
                    CustomeTextFormField(
                      hintText: 'Mobile Number',
                      iconSymbol: '☏',
                      textInputType: TextInputType.phone,
                      textInput: 2,
                      onChanged: (String value) {
                        mobileNumber = value;
                      },
                    ),
                    h25,
                    CustomeTextFormField(
                      hintText: 'Email',
                      iconSymbol: '📧',
                      textInputType: TextInputType.emailAddress,
                      textInput: 3,
                      onChanged: (String value) {
                        email = value;
                      },
                    ),
                    h25,
                    CustomeTextFormField(
                        hintText: 'Add a note',
                        iconSymbol: '🗒️',
                        textInputType: TextInputType.text,
                        textInput: 5,
                        onChanged: (String value) {
                          description = value;
                        }),
                    h25,
                    CustomeTextFormField(
                      iconSymbol: '₹',
                      hintText: 'Enter Amount to pay',
                      textInputType: TextInputType.number,
                      textInput: 4,
                      onChanged: (value) {
                        double parsedValue = double.parse(value);
                        amount = parsedValue;
                      },
                    ),
                    h25,
                  ],
                ),
              ),
              h50,
              ElevatedButton(
                onPressed: () {
                  // print("hemmmmmmeeeeeeeeeeeeeeeeeeeeeeeeee : ${HomeScreen.amount}");
                  if (amount != null &&
                      name != null &&
                      email != null &&
                      mobileNumber != null) {
                    openCheckout();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('All fields are required')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 15.0,
                ),
                child: Text(
                  'Pay Now',
                  style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          color: cblack,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class CustomeTextFormField extends StatelessWidget {
  final String hintText;
  final String iconSymbol;
  final int textInput;
  final TextInputType textInputType;
  final Function(String)? onChanged;

const  CustomeTextFormField({
    Key? key,
    required this.hintText,
    required this.iconSymbol,
    required this.textInputType,
    required this.textInput,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      keyboardType: textInputType,
      style: TextStyle(
          color: cblack,
          fontSize: hintText == 'Enter Amount to pay' ? 30 : 20,
          fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        enabledBorder:const OutlineInputBorder(
                              borderSide: BorderSide(color: cblack, width: 0.5)),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          prefix: Text(
            '$iconSymbol ',
            style: TextStyle(
                color: Colors.black54,
                fontSize: hintText == 'Enter Amount to pay' ? 30 : 20,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}
