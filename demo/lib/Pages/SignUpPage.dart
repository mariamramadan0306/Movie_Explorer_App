import 'package:demo/Pages/SingInPage.dart';
import 'package:demo/utils/show_message.dart';
import 'package:demo/utils/sign_in_up_inputDecoration.dart';
import 'package:demo/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool obscurePassword = true;
  bool confirmObscurePassword = true;

  Map<String, dynamic> userData = {};

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm password field is required";
    }
    if (value != _passwordController.text) {
      return "Password do not match";
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await Future.delayed(Duration(seconds: 2));
    try {
      final UserCredential credential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
      }
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        showMessage(
          "Registration Successful! Please verify your email",
          context,
          mounted,
        );
        await Future.delayed(Duration(seconds: 1));
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = "Account already exists";
          break;
        case 'invalid-email':
          message = "the email address is invalid";
          break;
        case 'weak-password':
          message = "the password is too weak";
          break;
        case 'operation-not-allowed':
          message = "Email/Password Authentication is not enabled";
          break;
        default:
          message = e.message ?? "Something went wrong";
      }

      showMessage(message, context, mounted);
    } catch (e) {
      showMessage(
        'Something went worng, please try again later',
        context,
        mounted,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 0, 0, 0),

      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.purple, Colors.black],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Create your\naccount",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                left: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(132, 37, 36, 36),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              Positioned(
                top: 45,
                right: 30,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _nameController,
                          decoration: inputDecoration(
                            label: "name",
                            hint: "please enter your name",
                            icon: Icons.abc,
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: validateName,
                        ),
                        SizedBox(height: 13),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _emailController,
                          decoration: inputDecoration(
                            label: "email",
                            hint: "please enter your email",
                            icon: Icons.email,
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: validateEmail,
                        ),
                        SizedBox(height: 13),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _passwordController,
                          decoration: inputDecoration(
                            label: "password",
                            hint: "please enter your password",
                            icon: Icons.password_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: obscurePassword,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: validatePassword,
                        ),
                        SizedBox(height: 13),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _confirmPasswordController,
                          decoration: inputDecoration(
                            label: "confirm password",
                            hint: "please confirm your password",
                            icon: Icons.key_off,
                            suffixIcon: IconButton(
                              icon: Icon(
                                confirmObscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  confirmObscurePassword =
                                      !confirmObscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: confirmObscurePassword,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: validateConfirmPassword,
                        ),
                        SizedBox(height: 13),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 113, 20, 129),
                                Color.fromARGB(255, 150, 84, 161),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
