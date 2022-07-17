import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';

Map<String, Widget> medalsWidgets = {};

Future<void> loadMedalsWidgets() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  var assets = jsonDecode(manifestJson).keys;

  for (var assetKey in assets) {
    if (!assetKey.startsWith("assets/images/medals") ||
        !assetKey.endsWith(".svg")) continue;

    var si = await ScalableImage.fromSvgAsset(rootBundle, assetKey);
    var name = assetKey.split("/").last.split(".")[0];
    medalsWidgets[name] = Tooltip(
      message: name,
      child: ScalableImageWidget(si: si),
    );
  }
}
