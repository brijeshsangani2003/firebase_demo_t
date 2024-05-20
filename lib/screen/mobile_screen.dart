import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_t/screen/otp_screen.dart';
import 'package:flutter/material.dart';

import '../common_widget/common_textfield.dart';

String? verificationCode;

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  TextEditingController mobileNo = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? countryCode;

  Future sendOtp() async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${countryCode ?? "+91"} ${mobileNo.text}',
      verificationCompleted: (phoneAuthCredential) {
        print('Done');
      },
      verificationFailed: (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message.toString())));
      },
      codeSent: (verificationId, forceResendingToken) {
        verificationCode = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print('Expired');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Mobile Screen',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                const SizedBox(height: 30),
                common_text_field(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Mobile no can not be empty';
                      } else if (value.length != 10) {
                        return 'Mobile no must be 10 digit';
                      }
                    },
                    hinttext: 'Mobile No:-',
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: mobileNo,
                    counterText: '',
                    prefixIcon: CountryCodePicker(
                      onChanged: (value) {
                        setState(() {
                          countryCode = value.dialCode;
                        });
                      },
                      initialSelection: 'IN',
                      favorite: ['+91', 'IN'], //top pr ave aa
                      showCountryOnly:
                          false, //દેશના કોડ વગર માત્ર દેશનું નામ જ બતાવવું કે નહીં.
                      showOnlyCountryWhenClosed:
                          false, //જ્યારે પીકર બંધ હોય ત્યારે માત્ર દેશનું નામ બતાવવું કે નહીં.
                      alignLeft: false,
                    )),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      sendOtp().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OtpScreen(),
                          )));
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Text(
                        'Send Otp',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
