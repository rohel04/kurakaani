import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/color_utils.dart';

class CustomCachedImage{

static Widget customCachedImage({userModel}){
  return CachedNetworkImage(
                                      height: 50,
                                      width: 50,
                                      imageUrl: userModel.profilePic!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 80.0,
                                        height: 80.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) => SpinKitCircle(size: 20, color: ColorUtils.kButtonColor,),
                                    );
}

}