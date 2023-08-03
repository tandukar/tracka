import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

String userIdKey = "";

Future<String> sharedPreferencesUtil() async {
  try {
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
    print(userIdKey);
    return userIdKey;
  } catch (e) {
    print("Error while reading data from shared preferences: $e");
    // Return a default value or throw the error further based on your requirements
    return ''; // Return an empty string in case of an error.
  }
}
