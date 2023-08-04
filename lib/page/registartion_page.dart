import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:live_stock_tracking/page/page.dart';
import 'package:live_stock_tracking/page/widgets/theme.dart';

import 'notifaction/notifactions.dart';



class RegistrationPage extends StatefulWidget {
  final void Function() onTap;
  const RegistrationPage({super.key, required this.onTap});
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  //controller
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _firestnamecontroller = TextEditingController();
  final _lastnamedcontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();

  dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _lastnamedcontroller.dispose();
    _phonecontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  // Future registaretion() async {
  //   if (checkPasswordComfirm()) {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _emailcontroller.text.trim(),
  //         password: _passwordcontroller.text.trim());

  //     //details
  //     adduser(
  //         _firestnamecontroller.text.trim(),
  //         _lastnamedcontroller.text.trim(),
  //         _emailcontroller.text.trim(),
  //         int.parse(_phonecontroller.text.trim()),
  //         _passwordcontroller.text.trim(),
  //         _confirmpasswordcontroller.text.trim());
  //   }
  // }

  // bool checkPasswordComfirm() {
  //   if (_passwordcontroller.text.trim() == "" ||
  //       _confirmpasswordcontroller.text.trim() == "") {
  //     return true;
  //     // ScaffoldMessenger.of(context)
  //     //     .showSnackBar(SnackBar(content: Text("all requiref feild")));
  //   } else
  //     return false;
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailcontroller.text.trim(),
        password: _passwordcontroller.text.trim(),
      );

      // Handle successful registration
      // Navigate to the homepage
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    } catch (e) {
      // Handle registration error
      print("Registration error: $e");
    }
  }

  // Future adduser(String firestname, String lastname, String email, int phone,
  //     String pass, String confirmpasswrd) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'firstname': firestname,
  //     'lastaname': lastname,
  //     'email': email,
  //     'phone': phone,
  //     'password': pass,
  //     'confirm password': confirmpasswrd,
  //   }).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.green,
  //         content: const Text(
  //           'Succssfull Registration ',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         duration: const Duration(seconds: 3),
  //         action: SnackBarAction(
  //           label: 'Registration',
  //           onPressed: () {},
  //         ),
  //       )));
  //   child:
  //   const Text('SHOW SNACK');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Container(
            //   height: 150,
            //   child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            // ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _emailcontroller,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),

                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _passwordcontroller,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //
                        SizedBox(height: 15.0),
                        // FormField<bool>(
                        //   builder: (state) {
                        //     return Column(
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             Checkbox(
                        //                 value: checkboxValue,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     checkboxValue = value!;
                        //                     state.didChange(value);
                        //                   });
                        //                 }),
                        //             Text(
                        //               "I accept all terms and conditions.",
                        //               style: TextStyle(color: Colors.grey),
                        //             ),
                        //           ],
                        //         ),
                        //         Container(
                        //           alignment: Alignment.centerLeft,
                        //           child: Text(
                        //             state.errorText ?? '',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(
                        //               color: Theme.of(context).errorColor,
                        //               fontSize: 12,
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     );
                        //   },
                        //   validator: (value) {
                        //     if (!checkboxValue) {
                        //       return 'You need to accept terms and conditions';
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: GestureDetector(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Register".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 244, 246, 247),
                                  ),
                                ),
                              ),
                              onTap: registerWithEmailAndPassword

                              // if (_formKey.currentState!.validate()) {
                              //   Navigator.of(context).pushAndRemoveUntil(
                              //       MaterialPageRoute(
                              //           builder: (context) => LoginPage()),
                              //       (Route<dynamic> route) => false);

                              ),
                        ),
                        SizedBox(height: 30.0),
                        TextButton(
                          onPressed: (() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => LoginPage())));
                          }),
                          child: Text(
                            "Or Go Back",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.googlePlus,
                                size: 35,
                                color: Color(0xffEC2D2F),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Google Plus",
                                          "You tap on GooglePlus social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: Color(0xff40ABF0)),
                                  color: Color(0xff40ABF0),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.twitter,
                                  size: 23,
                                  color: Color(0xffFFFFFF),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Twitter",
                                          "You tap on Twitter social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 35,
                                color: Color(0xff3E529C),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Facebook",
                                          "You tap on Facebook social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
