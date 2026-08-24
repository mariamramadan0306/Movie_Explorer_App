import 'package:demo/Pages/HomePage.dart';
import 'package:demo/Pages/SingInPage.dart';
import 'package:demo/Providers/UserDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Map<String, dynamic> userData = {};
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

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name field is required";
    }
    if (value.length < 3) {
      return "name must be at least 3 characters";
    }
    return null;
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
      return "Password field is required";
    }
    if (value.trim().length < 6) {
      return "Password Must be at least 6 chars";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email field is required";
    }
    if (value != _passwordController.text) {
      return "Password do not match";
    }
    return null;
  }

  Future<void> _submitForm(UserDataModel user) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isloading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    userData = {"name": _nameController.text, "email": _emailController.text};
    user.userData.addAll(userData);
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
                          controller: _nameController,
                          decoration: _inputDecoration(
                            label: "name",
                            hint: "please enter your name",
                            icon: Icons.abc,
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: _validateName,
                        ),
                        SizedBox(height: 13),
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
                        SizedBox(height: 13),
                        TextFormField(
                          controller: _passwordController,
                          decoration: _inputDecoration(
                            label: "password",
                            hint: "please enter your password",
                            icon: Icons.password_outlined,
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,

                          textInputAction: TextInputAction.next,
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 13),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: _inputDecoration(
                            label: "confirm password",
                            hint: "please confirm your password",
                            icon: Icons.key_off,
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: _validateConfirmPassword,
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
                          child: Consumer<UserDataModel>(
                            builder: (context, user, child) => ElevatedButton(
                              onPressed: () {
                                _isloading ? null : _submitForm(user);
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
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
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
