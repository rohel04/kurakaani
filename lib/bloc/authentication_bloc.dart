import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kurakaani/models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<RegisterUserEvent>((event, emit) async=> await RegisterUser(event,emit));
    on<LoginUserEvent>((event, emit) async=> await LoginUser(event,emit));
    on<CompleteProfileEvent>((event, emit) async=> await completeUserProfile(event, emit));
  }

  Stream<User?> get user{
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  Future<void> RegisterUser(RegisterUserEvent event, Emitter<AuthenticationState> emit) async{
    emit(AuthenticationLoading());
    try{
      UserCredential? userCredential=await _firebaseAuth.createUserWithEmailAndPassword(email: event.email, password: event.password);
      String uid=userCredential.user!.uid;
      UserModel newUser=UserModel(
        uid: uid,
        email: userCredential.user!.email,
        fullName: '',
        profilePic: ''
      );
      await _firebaseFirestore.collection('users').doc(uid).set(newUser.toMap());
      emit(UserRegistrationSuccess());
      
    }on FirebaseAuthException catch(e){
      switch(e.code){
        case 'email-already-in-use':
          emit(UserRegistrationFailed(message: 'Email already in use'));
      }
    }
  }

  Future<void> LoginUser(LoginUserEvent event, Emitter<AuthenticationState> emit) async{
    emit(AuthenticationLoading());
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: event.email, password: event.password);
      // String uid= userCredentials.user!.uid;
      // DocumentSnapshot userData=await _firebaseFirestore.collection('users').doc(uid).get();
      // UserModel userModel=UserModel.fromMap(userData.data() as Map<String,dynamic>);
      emit(UserLoginSuccess());
    }on FirebaseAuthException catch(e){
      switch(e.code){
        case 'user-not-found':
            emit(UserLoginFailed(message: 'User not found !!'));
            break;
        case 'wrong-password':
            emit(UserLoginFailed(message: 'Invalid Credentials !!'));
            break;
      }
    }
  }

  Future<void> completeUserProfile(CompleteProfileEvent event,Emitter<AuthenticationState> emit) async{
    emit(AuthenticationLoading());
    try{
      final uid=_firebaseAuth.currentUser!.uid;
      final email=_firebaseAuth.currentUser!.email;
      final uploadTask=await FirebaseStorage.instance.ref("Profile_Pictures").child(uid.toString()).putFile(event.profilePic!);
      String imageUrl=await uploadTask.ref.getDownloadURL();
      await _firebaseFirestore.collection('users').doc(uid).set({'email':email,'fullname':event.fullName,'profilepic':imageUrl,'uid':uid});
      emit(completeProfileSuccess());
    }catch(e){
      emit(completeProfileFailure());
    }
  }
}
