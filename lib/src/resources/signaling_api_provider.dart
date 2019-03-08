import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";

import "../../settings.dart";

// Required types
enum SignalingResponse { SUCCESSFULL, NO_DEVICE, NO_DATA }

class SignalingApiProvider {
  Future<List<dynamic>> getUserDevices(String userId) async {
    var response = await http.get("$baseUrlSignaling/user/$userId/devices");
    return jsonDecode(response.body);
  }

  Future<SignalingResponse> sendData(
      String userId, String deviceId, Map<String, dynamic> data) async {
    var response = await http.post(
        "$baseUrlSignaling/user/$userId/device/$deviceId",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"data": data}));

    switch (response.statusCode) {
      case 200:
        return SignalingResponse.SUCCESSFULL;
      case 400:
        return SignalingResponse.NO_DATA;
      case 404:
        return SignalingResponse.NO_DEVICE;
      default:
        return SignalingResponse.NO_DEVICE;
    }
  }
}
