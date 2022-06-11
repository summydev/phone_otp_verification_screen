import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatefulWidget {
  final String phone;
  final String codeDigit;
  OtpVerification({required this.codeDigit, required this.phone});
  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  String? verificationCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhone();
  }

  verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${widget.codeDigit + widget.phone}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => HomeScreen()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ));
        },
        codeSent: (String vID, int? resendToken) {
          setState(() {
            verificationCode = vID;
          });
        },
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            verificationCode = vID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Text('code has been sent to',
                      style: TextStyle(color: Colors.purple)),
                  Text(
                    "${widget.codeDigit}${widget.phone}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Pinput(
                  length: 6,
                  pinAnimationType: PinAnimationType.slide,
                  controller: _pinOTPCodeController,
                  onSubmitted: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationCode!, smsCode: pin))
                          .then((value) {
                        if (value.user != null) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (c) => HomeScreen()));
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid Otp'),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  }),
              SizedBox(height: 15),
              Column(
                children: [
                  Text('Haven\' t received any verificaton code?'),
                  GestureDetector(
                      onTap: () {
                        verifyPhone();
                      },
                      child:
                          Text('Resend', style: TextStyle(color: Colors.red))),
                ],
              ),
              SizedBox(height: 25),
            ]),
      ),
    );
  }
}
