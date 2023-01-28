import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurakaani/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:kurakaani/router.dart';
import 'package:kurakaani/utils/form_validation.dart';
import '../utils/color_utils.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {

  final _formKey=GlobalKey<FormState>();
  File? imageFile;
  TextEditingController _fNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Profile'),
      ),
      body: BlocProvider(
        create: (context) => AuthenticationBloc(),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is completeProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Profile Completed'),
                  backgroundColor: Colors.green));
              Navigator.pushNamedAndRemoveUntil(
                  context, Routers.homeScreen, (route) => false);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                        child: SizedBox.fromSize(
                            size: Size.fromRadius(100),
                            child: imageFile != null
                                ? Image.file(imageFile!,
                                    fit: BoxFit.cover, height: 250)
                                : Image.asset(
                                    'assets/images/profile_default.jpg',
                                    fit: BoxFit.cover,
                                    height: 250,
                                  ))),
                    const SizedBox(height: 20),
                    InkWell(
                        onTap: () async{
                          await showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    height: 150,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Pick image from :',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap:(){
                              getFromCamera();
                                Navigator.pop(context);
                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20, horizontal: 50),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.camera_alt,size: 40),
                                                    Text(
                                                      'Camera',
                                                      style:
                                                          TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: (){
                                              getFromGallery();
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20, horizontal: 50),
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.photo,size: 40,),
                                                    Text('Gallery',
                                                        style: TextStyle(
                                                            fontSize: 14,fontWeight: FontWeight.bold))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));

                        },
                        child: const Text(
                          'Click to choose profile picture',
                          style: TextStyle(fontSize: 18),
                        )),
                    const SizedBox(height: 50),
                    Form(
                      key: _formKey,
                        child: Column(
                      children: [
                        TextFormField(
                          controller: _fNameController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter FullName';
                            }
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: ColorUtils.kButtonColor,
                              ),
                              hintText: 'Full Name',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400))),
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () async {
                                await FormValidation.startAuthentication(context, _formKey,CompleteProfileEvent(fullName: _fNameController.text,profilePic: imageFile));

                              },

                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(5),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorUtils.kButtonColor),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(double.infinity, 50)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              child: state is AuthenticationLoading
                                  ? SpinKitFadingCircle(
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : Text('Complete Profile'),
                            );
                          },
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getFromCamera() async {
    XFile? xFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 1500, maxWidth: 1500,imageQuality: 20);
    if (xFile != null) {
      setState(() {
        imageFile = File(xFile.path);
      });
    }
  }

  Future<void> getFromGallery() async {
    XFile? xFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500,imageQuality: 20);
    if (xFile != null) {
      setState(() {
        imageFile = File(xFile.path);
      });
    }
  }
}
