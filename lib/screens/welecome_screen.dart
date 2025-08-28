import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfe/widgets/custom_scaffold.dart';
import 'package:pfe/widgets/welcome_button.dart';

class WelecomeScreen extends StatelessWidget {
  const WelecomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return  CustomScaffold(
      child: Column(
        children: [
         Flexible(
           flex: 8,
      child: Container(
      margin:  const EdgeInsets.only(bottom: 500.0),
      child: Center(
        child: RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
          children: [
            TextSpan(
              text: 'BIENVENUE!\n',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w600,
                fontFamily: 'Seymour One',
                fontStyle: FontStyle.italic,
              )
            ),

          ],
      ),
    ),),
    )),
          const Flexible(
            flex: 2,
            child:Align(
              alignment:Alignment.center,
              child:Row(
              children: [
                Expanded(
                  child:WelcomeButton(
                    buttonText: 'Se Connecter',
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