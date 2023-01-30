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

import 'dart:io';
import 'dart:convert';
import 'package:yiot_portal/model/yiot-device.dart';
import 'package:yiot_portal/model/yiot-license.dart';

class YIoTProvision {
  // ---------------------------------------------------------------------------
  //
  //  Base directory
  //
  static String _baseDir() {
    Map<String, String> envVars = Platform.environment;

    // Get home directory
    String homeDir = "";
    var h = envVars['HOME'];
    if (h != null) {
      homeDir = h!;
    }
    var baseDir = homeDir + '/yiot';

    // Run Provisioning process
    return baseDir;
  }

  // ---------------------------------------------------------------------------
  //
  //  Start device provision
  //
  static Future<Process> start() async {
    return await Process.start('bash', ['-c', _baseDir() + '/start-yiot-factory-tool.sh']);
  }

  // ---------------------------------------------------------------------------
  //
  //  Process provision artifacts
  //
  static Future<YIoTLicense> processArtifacts() async {
    var res = YIoTLicense.blank();
    var artifacts = File(_baseDir() + '/artifacts/output.txt');

    // Read result file
    var str;
    try {
      final file = await artifacts;

      // Read the file
      str = await file.readAsString();
    } catch (e) {
      return res;
    }

    // Decode base64
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String jsonText = stringToBase64.decode(str);

    // Parse license JSON
    var json;
    try {
      json = json.decode(jsonText);
    } catch (e) {
      return res;
    }

    // Get license data


    return str;
  }
}

// -----------------------------------------------------------------------------
