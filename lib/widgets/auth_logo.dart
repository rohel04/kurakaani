import 'package:flutter/material.dart';

class AuthenticationLogo{

  static Widget authenticationLogo(){
    return Column(
      children: [
        Image.asset('assets/icons/chat_icon.png',
            height: 70, width: 70),
        const Text('KuraKaani',style: TextStyle(fontSize: 20),),
      ],
    );
  }

}