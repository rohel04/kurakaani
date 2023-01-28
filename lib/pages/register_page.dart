import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kurakaani/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:kurakaani/utils/color_utils.dart';
import 'package:kurakaani/utils/form_validation.dart';
import 'package:kurakaani/widgets/auth_logo.dart';

import '../router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey=GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cPasswordController = TextEditingController();

  Future<void> startAuthentication() async {
    bool? validity = _formKey.currentState?.validate();
    if (validity!) {
      _formKey.currentState?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBackgroundColor,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is UserRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Registration Successful'),
                backgroundColor: Colors.green));
            Navigator.pushNamedAndRemoveUntil(context, Routers.completeProfileScreen,(Route route)=>false);
          }
          if (state is UserRegistrationFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red));
          }
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthenticationLogo.authenticationLogo(),
                    const SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            key: ValueKey('email'),
                            validator: (value){
                              if(value!.isEmpty || !value.contains('@')){
                                return 'Incorrect Email';
                              }
                              return null;
                            },
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_sharp,
                                  color: ColorUtils.kButtonColor,
                                ),
                                hintText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400))),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            key: ValueKey('password'),
                            validator: (value){
                              if(value!.length<8){
                                return 'Password must at least be of length 8';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText:
                                _passwordVisible == true ? false : true,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: ColorUtils.kButtonColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _passwordVisible != false
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: ColorUtils.kButtonColor,
                                  ),
                                ),
                                hintText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400))),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            key: ValueKey('cPassword'),
                            validator: (value){
                              if(value!= _passwordController.text){
                                return 'Password not matched';
                              }
                              return null;
                            },
                            controller: _cPasswordController,
                            obscureText: _confirmPasswordVisible == true
                                ? false
                                : true,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: ColorUtils.kButtonColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _confirmPasswordVisible =
                                          !_confirmPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _confirmPasswordVisible != false
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: ColorUtils.kButtonColor,
                                  ),
                                ),
                                hintText: 'Confirm Password',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400))),
                          ),
                          const SizedBox(height: 30),
                          BlocBuilder<AuthenticationBloc,
                              AuthenticationState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () async{
                                  await FormValidation.startAuthentication(context, _formKey,  RegisterUserEvent(email: _emailController.text, password: _passwordController.text,));

                                  // context.read<AuthenticationBloc>().add(
                                  //     RegisterUserEvent(
                                  //         email: _emailController.text,
                                  //         password:
                                  //             _passwordController.text));
                                  // Navigator.pushNamedAndRemoveUntil(
                                  //     context,
                                  //     Routers.completeProfileScreen,
                                  //         (Route route) => false);
                                },
                                style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(5),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorUtils.kButtonColor),
                                  minimumSize:
                                      MaterialStateProperty.all<Size>(
                                          const Size(double.infinity, 50)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                child: state is AuthenticationLoading? SpinKitFadingCircle(color:Colors.white,size: 30,): Text('Sign Up'),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have account ? "),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  )
                                ]),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
