import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joursafe/components/rounded_tile.dart';
import 'package:joursafe/components/sign_button.dart';
import 'package:joursafe/components/textfield.dart';
import 'package:joursafe/theme.dart';
import 'package:provider/provider.dart';
import '../services/auth/auth_service.dart';

class SetupAccountPage extends StatefulWidget {
  final Function()? onTap;
  const SetupAccountPage({super.key, required this.onTap});

  @override
  State<SetupAccountPage> createState() => _SetupAccountPageState();
}

class _SetupAccountPageState extends State<SetupAccountPage> {
  // TEXTFIELD CONTROLLERS
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // SIGN IN METHOD
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
        ),
      );
      return;
    }

    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(
        emailController.text, 
        passwordController.text
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFF6FB0FF)),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 0),
              const Padding(padding: EdgeInsets.all(5)),
              SvgPicture.asset(
                'lib/icons/timmy-content.svg',
                width: 180,
              ),
              Text("¡Joursafe te espera!", style: title),
              Text("Regístrate y disuta de un viaje seguro", style: subtitle),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.all(30),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        textStyle: GoogleFonts.poppins(),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Contraseña',
                        obscureText: true,
                        textStyle: GoogleFonts.poppins(), // Assuming it's a password field
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirmar Contraseña',
                        obscureText: true,
                        textStyle: GoogleFonts.poppins(), // Assuming it's a password field
                      ),
                      const SizedBox(height: 20),
                      CustomButton(text: 'Regístrate', onTap: signUp),
                      const SizedBox(height: 20),
                       Row(
                        children: [
                          const Expanded(child: Divider(thickness: 0.5, color: Colors.black)),
                            Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('O continúa con', style: normalSize),
                          ),
                          const Expanded(child: Divider(thickness: 0.5, color: Colors.black)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // GOOGLE
                          RoundTile(
                            onTap: () => AuthService().signInWithGoogle(),
                            svgPath: 'lib/icons/logo-google.svg'),
      
                          const SizedBox(width: 20),
      
                          // FACEBOOK
                          RoundTile(
                            onTap: () {},
                            svgPath: 'lib/icons/logo-facebook.svg')
                        ],
                      ),
                      const SizedBox(height: 20),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('¿Ya tienes una cuenta?', style: normalSize),
                          const SizedBox(width: 5),
                          SizedBox(
                            height: 20,
                            child: InkWell(
                              onTap: widget.onTap,
                              child: Text('Inicia sesión aquí', style: normalSize.copyWith(color: bgColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
