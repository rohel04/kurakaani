import 'package:flutter/material.dart';

class TweenImage extends StatefulWidget {

  final Image image;


  const TweenImage({Key? key, required this.image}) : super(key: key);

  @override
  State<TweenImage> createState() => _TweenImageState();
}

class _TweenImageState extends State<TweenImage> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(tween: Tween<double>(begin: 0,end: 1), duration: const Duration(seconds: 5), builder: (context,tween,child){
      return Opacity(opacity: tween,child: child);
    },
      child: widget.image,
    );
  }
}
