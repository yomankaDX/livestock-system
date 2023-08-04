import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_stock_tracking/page/forgetpassword.dart';
import 'package:live_stock_tracking/page/registartion_page.dart';
import 'package:live_stock_tracking/page/widgets/tetxfield.dart';
import 'package:shared_preferences/shared_preferences.dart';



import 'notifaction/notifactions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _PageState();
}

class _PageState extends State<LoginPage> {
  // final _formKey = GlobalKey<FormState>();

  //controller
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  String _emailError = '';
  String _passwordError = '';

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(_validateEmail);
    _passwordFocus.addListener(_validatePassword);
  }

  void _validateEmail() {
    if (!_emailFocus.hasFocus) {
      _validateField(_emailcontroller.text, 'email');
    }
  }

  void _validatePassword() {
    if (!_passwordFocus.hasFocus) {
      _validateField(_passwordcontroller.text, 'password');
    }
  }
void _loginPressed() {
  // Clear previous error messages
  setState(() {
    _emailError = '';
    _passwordError = '';
  });

  // Perform the login logic here
  String email = _emailcontroller.text.trim();
  String password = _passwordcontroller.text;

  // Validate the fields again before logging in
  bool emailValid = _validateField(email, 'email');
  bool passwordValid = _validateField(password, 'password');

  // Check if both email and password are valid
  if (emailValid && passwordValid) {
    // Perform the login using Firebase Authentication or any other login logic
    _performLogin(email, password);
  }
}

bool _validateField(String value, String fieldName) {
  bool isValid = true;

  if (fieldName == 'email') {
    if (value.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
      isValid = false;
    }
  } else if (fieldName == 'password') {
    if (value.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
      isValid = false;
    }
  }

  return isValid;
}

  void _performLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );


 SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );

      // Login successful, you can navigate to the home screen or perform other actions.
      print('Login successful: ${userCredential.user?.email}');
    } catch (e) {
      // Handle login errors (e.g., wrong credentials, network issues).
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          setState(() {
            _emailError = 'No user found with this email';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _passwordError = 'Incorrect password';
          });
        } else {
          // Other FirebaseAuthException errors can be handled here
          print('Error: ${e.message}');
        }
      } else {
        // Handle other exceptions that may occur during the login process
        print('Error: $e');
      }
    }
  }













  @override
  Widget build(BuildContext context) {
    double W = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            Icon(
              Icons.message,
              size: 130,
              color: Colors.blue,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(),
            ),
            Container(
              width: W,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hello ",
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Sing Into Your Account ",
                      style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    // Container(
                    //   decoration: BoxDecoration(boxShadow: [
                    //     BoxShadow(
                    //         blurRadius: 8,
                    //         offset: Offset(
                    //           1,
                    //           1,
                    //         ),
                    //         color: Colors.white10),
                    //   ]),
                    //   child: Container(
                    //       child: Mytextfield(
                    //         //  focusNode: _emailFocus,
                    //     controller: _emailcontroller,
                    //     hinttext: "email",
                    //     obsecure: false,
                    //   )

                    //       ),
                    // ),
                     Container(
                      child: TextFormField(
       focusNode: _emailFocus,

                        
                   
                        controller: _emailcontroller,
                        decoration: InputDecoration(
                            errorText: _emailError.isNotEmpty ? _emailError : null,

                            enabledBorder: OutlineInputBorder(
                              
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: ('Email * '),
                         labelText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[500])),

                     
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      child: TextFormField(

                               focusNode: _passwordFocus ,
                        
                        obscureText: true,
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                       labelText: 'Password', // Use either labelText or label, not both.
    errorText: _passwordError.isNotEmpty ? _passwordError : null,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: ('password * '),
                        
                            hintStyle: TextStyle(color: Colors.grey[500])),

                     
                      ),
                    ),

                   

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text("Forget your  Password ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.red)),
                          onPressed: (() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Forgetpassword()),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Container(
                        child: GestureDetector(
                          onTap:  _loginPressed,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(left: 50, right: 50),
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don\'t have an account?",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: (() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => RegistrationPage(
                          onTap: () {},
                        ),
                      ),
                    );
                  }),
                  child: Text("Registration",
                      style: TextStyle(fontSize: 20, color: Colors.purple)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
