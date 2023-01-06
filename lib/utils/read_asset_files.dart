import 'dart:convert';
import 'package:flutter/material.dart';

Future<List<String>> readAssetFiles({required context, String? subPath}) async {
  List<String> list = [];
  dynamic files;

  final manifestJson =
      await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
  if(subPath == null) {
    files = json
        .decode(manifestJson)
        .keys
        .where((String key) => key.startsWith('assets/'));
  }else{
    files = json
        .decode(manifestJson)
        .keys
        .where((String key) => key.startsWith('assets/$subPath'));
  }

  list.addAll(files);
  return list;
}
