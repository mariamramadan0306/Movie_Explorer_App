import 'package:demo/Pages/HomePage.dart';
import 'package:demo/Pages/SignUpPage.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isloading = false;

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      hintText: hint,
      hintStyle: TextStyle(color: const Color.fromARGB(115, 255, 255, 255)),
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(width: 2),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: const Color.fromARGB(255, 59, 59, 59),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email field is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@[\w-]+\.[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return "Invalid Email Format";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email field is required";
    }
    if (value.trim().length < 6) {
      return "Password Must be at least 6 chars";
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isloading = true;
    });
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isloading = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
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
                    "Sign in to\nContinue",
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
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    "Sign up",
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
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 25),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration(
                            label: "email",
                            hint: "please enter your email",
                            icon: Icons.email,
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: _validateEmail,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: _inputDecoration(
                            label: "password",
                            hint: "please enter your password",
                            icon: Icons.password_outlined,
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 16),
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
                            onPressed: () {
                              _isloading ? null : _submitForm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: _isloading
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    "Sign in",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "or continue with",
                          style: TextStyle(
                            color: const Color.fromARGB(75, 151, 151, 151),
                          ),
                        ),
                        Divider(
                          color: const Color.fromARGB(75, 151, 151, 151),
                          height: 25,
                        ),

                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 50),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.g_mobiledata_sharp,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  label: const Text(
                                    "Google",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    side: const BorderSide(
                                      color: Colors.purple,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              SizedBox(
                                width: 150,
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.apple,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    "Apple",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
