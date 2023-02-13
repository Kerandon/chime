import 'package:flutter/material.dart';

Future<int> cacheImage({required BuildContext context, required String url}) async {
  await precacheImage(Image.asset(url).image, context);
  return 1;
}