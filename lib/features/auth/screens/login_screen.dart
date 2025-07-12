import 'package:easypet/features/auth/controllers/login_controller.dart';
import 'package:easypet/features/auth/screens/register_screen.dart';
import 'package:easypet/features/auth/screens/forgotten_password.dart';
import 'package:easypet/features/home/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easypet/core/services/firebase_auth_service.dart';

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

  final AuthController _authController = AuthController();

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text;
    final password = passwordController.text;

    final response = await _authController.login(email, password);

    if (!mounted) return;

    final success = response["success"] == true;
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() { 
        result = response["message"]?.toString() ?? "Error desconocido";
      });
    }
  }

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void navigateToForgotPassword() { //aqui voy a crear la navegacion a la pantalla de olvide mi contraseña
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
                    labelText: 'E-mail Address',
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
                    hintText: 'Password',
                    labelText: 'Enter your password',
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
              Container(
                width: screenSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      width: 250.0,
                      margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      width: 250.0,
                      margin: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: ElevatedButton(
                        onPressed: navigateToRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.deepPurple,
                            width: 2.0,
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ),
                     Container(
                      height: 50.0,
                      margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                      alignment: Alignment.center, // Para alinear el texto a la izquierda
                      child: GestureDetector(
                        onTap: navigateToForgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle( 
                            color: Colors.blue, // Puedes cambiar el color
                            fontSize: 16.0, // Tamaño del texto
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
             /* Container(
                width: screenSize.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, top: 100.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Login or sign up using'),
                          const SizedBox(height: 5.0),
                          Container(
                            height: 50.0,
                            width: 210.0,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Implementa el inicio de sesión con Google aquí
                              },
                              icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                              label: const Text(
                                'Login with Google+',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
