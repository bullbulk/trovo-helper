import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';

Future<void> initImages() async {
  await loadMedalsWidgets();
  await loadImageWidgets();
}

Future<Iterable> getAssets() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  return jsonDecode(manifestJson).keys;
}

Map<String, Widget> medalsWidgets = {};

Future<void> loadMedalsWidgets() async {
  var assets = await getAssets();
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

Map<String, ScalableImageWidget> imagesWidgets = {};

Future<void> loadImageWidgets() async {
  var assets = await getAssets();

  for (var assetKey in assets) {
    if (!assetKey.startsWith("assets/images") ||
        assetKey.startsWith("assets/images/medals") ||
        !assetKey.endsWith(".svg")) {
      continue;
    }
    var si = await ScalableImage.fromSvgAsset(rootBundle, assetKey);
    var name = assetKey.split("/").last.split(".")[0];
    imagesWidgets[name] = ScalableImageWidget(si: si);
  }
}
