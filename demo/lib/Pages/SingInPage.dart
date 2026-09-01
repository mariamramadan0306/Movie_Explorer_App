import 'package:demo/Components/loginForgotPasswordView.dart';
import 'package:demo/Pages/SignUpPage.dart';
import 'package:demo/config/api_config.dart';
import 'package:demo/utils/show_message.dart';
import 'package:demo/utils/sign_in_up_inputDecoration.dart';
import 'package:demo/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  bool obscurePassword = true;
  bool rememberCredentials = true;

  Future<void> initializeGoogleSignIn() async {
    await googleSignIn.initialize(clientId: ApiConfig.googleClientKey);
  }

  @override
  void initState() {
    super.initState();
    initializeGoogleSignIn();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _emailController.text = preferences.getString('saved_email') ?? '';
      _passwordController.text = preferences.getString('saved_password') ?? '';
      rememberCredentials = preferences.getBool('remember_credentials') ?? true;
    });
  }

  Future<void> _saveCredentials(String email, String password) async {
    final preferences = await SharedPreferences.getInstance();
    if (rememberCredentials) {
      await preferences.setString('saved_email', email);
      await preferences.setString('saved_password', password);
      await preferences.setBool('remember_credentials', true);
    } else {
      await preferences.remove('saved_email');
      await preferences.remove('saved_password');
      await preferences.setBool('remember_credentials', false);
    }
  }

  Future signInWithGoogle() async {
    try {
      final GoogleAuthProvider provider = GoogleAuthProvider();
      final UserCredential credential = await auth.signInWithPopup(provider);
      final User? user = credential.user;

      if (user == null) {
        showMessage("Google sign in failed", context, mounted);
        return;
      }
    } on FirebaseAuthException catch (e) {
      showMessage("error: ${e.message ?? e.code}", context, mounted);
    } catch (e) {
      showMessage("Google sign in failed: $e", context, mounted);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await Future.delayed(Duration(seconds: 2));

    try {
      final UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user == null) {
        showMessage("Login failed, please try again", context, mounted);
        return;
      }
      if (!user.emailVerified) {
        await auth.signOut();
        showMessage(
          "Please verify you email before logging in",
          context,
          mounted,
        );
        return;
      }
      await _saveCredentials(email, password);
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = "Email address is not valid";
          break;

        case 'user-not-found':
          message = "Account doesn't exist with this email";
          break;

        case 'invalid-credential':
          message = "Invalid email or password";
          break;

        case 'user-disabled':
          message = "This account has been disabled";
          break;

        case 'too-many-requests':
          message = "Too many login attempts, try again later";
          break;

        case 'operation-not-allowed':
          message = "Email/Password authentication is not enabled";
          break;

        default:
          message = e.message ?? "Login failed";
      }

      showMessage(message, context, mounted);
    } catch (e) {
      showMessage("something went wrong", context, mounted);
    }
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
                        SizedBox(height: 16),
                        TextFormField(
                          obscureText: obscurePassword,
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
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validator: validatePassword,
                        ),
                        SizedBox(height: 16),
                        CheckboxListTile(
                          value: rememberCredentials,
                          onChanged: (value) {
                            setState(() {
                              rememberCredentials = value ?? false;
                            });
                          },
                          title: const Text(
                            'Remember me',
                            style: TextStyle(color: Colors.white),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: Colors.purple,
                        ),
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
                              "Sign in",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              showForgotPasswordModal(context, mounted);
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        Center(
                          child: SizedBox(
                            width: 280,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: signInWithGoogle,
                              icon: Icon(
                                Icons.g_mobiledata_sharp,
                                color: Colors.purple,
                                size: 28,
                              ),
                              label: const Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
