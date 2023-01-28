//  ────────────────────────────────────────────────────────────
//                     ╔╗  ╔╗ ╔══╗      ╔════╗
//                     ║╚╗╔╝║ ╚╣╠╝      ║╔╗╔╗║
//                     ╚╗╚╝╔╝  ║║  ╔══╗ ╚╝║║╚╝
//                      ╚╗╔╝   ║║  ║╔╗║   ║║
//                       ║║   ╔╣╠╗ ║╚╝║   ║║
//                       ╚╝   ╚══╝ ╚══╝   ╚╝
//    ╔╗╔═╗                    ╔╗                     ╔╗
//    ║║║╔╝                   ╔╝╚╗                    ║║
//    ║╚╝╝  ╔══╗ ╔══╗ ╔══╗  ╔╗╚╗╔╝  ╔══╗ ╔╗ ╔╗╔╗ ╔══╗ ║║  ╔══╗
//    ║╔╗║  ║║═╣ ║║═╣ ║╔╗║  ╠╣ ║║   ║ ═╣ ╠╣ ║╚╝║ ║╔╗║ ║║  ║║═╣
//    ║║║╚╗ ║║═╣ ║║═╣ ║╚╝║  ║║ ║╚╗  ╠═ ║ ║║ ║║║║ ║╚╝║ ║╚╗ ║║═╣
//    ╚╝╚═╝ ╚══╝ ╚══╝ ║╔═╝  ╚╝ ╚═╝  ╚══╝ ╚╝ ╚╩╩╝ ║╔═╝ ╚═╝ ╚══╝
//                    ║║                         ║║
//                    ╚╝                         ╚╝
//
//    Lead Maintainer: Roman Kutashenko <kutashenko@gmail.com>
//  ────────────────────────────────────────────────────────────

import 'package:http/http.dart' as http;

class YIoTRestHelpers {
  // ---------------------------------------------------------------------------
  //
  //  Fills required HTTP headers for request to YIoT backend
  //
  static Map<String, String> headers(String token, String owner) {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-YIoT-Identity': owner,
    };

    return headers;
  }

  // ---------------------------------------------------------------------------
  //
  //  Wait health endpoint
  //
  static Future<bool> waitActive(String healthUrl, String token, String owner, int reqDelay, int reqNum) async {

    print(">>> healthUrl = " + healthUrl);
    Uri url = Uri.parse(healthUrl);

    var headers = YIoTRestHelpers.headers(token, owner);

    for (var i = 0; i < reqNum; i++) {
      // Request health endpoint
      final response = await http.get(url, headers: headers);

      // Check response code
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 302) {
        return true;
      }

      // Wait before the next check
      await Future.delayed(Duration(seconds: reqDelay));
    }

    return false;
  }
}

// -----------------------------------------------------------------------------
