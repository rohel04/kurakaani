import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kurakaani/bloc/authentication_bloc.dart';
import 'package:kurakaani/utils/color_utils.dart';
import 'package:kurakaani/utils/form_validation.dart';
import 'package:kurakaani/utils/back_press_func.dart';
import '../router.dart';
import 'package:kurakaani/widgets/auth_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return WillPopScope (
      onWillPop: (){
        return BackPress.onBackPressed(context);
      },
      child: Scaffold(
        backgroundColor: ColorUtils.kBackgroundColor,
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is UserLoginFailed) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red));
            }
            if (state is UserLoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Login Successful'),
                  backgroundColor: Colors.green));
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
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Incorrect Email';
                                }
                                return null;
                              },
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
                              controller: _passwordController,
                              key: ValueKey('password'),
                              validator: (value){
                                if(value!.isEmpty||value.length<8){
                                  return 'Password must at least be of length 8';
                                }
                                return null;
                              },
                              obscureText:
                                  _passwordVisible == true ? false : true,
                              textInputAction: TextInputAction.done,
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
                            BlocBuilder<AuthenticationBloc,
                                AuthenticationState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    await FormValidation.startAuthentication(context, _formKey, LoginUserEvent(email: _emailController.text, password: _passwordController.text,));

                                    // Navigator.pushNamedAndRemoveUntil(context, Routers.homeScreen, (route) => false);
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
                                  child: state is AuthenticationLoading? SpinKitFadingCircle(color:Colors.white,size: 30,) :Text('Sign In'),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have account ? "),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, Routers.registerScreen);
                                      },
                                      child: const Text(
                                        'Sign Up',
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
      ),
    );
  }
}
