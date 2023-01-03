import 'package:flutter/material.dart';
import 'package:kurakaani/utils/color_utils.dart';

class TweenText extends StatefulWidget {

  final String title;
  final double fontSize;
  FontWeight fontWeight;
  Color fontColor;

   TweenText({Key? key, required this.title, required this.fontSize,this.fontWeight=FontWeight.normal,this.fontColor=Colors.white}) : super(key: key);

  @override
  State<TweenText> createState() => _TweenTextState();
}

class _TweenTextState extends State<TweenText> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(tween: Tween<double>(begin: 0,end: 1), duration: const Duration(seconds: 3), builder: (context,tween,child){
      return Opacity(opacity: tween,child: child);
    },
    child: Text(widget.title,style: TextStyle(fontWeight: widget.fontWeight,fontSize: widget.fontSize,color: widget.fontColor)),
    );
  }
}
