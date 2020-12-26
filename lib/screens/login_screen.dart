import 'package:eight/resources/constants.dart';
import 'package:eight/screens/home_screen.dart';
import 'package:eight/screens/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController contactController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  String phoneNumber;
  bool verify = false;
  String _verificationId;
  SharedPreferences prefs;

  Future<void> verifyPhone(phone) async {
    void verificationCompleted(AuthCredential phoneAuthCredential) {}

    void verificationFailed(error) {
      print(error);
    }

    void codeSent(String verificationId, [int code]) {
      setState(() {
        _verificationId = verificationId;
        verify = true;
      });
      print(code);
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      verificationId = verificationId;
      print(verificationId);
      print("Timeout");
    }

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  verifyOtp() async {
    String otp = otpController.text.trim();
    prefs = await SharedPreferences.getInstance();
    print(otp);
    PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: otp);
    prefs.setString("phone", contactController.text.trim());
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: kPrimaryPinkColor
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     colors: [
            //       Colors.orange[900],
            //       Colors.orange[800],
            //       Colors.orange[400]
            //     ]
            // )
            ),
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          verify ? "Verify OTP" : "SignUp",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            verify
                                ? Container(
                                    width: SizeConfig.screenWidth * 0.7,
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      cursorColor: Colors.black,
                                      controller: otpController,
                                      decoration: InputDecoration(
                                        hintText: "Enter OTP",
                                        hintStyle:
                                            TextStyle(color: Colors.black45),
                                        contentPadding: EdgeInsets.only(
                                            top:
                                                getProportionateScreenWidth(15),
                                            bottom: 8),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: SizeConfig.screenWidth * 0.7,
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      cursorColor: Colors.black,
                                      onSaved: (value) => phoneNumber = value,
                                      controller: contactController,
                                      decoration: InputDecoration(
                                        hintText: "Phone number",
                                        hintStyle:
                                            TextStyle(color: Colors.black45),
                                        contentPadding: EdgeInsets.only(
                                            top:
                                                getProportionateScreenWidth(15),
                                            bottom: 8),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                            verify
                                ? IconButton(
                                    onPressed: () {
                                      verifyOtp();
                                    },
                                    icon: Icon(Icons.forward),
                                    iconSize: 45,
                                    color: Colors.black,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      phoneNumber = "+91 " +
                                          contactController.text
                                              .toString()
                                              .trim();
                                      print(phoneNumber);
                                      verifyPhone(phoneNumber);
                                    },
                                    icon: Icon(Icons.forward),
                                    iconSize: 45,
                                    color: Colors.black,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: SizeConfig.screenWidth * 0.27,
                right: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/logo.jpeg",
                    height: SizeConfig.screenWidth * 0.3,
                    width: SizeConfig.screenWidth * 0.3,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
