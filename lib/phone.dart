import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'otp.dart';

class Phone extends StatefulWidget {
  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  String CountryCodeDigits = "+00";
  TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'OTP Verification',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
                'We will send you a One Time Password\n to your mobile number'),
            SizedBox(height: 30.0),
            Text('Enter Mobile Number'),
            Container(
              child: CountryCodePicker(
                onChanged: (country) {
                  setState(() {
                    CountryCodeDigits = country.dialCode!;
                  });
                },
                dialogBackgroundColor: Colors.purple[50],
                backgroundColor: Colors.purple[50],
                showDropDownButton: true,
                initialSelection: "IT",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: true,
              ),
            ),
            TextFormField(
              maxLength: 11,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Colors.purple)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Colors.purple)),
              ),
              keyboardType: TextInputType.number,
              controller: _numberController,
            ),
            FlatButton(
              height: 50.0,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => OtpVerification(
                          phone: _numberController.text,
                          codeDigit: CountryCodeDigits,
                        )));
              },
              textColor: Colors.white,
              color: Colors.purpleAccent,
              child: Text(
                'Send OTP',
              ),
            )
          ],
        ),
      ),
    );
  }
}
