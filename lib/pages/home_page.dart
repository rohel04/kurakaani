import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kurakaani/utils/back_press_func.dart';
import 'package:kurakaani/utils/color_utils.dart';
import 'package:kurakaani/utils/constants.dart';
import 'package:kurakaani/widgets/shimmer_loading.dart';
import 'package:kurakaani/router.dart';
import '../bloc/authentication_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    final authentication=BlocProvider.of<AuthenticationBloc>(context);

    return WillPopScope(
      onWillPop:(){
        return BackPress.onBackPressed(context);
      },
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: ColorUtils.kButtonColor,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async{
                      await authentication.signOut();
                      // Navigator.pushNamedAndRemoveUntil(context, Routers.loginScreen, (route) => false);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.logout_sharp,color: Colors.white,),
                        SizedBox(width: 20),
                        Text('Sign Out',style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children:[ Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Image.asset('assets/icons/appbar_icon.png',height: 30,width: 30)),
                const SizedBox(width: 5),
                const  Text(TextConstants.appBarTitle)
              ]),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.dark_mode))
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.pushNamed(context, Routers.searchScreen);
        },
          backgroundColor: ColorUtils.kButtonColor,
        child:const Icon(Icons.search),
        ),
        body: SafeArea(
          child: ShimmerLoading.shimmerLoading()
        ),
      ),
    );
  }
}
