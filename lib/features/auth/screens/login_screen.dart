import 'package:easypet/features/auth/controllers/login_controller.dart';
import 'package:easypet/features/auth/screens/register_screen.dart';
import 'package:easypet/features/auth/screens/forgotten_password.dart';
import 'package:easypet/core/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String result = "";
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isSuccess = false;

  final AuthController _authController = AuthController();

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      result = "";
      _isSuccess = false;
    });

    final email = emailController.text;
    final password = passwordController.text;

    final response = await _authController.login(email, password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    final success = response["success"] == true;
    if (success) {
      setState(() {
        _isSuccess = true;
        result = "Login successful! Redirecting...";
      });
      
      // Wait a moment to show success message
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    } else {
      setState(() { 
        result = response["message"]?.toString() ?? "Error desconocido";
        _isSuccess = false;
      });
    }
  }

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> const ForgottenPasswordScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final Size screenSize = media.size;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Text(
            'EASYPET',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 48, 45, 5),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logos/easypet_logo.jpg',
                      width: 100.0,
                      height: 100.0,
                      errorBuilder: (context, error, stackTrace) {
                        return const FlutterLogo(size: 100.0);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                    labelText: 'Correo electrónico',
                    icon: Icon(Icons.email),
                    iconColor: Colors.deepPurple,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo electrónico';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    labelText: 'Ingresa tu contraseña',
                    icon: const Icon(Icons.lock),
                    iconColor: Colors.deepPurple,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
              ),
              // Forgot password link - positioned below password input
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: _isLoading ? null : navigateToForgotPassword,
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle( 
                      color: Colors.deepPurple,
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              // Error message display
              if (result.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: _isSuccess ? Colors.green.shade200 : Colors.red.shade200),
                  ),
                  child: Text(
                    result,
                    style: TextStyle(
                      color: _isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Login and Register buttons
              Container(
                width: screenSize.width,
                margin: const EdgeInsets.only(top: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Login button
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 2.0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    // Register button
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : navigateToRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.deepPurple,
                            width: 2.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0.0,
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
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
    );
  }
}
