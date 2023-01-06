import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication_bloc.dart';

class FormValidation {
  static Future<void> startAuthentication(BuildContext buildContext,
      GlobalKey<FormState> _formKey, AuthenticationEvent event) async {
    bool? validity = _formKey.currentState?.validate();
    if (validity!) {
      _formKey.currentState?.save();
      buildContext.read<AuthenticationBloc>().add(event);
    }
  }
}
