import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

String userIdKey = "";

void sharedPreferencesUtil() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String storedToken = prefs.getString('jwtToken') ?? '';

  // Decode the stored token
  List<String> tokenParts = storedToken.split('.');
  String encodedPayload = tokenParts[1];
  String decodedPayload = utf8.decode(base64Url.decode(encodedPayload));

  // Parse the decoded payload as JSON
  Map<String, dynamic> payloadJson = jsonDecode(decodedPayload);

  // Access the token claims from the payload
  userIdKey = payloadJson['_id'];
  print('From sharedPreferences: $userIdKey');
}
