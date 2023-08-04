import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_stock_tracking/page/forgetpassword.dart';
import 'package:live_stock_tracking/page/registartion_page.dart';
import 'package:live_stock_tracking/page/widgets/tetxfield.dart';



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

  void Passwrong() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(title: Center(child: Text((" incorrect"))));
        });
  }

  void Emailrong() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
              title: Center(child: Text(("  Emailrong incorrect"))));
        });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailcontroller.text.trim(),
        password: _passwordcontroller.text.trim(),
      );

      // Handle successful sign-in
      // Navigate to the homepage
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    } catch (e) {
      // Handle sign-in error
      print("Sign-in error: $e");
    }
  }

  dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
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
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            offset: Offset(
                              1,
                              1,
                            ),
                            color: Colors.white10),
                      ]),
                      child: Container(
                          child: Mytextfield(
                        controller: _emailcontroller,
                        hinttext: "email",
                        obsecure: false,
                      )

                          // TextFormField(
                          //   controller: _emailcontroller,
                          //   decoration: InputDecoration(
                          //       enabledBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(40),
                          //         borderSide: BorderSide(color: Colors.white),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide:
                          //             BorderSide(color: Colors.grey.shade400),
                          //         borderRadius: BorderRadius.circular(40),
                          //       ),
                          //       fillColor: Colors.white,
                          //       filled: true,
                          //       hintText: ('UserName '),
                          //       label: Text('Enter your Username'),
                          //       hintStyle: TextStyle(color: Colors.grey[500])),

                          //   ThemeHelper().textInputDecoration(
                          //       'UserName', 'Enter your first name'),
                          //   keyboardType: TextInputType.emailAddress,
                          //   validator: (val) {
                          //     if (!(val!.isEmpty) &&
                          //         !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                          //             .hasMatch(val)) {
                          //       return "Enter a valid email address";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
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
                            label: Text('Enter your password'),
                            hintStyle: TextStyle(color: Colors.grey[500])),

                        //   ThemeHelper().textInputDecoration(
                        //       'UserName', 'Enter your first name'),
                        //   keyboardType: TextInputType.emailAddress,
                        //   validator: (val) {
                        //     if (!(val!.isEmpty) &&
                        //         !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                        //             .hasMatch(val)) {
                        //       return "Enter a valid email address";
                        //     }
                        //     return null;
                        //   },
                      ),
                    ),

                    // child: TextFormField(
                    //   controller: _passwordcontroller,
                    //   obscureText: true,
                    //   decoration: ThemeHelper().textInputDecoration(
                    //       "PassWord*", "Enter your password"),
                    //   validator: (val) {
                    //     if (val!.isEmpty) {
                    //       return "Please enter your password";
                    //     }
                    //     return null;

                    // decoration: ThemeHelper().inputBoxDecorationShaddow(),

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
                          onTap: signInWithEmailAndPassword,
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
