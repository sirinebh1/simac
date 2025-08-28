
import 'package:flutter/material.dart';
import 'package:pfe/screens/login.dart';


class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key, this.buttonText});
final String? buttonText;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(e)=>const loginScreen(),
          ),
        );
      },
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(900),
          topRight: Radius.circular(900),
          bottomLeft: Radius.circular(900),
          bottomRight: Radius.circular(900),

        )
      ),
      child: Text(
        textAlign: TextAlign.center,
        buttonText!,
        style: const TextStyle(

          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Color(0xFF063057),
          //color: #0630,
        ),
      ),
    ),
    );
  }
}