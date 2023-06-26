import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Color backgroundColor;
  final Color buttonColor;
  final VoidCallback? onButtonPressed;

  const CustomAlertDialog({super.key, 
    required this.title,
    required this.message,
    this.backgroundColor = Colors.white,
    this.buttonColor = const Color(0xFF6FB0FF),
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.blue,
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.blue,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'OK',
            style: GoogleFonts.poppins(
              color: Colors.white,
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}



// AUTH DIALOGS 

// SIGN IN
void wrongEmailMessage(BuildContext context) {
  showDialog(
    context: context,
    builder: (builder) {
      return const CustomAlertDialog(
        title: 'Correo Incorrecto',
        message: 'No existe una cuenta asociada a este correo, revisa tus datos',
      );
    },
  );
}


void wrongPasswordMessage(BuildContext context) {
  showDialog(
    context: context,
    builder: (builder) {
      return const CustomAlertDialog(
        title: 'Contraseña Incorrecta',
        message: 'La contraseña proporcionada no es correcta, verifique sus datos',
      );
    },
  );
}

// SIGN UP
void emailAlreadyUsed(BuildContext context) {
  showDialog(
    context: context,
    builder: (builder) {
      return const CustomAlertDialog(
        title: 'Cuenta ya existe',
        message: 'Actualmente existe una cuenta asociada a este correo, revise sus datos',
      );
    },
  );
}

void mismatchPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return const CustomAlertDialog(
          title: 'Claves no coinciden',
          message: 'Las contraseñas proporcionadas no son iguales, revise sus datos',
        );
      },
    );
  }

void invalidPasswordMessage(BuildContext context) {
  showDialog(
    context: context,
    builder: (builder) {
      return const CustomAlertDialog(
        title: 'Contraseña débil',
        message: 'La contraseña propuesta no cumple con los criterios de seguridad, revise sus datos',
      );
    },
  );
}