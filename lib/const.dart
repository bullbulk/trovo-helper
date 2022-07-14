import 'package:flutter/material.dart';

const configFilename = "trovo_handler.json";

const clientIdKey = "clientId";
const clientSecretKey = "clientSecret";
const refreshTokenKey = "refreshToken";
const targetChannelNameKey = "targetChannelName";
const roleManaAmountKey = "roleManaAmount";
const roleNameKey = "roleName";

const commonMedals = {
  "creator": Icon(Icons.videocam_rounded, color: Colors.red),
  "ace": Icon(Icons.add_circle_outline, color: Colors.orange),
  "ace_plus": Icon(Icons.add_circle, color: Colors.orangeAccent),
  "editor": Icon(Icons.edit, color: Colors.blue),
  "supermod": Icon(Icons.shield, color: Colors.purpleAccent),
  "moderator": Icon(Icons.accessible_forward, color: Colors.purple),
};
